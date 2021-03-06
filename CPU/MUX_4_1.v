`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:09:34 04/07/2016 
// Design Name: 
// Module Name:    MUX_4_1 
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
module MUX_4_1(in0, in1, in2, in3, Op, MuxOut
    );
		parameter	W = 32;
		input		[W-1:0]in0, in1, in2, in3;
		input		[1:0]Op;
		output reg	[W-1:0]MuxOut;

always @ (Op, in0, in1, in2, in3)
begin
	if (Op == 2'b00) MuxOut = in0;
	else if (Op == 2'b01) MuxOut = in1;
	else if (Op == 2'b10) MuxOut = in2;
	else if (Op == 2'b11) MuxOut = in3;
end

endmodule
