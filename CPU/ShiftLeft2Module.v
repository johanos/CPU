`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:35:42 04/06/2016 
// Design Name: 
// Module Name:    ShiftLeft2Module 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ShiftLeft2Module( In, Out
    );
	 parameter DATA_SIZE = 32; 
	 input  [DATA_SIZE-1:0] In; 
	 output [DATA_SIZE-1:0] Out;
	 
	
	 assign Out = In << 2;

endmodule
