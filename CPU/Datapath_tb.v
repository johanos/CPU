`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:46:24 04/08/2016
// Design Name:   CPU_Datapath
// Module Name:   /ad/eng/users/m/e/methier/CPU_Project/Datapath_tb.v
// Project Name:  CPU_Project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU_Datapath
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Datapath_tb;

	// Inputs
	reg PCWriteCond;
	reg PCWrite;
	reg MemRead;
	reg IRWrite;
	reg R1orR3;
	reg RegWrite;
	reg ALUSrcA;
	reg [1:0] ALUSrcB;
	reg [2:0] ALUOp;
	reg [1:0] PCSource;
	reg MemtoReg;
	reg MemWrite;
	reg Reset;
	reg Clk;

	// Outputs
	wire [5:0] Out_to_Control;
	wire [31:0] ALUOut;

	// Instantiate the Unit Under Test (UUT)
	CPU_Datapath uut (
		.Out_to_Control(Out_to_Control), 
		.ALUOut(ALUOut), 
		.PCWriteCond(PCWriteCond), 
		.PCWrite(PCWrite), 
		.MemRead(MemRead), 
		.IRWrite(IRWrite), 
		.R1orR3(R1orR3), 
		.RegWrite(RegWrite), 
		.ALUSrcA(ALUSrcA), 
		.ALUSrcB(ALUSrcB), 
		.ALUOp(ALUOp), 
		.PCSource(PCSource), 
		.MemtoReg(MemtoReg), 
		.MemWrite(MemWrite), 
		.Reset(Reset), 
		.Clk(Clk)
	);
	parameter CLOCK_HALF_PERIOD = 5;
	always #CLOCK_HALF_PERIOD Clk = ~Clk;
	initial begin
		// Initialize Inputs
		PCWriteCond = 0;
		PCWrite = 0;
		MemRead = 0;
		IRWrite = 0;
		R1orR3 = 0;
		RegWrite = 0;
		ALUSrcA = 0;
		ALUSrcB = 0;
		ALUOp = 0;
		PCSource = 0;
		MemtoReg = 0;
		MemWrite = 0;
		Reset = 0;
		Clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        //State 0
				#10
				PCWrite     = 1'b1;	 // we need to get the next PC which will be computed this step.
				PCWriteCond = 1'b0;   //nah
				MemRead     = 1'b1;   //we want to read from mem tho.
				MemWrite    = 1'b0;   //don't want to write to mem yet.. just loading it up for the next CLK
				MemtoReg    = 1'b0;   //don't want to write to the regiter file yet.
				IRWrite     = 1'b1;   //we do want to write to the Instruction Register to load our next instr...
				R1orR3      = 1'b0;	 //we don't care between choosing R1 [25:21]  or R3 [15:11] 
				RegWrite    = 1'b0;   //we don't want to write to register file
				ALUSrcA     = 1'b0; 	 //we don't want to read from Reg A we want to get the PC to add to our next instruction
				ALUSrcB     = 2'b01;  //we want to add 4 to PC...
				ALUOp       = 3'b010; //needs to add PC
				PCSource    = 2'b00;  //the output of the addition.. we want that ish..
				
				#10
			//State 1
				PCWrite     = 1'b0;   // WE DO NOT WANT TO WRITE TO PC reg now
				PCWriteCond = 1'b0;   // WE DON't WANT THIS
				MemRead     = 1'b0;   //We don't want to read from the instruction memory.. we just got the last thing
				MemWrite    = 1'b0;   //We also don't want to write to it right now
				MemtoReg    = 1'b0;   //We don't want whatever came out of memory rn to be written to a reg.
				IRWrite     = 1'b0;   //We are DECODING... not writing to it.
				R1orR3      = 1'b0;	 //still decoding so we don't care if the read source is R3 or R1
				RegWrite    = 1'b0;   //we don't want to write here. just read.
				ALUSrcA     = 1'b0;   //doesn't matter because we have yet to load the data in regs 
				ALUSrcB     = 2'b11;	 //same I believe
				ALUOp       = 3'b010; // not used this round because we already have the next instruction in the IM
				PCSource    = 2'b00;  // its what came out of the ALU but we don't give a damn.
			
			#10
			//LI
			//State 2
				PCWrite     = 1'b0;   //Don't need
				PCWriteCond = 1'b0;   //Don't need on
				MemRead     = 1'b0;	 //Don't need on
				MemWrite    = 1'b0; 	 //Don't need to write
				MemtoReg    = 1'b0;	 //don't need to 
				IRWrite     = 1'b0;   //don't need to write to IR
				R1orR3      = 1'b0;   //Do we need to read from R1? or R3? doens't matter
				RegWrite    = 1'b0;   //We are not saving anything
				ALUSrcA     = 1'b1;   //Choose what we got from Reg A.. its hard coded to 0
				ALUSrcB     = 2'b10;  //Choose the sign extened immediate, we need it to compute the address for SWI and LWI
				ALUOp       = 3'b010; //add 0 plus immediate address or whatever to get the thing.
				PCSource    = 2'b00;  //doesn't matter
				
			#10
			//State 3
				PCWrite     = 1'b0;   //Don't need
				PCWriteCond = 1'b0;   //Don't need on
				MemRead     = 1'b1;	 // need on
				MemWrite    = 1'b0; 	 //Don't need to write
				MemtoReg    = 1'b0;	 //don't need to 
				IRWrite     = 1'b0;   //don't need to write to IR
				R1orR3      = 1'b0;   //Do we need to read from R1? or R3? doens't matter
				RegWrite    = 1'b0;   //We are not saving anything
				ALUSrcA     = 1'b1;   //
				ALUSrcB     = 2'b10;  //
				ALUOp       = 3'b010; //add 0 plus immediate address or whatever to get the thing.
				PCSource    = 2'b00;  //doesn't matter
				
			#10
			//State 4
				PCWrite     = 1'b0;   //Don't need
				PCWriteCond = 1'b0;   //Don't need on
				MemRead     = 1'b0;	 //Don't need on
				MemWrite    = 1'b0; 	 //Don't need to write
				MemtoReg    = 1'b0;	 // need on
				IRWrite     = 1'b0;   //don't need to write to IR
				R1orR3      = 1'b0;   //Do we need to read from R1? or R3? doens't matter
				RegWrite    = 1'b1;   //
				ALUSrcA     = 1'b1;   //Choose what we got from Reg A.. its hard coded to 0
				ALUSrcB     = 2'b10;  //Choose the sign extened immediate, we need it to compute the address for SWI and LWI
				ALUOp       = 3'b010; //add 0 plus immediate address or whatever to get the thing.
				PCSource    = 2'b00;  //doesn't matter
			
			/*	#10
			//I-type
			//State 10
				ALUSrcA     = 1'b1; 
				ALUSrcB     = 2'b10; 
				R1orR3      = 1'b1;
				
				ALUOp       = Out_to_Control[2:0];  //this will need to vary depending on what Immidiate instruction gets passed in.
				
				#10
			//State 11
				R1orR3 = 1'b1;
				RegWrite = 1'b1; 
				MemtoReg = 1'b0;
			*/
			
			// R-type
			/*
				#10
			//State 6
				PCWrite     = 1'b0; 
				PCWriteCond = 1'b0; 
				MemRead     = 1'b0;	
				MemWrite    = 1'b0; 
				MemtoReg    = 1'b0;	
				IRWrite     = 1'b0; 
				R1orR3      = 1'b0; 
				RegWrite    = 1'b0; 
				ALUSrcA     = 1'b1; 
				ALUSrcB     = 2'b00;
				ALUOp       = Out_to_Control[2:0];
				PCSource    = 2'b00;
		
				#10
			//State 7
				PCWrite     = 1'b0; 
				PCWriteCond = 1'b0; 
				MemRead     = 1'b0;	
				MemWrite    = 1'b0; 
				MemtoReg    = 1'b0;	
				IRWrite     = 1'b0; 
				R1orR3      = 1'b0; 
				RegWrite    = 1'b1; 
				ALUSrcA     = 1'b1; 
				ALUSrcB     = 2'b00;
				ALUOp       = Out_to_Control[2:0];
				PCSource    = 2'b00;
				*/
				
		//BEQ
			/* #10
		// State 8
				PCWrite     = 1'b0; 
				PCWriteCond = 1'b1; 
				MemRead     = 1'b0;	
				MemWrite    = 1'b0; 
				MemtoReg    = 1'b0;	
				IRWrite     = 1'b0; 
				RegDst      = 1'b0; 
				RegWrite    = 1'b0; 
				ALUSrcA     = 1'b1; 
				ALUSrcB     = 2'b00;
				ALUOp       = 3'b011;
				PCSource    = 2'b01;*/
		// Add stimulus here

	end
      
endmodule

