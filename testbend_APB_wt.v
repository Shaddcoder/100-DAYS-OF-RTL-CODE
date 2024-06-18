module testbend_APB_wt; // write data
	reg PCLK;
	reg PRESETn;
	reg [7:0] PADDR;
	reg PWRITE;
	reg PSEL;
	reg PENABLE;
	reg [7:0] PWDATA;
	
	wire PSLVERR;
	wire PREADY;

decoder_wt decoder_wt_ints (
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.PWRITE(PWRITE),
	.PSEL(PSEL),
	.PENABLE(PENABLE),
	.PADDR(PADDR),
	.PWDATA(PWDATA),
	.PREADY(PREADY),
	.PSLVERR(PSLVERR)
);

initial begin 
	PCLK = 0;
	forever #5 PCLK = ~ PCLK; 
end
initial begin
	PRESETn = 1;
	#5
	PRESETn = 0;
	#10
	PRESETn = 1;
end

initial begin 
		// T1
		#10
    	@(posedge PCLK) 
		PADDR = $urandom_range (8'h00, 8'h07); //$random % 8
		PWDATA = $urandom; 
		PWRITE = 1'b1;
		PSEL = 1'b1;
		PENABLE =1'b0;
		
		//T2 PENABLE assert
		@(posedge PCLK)
		PENABLE = 1'b1;
	
		//T3 deassert signal
		// kiem tra khi pready =1 thi psel and PENABLE = 0
		@(posedge PCLK)
		PSEL = 1'b0;
		PENABLE = 1'b0;
		//end
        #100
        $finish;
end
endmodule

	
