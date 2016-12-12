`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:38:23 04/03/2016 
// Design Name: 
// Module Name:    CPU_Datapath 
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
module CPU_Datapath(ALUOut,Out_to_Control,ALUSelect,PCWriteCond,PCWrite,MemWrite,
		MemAddr,MemtoReg,IRWrite,BranchCond,PCSource,ALUSrcB,ALUSrcA,RegRead,RegWrite,Reset,Clk);
	
	parameter DATA_WIDTH = 32;
	
	/******INPUTS ********/
	
input PCWriteCond,PCWrite,MemWrite,MemAddr,IRWrite,ALUSrcA,RegRead,RegWrite;
input [1:0] PCSource,ALUSrcB,MemtoReg,BranchCond;
input [2:0] ALUSelect;
input Reset,Clk;

	/*********************/
	
	/*******OUTPUTS*******/
	
output [5:0] Out_to_Control;				//first 6 bits of instruction to control
output [DATA_WIDTH-1:0] ALUOut;			//ALUOut for testing

	/*********************/
	
	/********WIRES********/
	
wire Write;
assign Write = 1'b1;

wire [DATA_WIDTH-1:0] ZE26_Out;
wire [DATA_WIDTH-1:0] ZE16_Out;
wire zero_not;
wire [15:0] DMem_Addr;
wire Branch_Out;
wire and_to_or_PC_Out;
wire or_to_PC_Out;
wire [15:0] PC_Out;
wire [DATA_WIDTH-1:0] IMem_Out;
wire [4:0] ReadReg1, ReadReg2, ReadReg3;
wire [15:0] Imm;
wire [4:0] Read2Select_Out;
wire [DATA_WIDTH-1:0] RegFile_WriteData;
wire [DATA_WIDTH-1:0] DataRead1,DataRead2;
wire [DATA_WIDTH-1:0] A_Out;
wire [DATA_WIDTH-1:0] B_Out;
wire [DATA_WIDTH-1:0] A_Select;
wire [DATA_WIDTH-1:0] B_Select;
wire [DATA_WIDTH-1:0] SE16_Out;
wire [DATA_WIDTH-1:0] ALUResult;
wire zero;
wire [15:0] ALUResult_Reg_Out;
wire [DATA_WIDTH-1:0] DMem_Out;
wire [DATA_WIDTH-1:0] DMem_Reg_Out;
wire [15:0] mux_PCSource_Out;
wire [DATA_WIDTH-1:0] SL16_Out;
wire or_ble_Out;
wire and_blt_Out;

//ShiftLeft16
assign SL16_Out = {Imm,16'h0000};

//ZeroExtend26
assign ZE26_Out = {6'b000000,ReadReg1,ReadReg2,Imm};

//SignExtend
SignExtend SE( Imm, SE16_Out);

assign ALUOut = ALUResult_Reg_Out;

//NOT gate to invert zero
not not_zero (zero_not,zero);

//AND gate to allow next Branch Instruction to be written to PC
and and_to_or_PC (and_to_or_PC_Out,PCWriteCond,Branch_Out);//PCWriteCond

//OR gate to allow next instruciton to be written to PC
or or_to_PC (or_to_PC_Out,PCWrite,and_to_or_PC_Out);//PCWrite

//OR gate to check ble
or or_ble (or_ble_Out,(~ALUResult[31]),zero_not);

//AND gate to check blt
and and_blt (and_blt_Out,(~ALUResult[31]),zero);

//Mux that selects the address of the memory from either Reg+Offset or Imm
MUX_2_1	mux_DMEM_ADDR(ALUResult_Reg_Out, Imm, MemAddr, DMem_Addr);

//Mux that selects the next instruction address
MUX_4_1 mux_PC_ADDR(ALUResult, ALUResult_Reg_Out, ZE26_Out, ZE26_Out, PCSource, mux_PCSource_Out);
	
//Mux that selects if branch is taken
MUX_4_1 mux_brach_taken(zero_not, zero, and_blt_Out, or_ble_Out, BranchCond, Branch_Out);

//MUX_Read2_Select
MUX_2_1 mux_Read2_Sel(ReadReg3, ReadReg1, RegRead, Read2Select_Out);

//Mux that selects which data is written to register file
MUX_4_1 mux_reg_sel(ALUResult_Reg_Out, ZE16_Out, DMem_Reg_Out, SL16_Out, MemtoReg, RegFile_WriteData);

//mux_ALUSrcA
MUX_2_1 mux_A_sel(PC_Out, A_Out, ALUSrcA, A_Select);

//mux_ALUSrcB
MUX_4_1 mux_B_sel(B_Out, 32'd1, SE16_Out, ZE16_Out, ALUSrcB, B_Select);

	/*********************/
	
	
	//BREAKING UP INTO STAGES
	
	/******STAGE 1 PROGRAM COUNTER******/
	//PC
	Register #(16) PC (mux_PCSource_Out,PC_Out,or_to_PC_Out,Reset,Clk);//No Control Singal
						
	/***********END STAGE 1*************/
	
	/******STAGE 2 DMem && IMem ********/
	//DMEM
	DMem dataMemory (B_Out,DMem_Out,DMem_Addr,MemWrite,Clk);//MemWrite
	
	//IMEM
	IMem instructionMemory (PC_Out,IMem_Out);//No Control Signal
	/***********END STAGE 2*************/
	
	
	/******STAGE 3 IR and Mem Data Reg***/
	
	//IREG
	InstructionRegister IR (IMem_Out, Clk, Reset, IRWrite, Out_to_Control, ReadReg1, ReadReg2, ReadReg3, Imm); //IRWrite

	//DMEM_Reg
	Register MDR (DMem_Out,DMem_Reg_Out,Write,Reset,Clk);
	
	
	/************STAGE 3 END*************/
	
	/************STAGE 4 REG FILE && RA && RB********/
	
	//Register File
	nbit_register_file Register_File (RegFile_WriteData, DataRead1, DataRead2, ReadReg2, Read2Select_Out, ReadReg1, RegWrite, Clk);//RegWrite
	
	//RegA
	Register A (DataRead1,A_Out,Write,Reset,Clk);
	
	//RegB
	Register B (DataRead2,B_Out,Write,Reset,Clk);

	/**********STAGE 4 END***************/
	
	/**********STAGE 5 BEGIN*************/
	
	//ALU
	Ideal_ALU ALU (ALUResult, A_Select, B_Select, ALUSelect, zero);
	
	//ALU_Result_Reg
	Register ALUout (ALUResult,ALUResult_Reg_Out,Write,Reset,Clk);
	 
   /*************STAGE 5 END************/

endmodule