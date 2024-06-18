
module tb_APB_Master;
    // Testbench signals
    reg PCLK;
    reg PRESETn;
    reg PSEL;
    reg PENABLE;
    reg PWRITE;
    reg [7:0] PADDR;
    reg [7:0] PWDATA;
    wire [7:0] PRDATA;
    wire PREADY;

    // Register to hold read data
    reg [7:0] read_data;

    // Instantiation of APB_Master module
    APB_Master uut (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY)
    );

    // Clock Generation
    initial begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK;
    end

  initial begin
    $vcdplusfile ("decoder_wf.vpd");
    $vcdpluson ();
  end

    // CPU Tasks
    task WRITE(input [7:0] addr, input [7:0] data);
    begin
        PSEL = 1;
        PENABLE = 0;
        PWRITE = 1;
        PADDR = addr;
        PWDATA = data;
        @(posedge PCLK);
        PENABLE = 1;
        @(posedge PCLK);
        while (!PREADY) @(posedge PCLK);
        PSEL = 0;
        PENABLE = 0;
    end
    endtask

    task READ(input [7:0] addr, output [7:0] data);
    begin
        PSEL = 1;
        PENABLE = 0;
        PWRITE = 0;
        PADDR = addr;
        @(posedge PCLK);
        PENABLE = 1;
        @(posedge PCLK);
        while (!PREADY) @(posedge PCLK);
        data = PRDATA;
        PSEL = 0;
        PENABLE = 0;
    end
    endtask

    // Randomization of PREADY signal
    always @(posedge PCLK) begin
        if (PSEL && PENABLE) begin
            uut.PREADY <= $random % 2;
        end
    end

    // Test Sequence
    initial begin
        // Initialize signals
        PRESETn = 0;
        PSEL = 0;
        PENABLE = 0;
        PWRITE = 0;
        PADDR = 8'b0;
        PWDATA = 8'b0;

        // Reset the DUT
        #10 PRESETn = 1;

        // Write and Read from registers
        WRITE(8'd0, 8'hAA);
        WRITE(8'd1, 8'hBB);
        WRITE(8'd2, 8'hCC);
        WRITE(8'd3, 8'hDD);

        #10;

        READ(8'd0, read_data);
        $display("Read data from register 0: %h", read_data);
        READ(8'd1, read_data);
        $display("Read data from register 1: %h", read_data);
        READ(8'd2, read_data);
        $display("Read data from register 2: %h", read_data);
        READ(8'd3, read_data);
        $display("Read data from register 3: %h", read_data);

        $finish;
    end
endmodule
