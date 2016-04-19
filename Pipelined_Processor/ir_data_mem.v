module ir_data_mem(
   input clk,
	input rst_ir,
	input wr_en_ir_in,
	input [1:0] mem_size_ir_in,
	input sz_ex_ir_in,
	output wr_en_ir_out,
	output [1:0] mem_size_ir_out,
	output sz_ex_ir_out	
   );
	
	reg wr_en_reg;
	reg [1:0] mem_size_reg;
	reg sz_ex_reg;
	
	assign wr_en_ir_out=wr_en_reg;
   assign mem_size_ir_out=mem_size_reg;
	assign sz_ex_ir_out=sz_ex_reg;

   always@(posedge clk)
	begin
		if(rst_ir)
		begin
			wr_en_reg<=1'b0;
			mem_size_reg<=2'bx;
			sz_ex_reg<=1'b0;
		end
		
		else
		begin
			wr_en_reg<=wr_en_ir_in;
			mem_size_reg<=mem_size_ir_in;
			sz_ex_reg<=sz_ex_ir_in;
		end	
	end

endmodule
