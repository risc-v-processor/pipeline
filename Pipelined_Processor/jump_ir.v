module ir_jump(
    input clk,
    input rst_ir,
    input jalr_ir_in,
	 input jalr_ir_in,
    output jalr_ir_out,
	 output jalr_ir_out
    );
		
	reg ir_jalr_reg;
	reg ir_jal_reg;
	
	assign jalr_ir_out=ir_jalr_reg;
	assign jal_ir_out=ir_jal_reg;
	
	always@(posedge clk)
	begin
		if(rst_ir)
		begin
			ir_jalr_reg<=0;
			ir_jal_reg<=0;
		end
		
		else
		begin
			ir_jalr_reg<=jalr_ir_in;
			ir_jal_reg<=jal_ir_in;
		end	
	end
endmodule