`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:06:08 04/06/2016
// Design Name:   SignExtend
// Module Name:   W:/Universal Google Drive Folder/College/EC413 Comp Org/Assignments/Project/CPU/SignExtend_tb.v
// Project Name:  CPU_EC413
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SignExtend
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SignExtend_tb;

	// Inputs
	reg [15:0] In;
	reg Clk;
	// Outputs
	wire [31:0] Out;
	parameter CLOCK_SPEED = 5;
	always #CLOCK_SPEED Clk = ~Clk;
	
	always @(posedge Clk) begin
		In = $random;	
	end

	// Instantiate the Unit Under Test (UUT)
	SignExtend uut (
		.In(In), 
		.Out(Out)
	);

	initial begin
		// Initialize Inputs
		In = 0;
		Clk = 0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

