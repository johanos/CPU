`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:40:27 04/06/2016
// Design Name:   ProgramCounter
// Module Name:   W:/Universal Google Drive Folder/College/EC413 Comp Org/Assignments/Project/CPU/PC_tb.v
// Project Name:  CPU_EC413
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ProgramCounter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module PC_tb; //TESTED AND DONE
 
	// Inputs
	reg [15:0] PCWriteAddr;
	reg Enable;
	reg Clk;
	reg Rst;
	
	parameter CLOCK_SPEED = 5;
	always #CLOCK_SPEED Clk = ~Clk;
	
	always @(posedge Clk) begin
		PCWriteAddr = PCWriteAddr + 1'b1;
	end

	// Outputs
	wire [15:0] PCReadAddr;

	// Instantiate the Unit Under Test (UUT)
	ProgramCounter uut (
		.PCWriteAddr(PCWriteAddr), 
		.PCReadAddr(PCReadAddr), 
		.Enable(Enable), 
		.Clk(Clk), 
		.Rst(Rst)
	);

	initial begin
		// Initialize Inputs
		PCWriteAddr = 0;
		Enable = 0;
		Clk = 0;
		Rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
		Enable = 1;
		
		# (CLOCK_SPEED * 40);
		Rst = 1;
        
		// Add stimulus here

	end
      
		
	
endmodule

