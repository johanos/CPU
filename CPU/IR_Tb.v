`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:47:47 04/06/2016
// Design Name:   InstructionRegister
// Module Name:   W:/Universal Google Drive Folder/College/EC413 Comp Org/Assignments/Project/CPU/IR_Tb.v
// Project Name:  CPU_EC413
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: InstructionRegister
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module IR_Tb; // TESTED AND WORKING

	// Inputs
	reg [31:0] Instruction;
	reg Clk;
	reg Rst;
	reg IRWrite;

	// Outputs
	wire [5:0] Opcode;
	wire [4:0] R1;
	wire [4:0] R2;
	wire [4:0] R3;
	wire [15:0] Imm;
	reg error;
	reg [31:0] LastInstruction;

	parameter CLOCK_SPEED = 5;
	always #CLOCK_SPEED Clk = ~Clk;
	
	always @(posedge Clk) begin
	   LastInstruction = Instruction;
		assign error =    (LastInstruction[31:26] != Opcode )
							|| (LastInstruction[25:21] != R1) 
							|| (LastInstruction[20:16] != R2) 
							|| (LastInstruction[15:11] != R3) 
							|| (LastInstruction[15: 0] != Imm) ;
		
		Instruction =	$random;
	end
	// Instantiate the Unit Under Test (UUT)
	InstructionRegister uut (
		.Instruction(Instruction), 
		.Clk(Clk), 
		.Rst(Rst), 
		.IRWrite(IRWrite), 
		.Opcode(Opcode), 
		.R1(R1), 
		.R2(R2), 
		.R3(R3), 
		.Imm(Imm)
	);

	initial begin
		// Initialize Inputs
		Instruction = 0;
		Clk = 0;
		Rst = 0;
		IRWrite = 0;

		// Wait 100 ns for global reset to finish
		#(CLOCK_SPEED * 80); // wait 40 cycles to change something.
		
		IRWrite = 1;
		
		#(CLOCK_SPEED * 80);
		
		Rst = 1;
		
		
		
        
		// Add stimulus here

	end
      
endmodule

