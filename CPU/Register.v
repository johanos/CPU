`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:05:11 04/04/2016 
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
module Register(WriteData, ReadData, Clk, Rst, Enable ); // DONE AND VERIFIED

input 	  [DATA_SIZE- 1: 0] WriteData;
output reg [DATA_SIZE- 1: 0] ReadData;
input Clk,Rst,Enable;

parameter DATA_SIZE = 32;
	 
	 
initial begin 
	ReadData = 0;
end
	
always @(posedge Clk) begin
	if (Rst) begin
		ReadData = 0;
	end
	else if (Enable) begin
		ReadData = WriteData;
	end
end



endmodule


