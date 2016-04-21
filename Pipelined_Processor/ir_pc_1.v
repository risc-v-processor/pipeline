module ir_pc_1(
    input clk,
    input rst_ir,
	 input rst,
    input [31:0] pc_in,
    output [31:0] pc_out
    );
	 
	 reg [31:0] ir_pc_reg;
	 
	 assign pc_out=ir_pc_reg;
		
	always@(posedge clk)
	begin
		if(rst_ir)
			ir_pc_reg<=0;
			
		else if(rst)
			ir_pc_reg<=0;
			
		else
			ir_pc_reg<=pc_in;
	end

endmodule
