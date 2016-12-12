`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:05:03 04/06/2016
// Design Name:   nbit_register_file
// Module Name:   W:/Universal Google Drive Folder/College/EC413 Comp Org/Assignments/Project/CPU/RegisterFile_tb.v
// Project Name:  CPU_EC413
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: nbit_register_file
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module RegisterFile_tb;

	// Inputs
	reg [31:0] write_data;
	reg [4:0] read_sel_1;
	reg [4:0] read_sel_2;
	reg [4:0] write_address;
	reg RegWrite;
	reg clk;

	// Outputs
	wire [31:0] read_data_1;
	wire [31:0] read_data_2;

	// Instantiate the Unit Under Test (UUT)
	nbit_register_file #(.data_width(32), .select_width(5))uut (
		.write_data(write_data), 
		.read_data_1(read_data_1), 
		.read_data_2(read_data_2), 
		.read_sel_1(read_sel_1), 
		.read_sel_2(read_sel_2), 
		.write_address(write_address), 
		.RegWrite(RegWrite), 
		.clk(clk)
	);

	initial begin
		// Initialize Inputs
		write_data = 0;
		read_sel_1 = 0;
		read_sel_2 = 0;
		write_address = 0;
		RegWrite = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

