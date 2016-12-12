`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:17:30 04/06/2016
// Design Name:   MemoryDataRegister
// Module Name:   W:/Universal Google Drive Folder/College/EC413 Comp Org/Assignments/Project/CPU/MDR_tb.v
// Project Name:  CPU_EC413
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MemoryDataRegister
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module MDR_tb;

	// Inputs
	reg [31:0] WriteData;
	reg Clk;
	reg Rst;
	reg Enable;

	// Outputs
	wire [31:0] ReadData;
	reg error;
	reg  [31:0] LastWriteData;
	parameter CLOCK_SPEED = 5;
	always #CLOCK_SPEED Clk = ~Clk;
	
	always @(posedge Clk) begin 
		LastWriteData = WriteData;
		assign error =   ReadData != LastWriteData;
		
		WriteData =	$random;
	end

	// Instantiate the Unit Under Test (UUT)
	MemoryDataRegister uut (
		.WriteData(WriteData), 
		.ReadData(ReadData), 
		.Clk(Clk), 
		.Rst(Rst), 
		.Enable(Enable)
	);

	initial begin
		// Initialize Inputs
		WriteData = 0;
		Clk = 0;
		Rst = 0;
		Enable = 0;

		// Wait 100 ns for global reset to finish
		#(CLOCK_SPEED * 80); // wait 40 cycles to change something.
		
		Enable = 1;
		
		#(CLOCK_SPEED * 80);
		
		Rst = 1;
		

	end
      
endmodule

