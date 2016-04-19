`timescale 1ns / 1ps

//single cycle CPU
//macros
//bus width
`define BUS_WIDTH 32
`define REGISTER_INDEX_WIDTH 5
//register file
`define REG1_MSB 19
`define REG1_LSB 15
`define REG2_MSB 24
`define REG2_LSB 20
`define DST_REG_MSB 11
`define DST_REG_LSB 7
`define REG_INDEX_WIDTH 5
//ALU
`define ALU_CTRL_WIDTH 5

module Pipelined_Processor(
	//outputs
	//memory mapped I/O
	output [(`BUS_WIDTH-1):0] mem_map_io_t,
	//inputs
	//reset
    input rst_t,
    //clock
    input clk_t
);
 
	//Instantiation of PC_BLOCK
    wire [(`BUS_WIDTH-1):0] next_addr_t ;
    wire [(`BUS_WIDTH-1):0] curr_addr_t ;
	 
    pc_block  pc_bloc_t ( .rst(rst_t), 
						  .clk(clk_t) ,
                          .next_addr(next_addr_t) , 
                          .curr_addr(curr_addr_t) );
	
	wire [(`BUS_WIDTH-1):0] pc_ir1_t;
	wire cntl_rst_t;
	
	//Instantiation of PC_1 intermediate register
	ir_pc_1 ir_pc_1_t(.clk(clk_t),
							.rst_ir(cntl_rst_t),
							.pc_in(curr_addr_t),
							.pc_out(pc_ir1_t));
							
	//Instantiation of PC_2 intermediate register
	wire [(`BUS_WIDTH-1):0] pc_ir2_t;
	
	ir_pc_1 ir_pc_2_t(.clk(clk_t),
							.rst_ir(cntl_rst_t),
							.pc_in(pc_ir1_t),
							.pc_out(pc_ir2_t));
							
	//Instantiation of instruction memory
	wire [(`BUS_WIDTH-1):0] inst_t;
	reg i_mem_wr_en_t;
	reg [(`BUS_WIDTH-1):0] i_mem_wr_data_t;
	
	i_mem i_mem_t ( .inst(inst_t),
					.i_mem_address(curr_addr_t),
					.clk(clk_t),
					.rst(rst_t),
					.i_mem_wr_en(i_mem_wr_en_t),
					.i_mem_wr_data(i_mem_wr_data_t) );
					
	//Instantiation of instruction intermediate register
	wire [(`REGISTER_INDEX_WIDTH-1):0] reg1_t;
	wire [(`REGISTER_INDEX_WIDTH-1):0] reg2_t;
	wire [(`REGISTER_INDEX_WIDTH-1):0] dest_t;
	wire [(`BUS_WIDTH-1):0] inst_out_t; 
	
	
	ir_inst ir_inst_t(.inst_in(inst_t),
							.reg1(reg1_t),
							.reg2(reg2_t),
							.dest(dest_t),
							.inst_out(inst_out_t),
							.clk(clk_t),
							.rst_ir(cntl_rst_t));
              
  
	//Instantiation of adder (PC + 4)
	reg [(`BUS_WIDTH-1):0] val_2_PC_adder = 32'd4;
	wire [(`BUS_WIDTH-1):0] Add_4_Out_t;
	 
	adder adder_t ( .val_1(curr_addr_t) , 
					.val_2(val_2_PC_adder) , 
					.out(Add_4_Out_t) );


	//Instantiation of Control Unit 
	wire [(`ALU_CTRL_WIDTH-1):0] alu_ctrl_t;	
	wire reg_file_wr_en_t;
	wire [1:0] reg_file_wr_back_sel_t;
	wire alu_op2_sel_t;
	wire d_mem_wr_en_t;
	wire d_mem_sz_ex_t;
	wire [1:0] d_mem_size_t;
	wire jal_t;
	wire jalr_t;
	wire cntl_transfer_t;
	 
	ctrl ctrl_t ( .alu_ctrl(alu_ctrl_t),
				  .reg_file_wr_en(reg_file_wr_en_t),
				  .reg_file_wr_back_sel(reg_file_wr_back_sel_t),
				  .alu_op2_sel(alu_op2_sel_t),
				  .d_mem_wr_en(d_mem_wr_en_t),
				  .d_mem_sz_ex(d_mem_sz_ex_t),
				  .d_mem_size(d_mem_size_t),
				  .jal(jal_t),
				  .jalr(jalr_t), 
				  .inst(inst_out_t),
				  .cntl_transfer(cntl_transfer_t),
				  .ctrl_rst(cntl_rst_t)); 
						
						
	//Instantiation of register file 
	wire [(`BUS_WIDTH-1):0] reg_data_1_t;
	wire [(`BUS_WIDTH-1):0] reg_data_2_t;
	reg [(`BUS_WIDTH-1):0] wr_reg_data_t;
	wire [(`REG_INDEX_WIDTH-1):0] rd_reg_index_1_t = inst_out_t[`REG1_MSB :`REG1_LSB] ;
	wire [(`REG_INDEX_WIDTH-1):0] rd_reg_index_2_t = inst_out_t[`REG2_MSB :`REG2_LSB] ;
	wire [(`REG_INDEX_WIDTH-1):0] wr_reg_index_t = inst_out_t[`DST_REG_MSB :`DST_REG_LSB] ;
	 
	reg_file reg_file_t ( .reg_data_1(reg_data_1_t), 
						  .reg_data_2(reg_data_2_t),
						  .rst(rst_t), 
						  .clk(clk_t), 
						  .wr_en(reg_file_wr_en_t),
						  .rd_reg_index_1(rd_reg_index_1_t),
                          .rd_reg_index_2(rd_reg_index_2_t), 
                          .wr_reg_index(wr_reg_index_t), 
                          .wr_reg_data(wr_reg_data_t) );	
								 
								 
	//Instantiation of sign extend module
	wire [(`BUS_WIDTH - 1):0] sz_ex_val_t ;
	 
	sz_ex sz_ex_t ( .inst(inst_t), 
					.sz_ex_val(sz_ex_val_t) );
					
	//Instantiation of Jump Intermediate Register
	wire jalr_ir_t;
	wire jal_ir_t;
	
	ir_jump ir_jump_t(.clk(clk_t),
							.rst_ir(cntl_rst_t),
							.jalr_ir_in(jalr_t),
							.jal_ir_in(jal_t),
							.jalr_ir_out(jalr_ir_t),
							.jal_ir_out(jal_ir_t));
	
	//Instantiation of Data Memory Intermediate Register
	wire d_wr_en_ir_t;
	wire [1:0] d_mem_size_ir_t;
	wire sz_ex_ir_t;
	
	
	ir_data_mem ir_data_mem_t(.clk(clk_t),
									  .rst_ir(cntl_rst_t),
									  .wr_en_ir_in(d_mem_wr_en_t),
									  .sz_ex_ir_in(d_mem_sz_ex_t),
									  .mem_size_ir_in(d_mem_size_t),
									  .wr_en_ir_out(d_wr_en_ir_t),
									  .sz_ex_ir_out(sz_ex_ir_t),
									  .mem_size_ir_out(d_mem_size_ir_t)
									 );
	
	//Instantiation of ALU Intermediate Register
	wire [(`ALU_CTRL_WIDTH-1):0] alu_ctrl_ir_t;
	wire alu_op2_ir_t;
	wire [(`BUS_WIDTH-1):0] reg_data_1_ir_t;
	wire [(`BUS_WIDTH-1):0] reg_data_2_ir_t;
	wire [(`BUS_WIDTH-1):0] sz_ex_val_ir_t;
	
	ir_alu ir_alu_t(.clk(clk_t),
						 .rst_ir(cntl_rst_t),
						 .alu_ctrl_in(alu_ctrl_t),
						 .alu_op2_sel_in(alu_op2_sel_t),
						 .op1_in(reg_data_1_t),
						 .op2_in(reg_data_2_t),
						 .sz_alu_in(sz_ex_val_t),
						 .alu_ctrl_out(alu_ctrl_ir_t),
						 .alu_op2_sel_out(alu_op2_ir_t),
						 .op1_out(reg_data_1_ir_t),
						 .op2_out(reg_data_2_ir_t),
						 .sz_alu_out(sz_ex_val_ir_t)						 
						 );
	
	  
	//Implementation of 2:1 MUX  (second operand to ALU)
	reg [(`BUS_WIDTH-1):0] Operand2_t;
	
	always @ (*) begin 
		case (alu_op2_sel_t)
			1'b0 : Operand2_t = reg_data_2_ir_t;
			1'b1 : Operand2_t = sz_ex_val_ir_t ;
		endcase
	end

	 
	//Implementation OF ALU 
	wire [(`BUS_WIDTH-1):0] ALU_Out_t;
	wire bcond_t;
	
	Exec Exec_t ( .Operand1(reg_data_1_ir_t), 
				  .Operand2(Operand2_t), 
				  .Out(ALU_Out_t),
				  .Operation(alu_ctrl_ir_t),
				  .bcond(bcond_t));
				  
	    
	//Implementation of simple adder 
	wire [(`BUS_WIDTH-1):0] Add_Out_t;
	adder adder_1_t ( .val_1(pc_ir2_t), 
					  .val_2(sz_ex_val_ir_t), 
					  .out(Add_Out_t) );

	
	//Implementation of OR gate 
	wire pc_mux1_sel_t;
	or or1 (pc_mux1_sel_t, jal_ir_t, bcond_t);
	
	//Implementation of OR gate 2
	//wire cntl_transfer_t;
	or or2 (cntl_transfer_t, pc_mux1_sel_t, jalr_ir_t); 

	
	//Implemantation of pc_mux_1
	reg [(`BUS_WIDTH-1):0] pc_mux1_Out_t ;
	always @ (*) begin
		case ({jalr_ir_t,pc_mux1_sel_t})
			2'b00 : pc_mux1_Out_t = Add_4_Out_t;
			2'b01 : pc_mux1_Out_t = Add_Out_t;
			2'b10 : pc_mux1_Out_t = ALU_Out_t;
			default : pc_mux1_Out_t = Add_4_Out_t;
		endcase
	end

