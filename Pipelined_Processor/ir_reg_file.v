module ir_reg_file(
	input clk,
   input rst_ir,
	input rst,
	input [4:0] ir_reg_wr_index_in,
   input ir_reg_wr_en_in,
	input [1:0]ir_reg_data_sel_in,
  	output [4:0] ir_reg_wr_index_out,
	output [1:0] ir_reg_data_sel_out,
   output ir_reg_wr_en_out
   );

	reg [4:0] wr_index_reg;
	reg wr_en_reg;
	reg [1:0] data_sel_reg;
	
	assign ir_reg_wr_index_out=wr_index_reg;
	assign ir_reg_wr_en_out=wr_en_reg;
	assign ir_reg_data_sel_out=data_sel_reg;
	
	always@(posedge clk)
	begin
		if(rst_ir)
		begin
			wr_index_reg<=5'bx;
			wr_en_reg<=1'b0;
			data_sel_reg<=2'bxx;
		end
		
		else if(rst)
		begin
		   wr_index_reg<=5'bx;
			wr_en_reg<=1'b0;
			data_sel_reg<=2'bxx;
		end
		
		else
		begin
			wr_index_reg<=ir_reg_wr_index_in;
			wr_en_reg<=ir_reg_wr_en_in;
			data_sel_reg<=ir_reg_data_sel_in;
		end
	end

endmodule
