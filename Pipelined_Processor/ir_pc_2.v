module ir_pc_2(
    input clk,
    input rst_ir,
    input [3:0] pc_in_2,
    output [3:0] pc_out_2
    );
	
   reg [3:0] ir_pc_2_reg;
	assign pc_out_2=ir_pc_2_reg;
	
	always@(posedge clk)
	begin
		if(rst_ir)
			ir_pc_2_reg<=0;
		
		else
			ir_pc_2_reg<=pc_in_2;
	end

endmodule
