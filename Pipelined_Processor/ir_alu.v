
module ir_alu(
    input clk,
    input rst_ir,
    input [4:0] alu_ctrl_in,
	 input alu_op2_sel_in,
	 input [31:0] op1_in,
	 input [31:0]op2_in,
	 input [31:0] sz_alu_in,
    output [4:0] alu_ctrl_out,
	 output alu_op2_sel_out,
	 output [31:0] op1_out,
	 output [31:0] op2_out,
	 output [31:0] sz_alu_out
    );
		
	reg [4:0] alu_ctrl_reg;
	reg alu_op2_sel_reg;
	reg [31:0] op1_reg;
	reg [31:0] op2_reg;
	reg [31:0] sz_alu_reg;
	
	assign alu_ctrl_out=alu_ctrl_reg; 
	assign alu_op2_sel_out=alu_op2_sel_reg;
	assign op1_out=op1_reg;
	assign op2_out=op2_reg;
	assign sz_alu_out=sz_alu_reg;
	
	always@(posedge clk)
	begin
		if(rst_ir)
		begin
			alu_ctrl_reg<=5'bx;
			alu_op2_sel_reg<=1'bx;
			op1_reg<=32'b0;
			op2_reg<=32'b0;
			sz_alu_reg<=32'b0;
		end
		
		else
		begin
			alu_ctrl_reg<=alu_ctrl_in;
			alu_op2_sel_reg<=alu_op2_sel_in;
			op1_reg<=op1_in;
			op2_reg<=op2_in;
			sz_alu_reg<=sz_alu_in;
		end	
	end
endmodule