/*		
	//Implementation of pc_mux_2	
	reg [(`BUS_WIDTH-1):0] pc_mux2_Out_t;
	
	always @ (*) begin
		case (jalr_t)
			1'b0 : pc_mux2_Out_t = pc_mux1_Out_t;
			1'b1 : pc_mux2_Out_t = ALU_Out_t ;
		endcase
	end*/

		
	//connect output of pc1 mux to input of PC block	
	assign next_addr_t = pc_mux1_Out_t;
	
	//....................From Here...........................................**********************
	
	//Implementation of Data Memory module
	wire [(`BUS_WIDTH-1):0] d_mem_rd_data_t;
	
	d_mem d_mem_t ( .d_mem_rd_data(d_mem_rd_data_t),
					.mem_map_io(mem_map_io_t),
					.clk(clk_t),
					.rst(rst_t),
					.d_mem_address(ALU_Out_t),
					.d_mem_wr_data(reg_data_2_ir_t),
					.d_mem_wr_en(d_wr_en_ir_t),
					.d_mem_size(d_mem_size_ir_t),
					.d_mem_sz_ex(sz_ex_ir_t));


	//Implementation of 2:4 mux (writeback path to register file) 
	always @ (*) begin 
		case(reg_file_wr_back_sel_t)
			2'b00 :	wr_reg_data_t = ALU_Out_t;
			2'b01 : wr_reg_data_t = d_mem_rd_data_t;
			2'b10 : wr_reg_data_t = Add_4_Out_t;
			2'b11 : wr_reg_data_t = Add_Out_t ;
		endcase
	end


	always @ (posedge clk_t) begin
		if (rst_t == 1'b1) begin
			//instruction memory signals
			i_mem_wr_en_t = 1'b0;
			i_mem_wr_data_t = 32'b0;
		end
	end

endmodule