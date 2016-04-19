`timescale 1ns / 1ps

module ir_pc_1_tb;

	// Inputs
	reg clk;
	reg rst_ir;
	reg [3:0] pc_in;

	// Outputs
	wire [3:0] pc_out;

	// Instantiate the Unit Under Test (UUT)
	ir_pc_1 uut (
		.clk(clk), 
		.rst_ir(rst_ir), 
		.pc_in(pc_in), 
		.pc_out(pc_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_ir = 0;
		pc_in = 0;

		// Wait 100 ns for global reset to finish
		#2;
		
		pc_in=4;
		#3 pc_in=5;
		
		#2 rst_ir=1;
		#4 rst_ir=0;
		pc_in=6;
		
		#6 $finish;
	end
	
	always
	#2 clk=~clk;
        
endmodule

