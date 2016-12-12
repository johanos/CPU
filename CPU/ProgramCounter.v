`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:13:11 11/21/2015 
// Design Name: 
// Module Name:    Register 
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

module ProgramCounter(PCWriteAddr,PCReadAddr, Enable, Clk, Rst);

input [ADDRESS_LENGTH-1:0] PCWriteAddr;
output reg [ADDRESS_LENGTH-1:0] PCReadAddr;
input Enable, Clk, Rst;

parameter ADDRESS_LENGTH = 16 ;

always @(posedge Clk)
begin
	if (Rst)
		PCReadAddr = 0;
	else if (Enable)
		PCReadAddr = PCWriteAddr;
end

endmodule

