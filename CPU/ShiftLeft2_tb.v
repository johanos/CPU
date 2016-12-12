`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:38:23 04/06/2016
// Design Name:   ShiftLeft2Module
// Module Name:   W:/Universal Google Drive Folder/College/EC413 Comp Org/Assignments/Project/CPU/ShiftLeft2_tb.v
// Project Name:  CPU_EC413
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ShiftLeft2Module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ShiftLeft2_tb;

	// Inputs
	reg [31:0] In;
	reg Clk;
	// Outputs
	wire [31:0] Out;
	reg error;
	reg [31:0] ShiftVerify;

	parameter CLOCK_SPEED = 5;
	always #CLOCK_SPEED Clk = ~Clk;
	
	always @(posedge Clk) begin
		In = $random;
		ShiftVerify = In << 2;
		assign error = (In << 2) != Out;
		
	end
	
	
	// Instantiate the Unit Under Test (UUT)
	ShiftLeft2Module uut (
		.In(In), 
		.Out(Out)
	);
	
	

	initial begin
		// Initialize Inputs
		In = 0;
	   Clk = 0;
		

	end
      
endmodule

