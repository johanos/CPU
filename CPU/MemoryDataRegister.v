`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:59:46 04/03/2016 
// Design Name: 
// Module Name:    MemoryDataRegister 
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
module MemoryDataRegister( WriteData, ReadData, Clk, Rst, Enable );

parameter DATA_SIZE = 32;

input      [DATA_SIZE-1:0] WriteData;
output reg [DATA_SIZE-1:0] ReadData;
input 	  Clk, Rst, Enable;


initial begin  // INITIALIZE OUTPUT REGS
			ReadData = 0;
end

always @(posedge Clk)
begin
	if (Rst)
		begin
			ReadData = 0;
		end
	else if (Enable)
		begin
			ReadData = WriteData;
		end
end


endmodule
