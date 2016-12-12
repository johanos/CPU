`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:58:25 04/03/2016 
// Design Name: 
// Module Name:    InstructionRegister 
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
module InstructionRegister( Instruction, Clk, Rst, IRWrite, Opcode, R1, R2, R3,  Imm);
 input		[31:0] Instruction;
 input		Clk, Rst, IRWrite;
 output reg  [5:0] Opcode;
 output reg  [4:0] R1;
 output reg  [4:0] R2;
 output reg  [4:0] R3;
 output reg  [15:0] Imm;
    

initial begin  // INITIALIZE OUTPUT REGS
			Opcode = 6'b0;
			R1 = 5'b0;
			R2 = 5'b0;
			R3 = 5'b0;
			Imm = 16'b0;
end

always @(posedge Clk)
begin
	if (Rst)
		begin
			Opcode = 6'b0;
			R1 = 5'b0;
			R2 = 5'b0;
			R3 = 5'b0;
			Imm = 16'b0;
		end
	else if (IRWrite)
		begin
			Opcode = Instruction[31:26];
			R1 = Instruction[25:21];
			R2 = Instruction[20:16];
			R3 = Instruction[15:11];
			Imm = Instruction[15:0];
		end
end

endmodule
