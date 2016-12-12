`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:06:47 04/07/2016 
// Design Name: 
// Module Name:    MUX_2_1 
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
module MUX_2_1(in0, in1, Op, MuxOut);

		parameter	W = 32;
		input		[W-1:0]in0, in1;
		input		Op;
		output	[W-1:0]MuxOut;
		
		assign	MuxOut = (Op) ? in1 : in0;


endmodule
