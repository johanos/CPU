`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:46:16 04/01/2016
// Design Name:   controller
// Module Name:   W:/Universal Google Drive Folder/College/EC413 Comp Org/Assignments/Project/CPU/Controller_tb.v
// Project Name:  CPU_EC413
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Controller_tb;

	// Inputs
	reg Clk;
	reg Reset;
	reg [5:0] OpCode;

	// Outputs
	wire PCWrite;
	wire PCWriteCond;
	wire MemRead;
	wire MemWrite;
	wire MemtoReg;
	wire IRWrite;
	wire RegDst;
	wire RegWrite;
	wire ALUSrcA;
	wire [1:0] ALUSrcB;
	wire [2:0] ALUOp;
	wire [1:0] PCSource;

	// Instantiate the Unit Under Test (UUT)
	controller uut (
		.Clk(Clk), 
		.Reset(Reset), 
		.OpCode(OpCode), 
		.PCWrite(PCWrite), 
		.PCWriteCond(PCWriteCond), 
		.MemRead(MemRead), 
		.MemWrite(MemWrite), 
		.MemtoReg(MemtoReg), 
		.IRWrite(IRWrite), 
		.RegDst(RegDst), 
		.RegWrite(RegWrite), 
		.ALUSrcA(ALUSrcA), 
		.ALUSrcB(ALUSrcB), 
		.ALUOp(ALUOp), 
		.PCSource(PCSource)
	);

	initial begin
		// Initialize Inputs
		Clk = 0;
		Reset = 0;
		OpCode = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always #5 Clk = ~Clk;
	
	always @(posedge Clk) begin
		#25 assign  {OpCode} = {OpCode} + 1'b1;
	end
      
endmodule

