module decoder_wt (
    input PCLK,
    input PRESETn,
    input [7:0] PADDR,
    input PWRITE,
    input PSEL,
    input PENABLE,
    input [7:0] PWDATA, 
    output reg PREADY,
    output reg PSLVERR
);

// Registers for storing data at different addresses
reg [7:0] A;
reg [7:0] B;
reg [7:0] C;
reg [7:0] D;
reg [7:0] E;
reg [7:0] F;
reg [7:0] G;
reg [7:0] H;

// State definitions
reg [1:0] IDLE   = 2'b00;
reg [1:0] SETUP  = 2'b01;
reg [1:0] ACCESS = 2'b10;
reg [1:0] state, next_state;

// Always block to control state machine and data handling
always @ (posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
        // Reset values on reset signal
        A <= 8'h00;
        B <= 8'h00;
        C <= 8'h00;
        D <= 8'h00;
        E <= 8'h4f;
        F <= 8'h00;
        G <= 8'h00;
        H <= 8'h00;
        PREADY  <= 1'b0;
        PSLVERR <= 1'b0;
        state <= IDLE;
    end else begin
        // State machine transitions and operations
        case(state)
            IDLE: begin
                PREADY <= 1'b1;
                PSLVERR <= 1'b0;
                if (PSEL) begin
				PREADY <= 1'b0; 
                  state <= SETUP;
                end
            end
            
            SETUP: begin
                if (PENABLE) begin
                    state <= ACCESS;
				PREADY <= 1'b1; // add for test	
				end
            end
            
            ACCESS: begin
    PREADY <= 1'b1;
    if (PWRITE) begin
        case(PADDR)
            8'b0000_0000: A <= PWDATA;
            8'b0000_0001: B <= PWDATA;
            8'b0000_0010: C <= PWDATA;
            8'b0000_0011: D <= PWDATA;
            8'b0000_0100: E <= PWDATA;
            8'b0000_0101: F <= PWDATA;
            8'b0000_0110: G <= PWDATA;
            8'b0000_0111: H <= PWDATA;
            default: PSLVERR <= 1'b1;
        endcase
    end
    
	if (PREADY) begin
        state <= IDLE;
    end else begin
        state <= ACCESS;
    end
end

        endcase
    end
end



endmodule
