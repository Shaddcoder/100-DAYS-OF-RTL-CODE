

module APB_Master (
    input wire PCLK,
    input wire PRESETn,
    input wire PSEL,
    input wire PENABLE,
    input wire PWRITE,
    input wire [7:0] PADDR,
    input wire [7:0] PWDATA,
    output reg [7:0] PRDATA,
    output reg PREADY
);
    reg [7:0] registers [7:0]; // 8 registers of 8-bit each
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            PREADY <= 0;
            PRDATA <= 8'b0;
            registers[0] <= 8'b0;
            registers[1] <= 8'b0;
            registers[2] <= 8'b0;
            registers[3] <= 8'b0;
            registers[4] <= 8'b0;
            registers[5] <= 8'b0;
            registers[6] <= 8'b0;
            registers[7] <= 8'b0;
        end else if (PSEL && PENABLE) begin
            PREADY <= 1; // PREADY is asserted when PENABLE is asserted
            if (PWRITE) begin
                registers[PADDR] <= PWDATA; // Write to register
            end else begin
                PRDATA <= registers[PADDR]; // Read from register
            end
        end else begin
            PREADY <= 0;
        end
    end
endmodule

