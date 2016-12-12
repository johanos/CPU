`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:21:02 04/16/2016 
// Design Name: 
// Module Name:    CPU_Control 
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
// This is Dick Chaney... Our Controller.
module CPU_Control(OpCode, Clk, Reset, PCWrite, PCWriteCond, 
					BranchCond, RegRead, MemAddr, MemWrite, 
					MemtoReg, IRWrite, PCSource, ALUOp, 
					ALUSrcA, ALUSrcB, RegWrite
					);

	/******INPUTS ********/
	input [5:0] OpCode;
	input Clk;
	input Reset;
	/*****END_INPUTS******/
	
	/*******OUTPUTS*******/
	output reg PCWrite;
	output reg PCWriteCond;
	output reg [1:0] BranchCond;
	output reg RegRead;
	output reg MemAddr;
	output reg MemWrite;
	output reg [1:0] MemtoReg;
	output reg IRWrite;
	output reg [1:0] PCSource;
	output reg [1:0] ALUOp;
	output reg ALUSrcA;
	output reg [1:0] ALUSrcB;
	output reg RegWrite;
	/********************/

	reg [4:0] state, next_state; //state machine parameters...

	parameter S0=0;
	parameter S1=1;	
	parameter S2=2;
	parameter S3=3;
	parameter S4=4; 
	parameter S5=5; 
	parameter S6=6;
	parameter S7=7;
	parameter S8=8;
	parameter S9=9;
	parameter S10=10; 
	parameter S11=11;
	parameter S12=12;

	always@(posedge Clk)
		begin
		if(Reset)
		begin
		state <= 5'd0;
		end
		else
		begin
		state <= next_state;
		end
		end

	//always @(posedge Clk)
	always@(*)
	begin
		case (state)
			S0: begin
					ALUSrcA	<= 0;
					ALUSrcB	<= 2'b01;
					PCWrite <= 1;
					RegWrite <= 0;
					MemWrite <= 0;
					IRWrite	<= 1;					
					PCSource <= 2'b00;
					ALUOp 	<= 2'b00;
					next_state <= S1;
					end
			S1: begin
					ALUSrcA	<= 0;
					ALUSrcB	<= 2'b10;
					ALUOp	<= 2'b00;
					RegRead <= 0;
					MemAddr	<= 1;
					PCWrite	<= 0;
					RegWrite <= 0;
					MemWrite <= 0;
					IRWrite	<= 0;
					PCWriteCond <= 0;
					if (OpCode == 6'b000000)							//Noop 
						begin
							next_state <= S0;
						end
					else if (OpCode[5:4] == 2'b01)						//R-type 
						begin
							next_state <= S2;
						end
					else if (OpCode == 6'b000001)						//JMP 
						begin
							next_state <= S3;
						end
					else if (OpCode[5:3] == 3'b100)						//BNQ 
						begin
							next_state <= S12;
						end
					else if (OpCode == 6'b110010 | OpCode == 6'b110011 | OpCode == 6'b110111)	//I-type(SE) 
						begin
							next_state <= S5;
						end
					else if (OpCode == 6'b110100 | OpCode == 6'b110101)	//I-type(ZE) 
						begin
							next_state <= S6;
						end
					else if (OpCode == 6'b111001) 	//LI 
						begin	
							next_state <= S7;
						end
					else if (OpCode == 6'b111011) 	//LWI 
						begin	
							next_state <= S11;
						end
					else if (OpCode == 6'b111100)	//SWI 
						begin
							next_state <= S8;
						end
					end
			S2:	begin
					ALUSrcA <= 1;
					ALUSrcB <= 2'b00;
					ALUOp <= 2'b10;
					next_state	<= S9;
					end
			S3:	begin
					PCSource <= 2'b10;
					PCWrite <= 1;
					next_state 	<= S0;
					end
			S4: begin
					PCSource <= 2'b01;
					RegRead <= 1;
					ALUSrcA <= 1;
					ALUSrcB <= 2'b00;
					ALUOp <= 2'b01;
					PCWriteCond <= 1;
					BranchCond <= 2'b01;
					next_state	<= S0;
					end
			S5: begin
					ALUSrcA <= 1;
					ALUSrcB <= 2'b10;
					ALUOp <= 2'b10;
					next_state	<= S9;
					end
			S6: begin
					ALUSrcA	<= 1;
					ALUSrcB <= 2'b11;
					ALUOp <= 2'b10;
					next_state <= S9;
					end
			S7: begin
					RegWrite <= 1;
					MemtoReg <= 2'b01;
					next_state	<= S0;
					end
			S8: begin	//SWI
					RegRead <= 1;
					next_state	<= S10;
					end
			S9: begin
					RegWrite <= 1;
					MemtoReg <= 2'b00;
					next_state	<= S0;
					end
			S10: begin
					MemWrite <= 1;
					MemAddr <= 1;
					next_state	<= S0;
					end
			S11: begin
					MemtoReg <= 2'b10;
					RegWrite <= 1;
					next_state	<= S0;
					end
			S12: begin
					RegRead <= 1;
					next_state <= S4;
					end
		endcase
	end
endmodule

