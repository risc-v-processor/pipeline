//instruction register

//macros
`define BUS_WIDTH 32
`define REGISTER_INDEX_WIDTH 5

module ir_inst(
	//Outputs
	//register operand 1 index
	output [(`REGISTER_INDEX_WIDTH-1):0] reg1,
	//register operand 2 index
	output [(`REGISTER_INDEX_WIDTH-1):0] reg2,
	//destination register index
	output [(`REGISTER_INDEX_WIDTH-1):0] dest,
	//instruction
	output [(`BUS_WIDTH-1):0] inst_out,
	//Inputs
	//clock
	input clk,
	//reset
	input rst_ir,
	input rst,
	//instruction input
	input [(`BUS_WIDTH-1):0] inst_in
);

	//register to hold the instruction read out from memory
	reg [(`BUS_WIDTH-1):0] inst;
	
	//form connections between "inst" and outputs
	assign reg1[(`REGISTER_INDEX_WIDTH-1):0] = inst[19:15];
	assign reg2[(`REGISTER_INDEX_WIDTH-1):0] = inst[24:20];
	assign dest[(`REGISTER_INDEX_WIDTH-1):0] = inst[11:7];
	assign inst_out[(`BUS_WIDTH-1):0] = inst[(`BUS_WIDTH-1):0];
	
	//combinational logic
	always @ (posedge clk) begin
		//check if reset is asserted and reset design
		if (rst_ir)
		begin
			inst <= 32'b0;
		end
		
		else if (rst)
		begin
			inst <= 32'b0;
		end
		
		else 
		begin			
			inst <= inst_in;			
		end
	end	
endmodule
