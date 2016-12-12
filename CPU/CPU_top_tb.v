`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:24:20 04/16/2016
// Design Name:   CPU_top
// Module Name:   /ad/eng/users/m/e/methier/Desktop/CPU_Final/CPU_top_tb.v
// Project Name:  CPU_Final
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module CPU_top_tb;

	// Inputs
	reg Reset;
	reg Clk;

	// Outputs
	wire [31:0] Out;

	// Instantiate the Unit Under Test (UUT)
	CPU_top uut (
		.Out(Out), 
		.Reset(Reset), 
		.Clk(Clk)
	);

	parameter CLOCK_HALF_PERIOD = 5;
	always #CLOCK_HALF_PERIOD Clk = ~Clk;

	initial begin
		// Initialize Inputs
		Reset = 0;
		Clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

