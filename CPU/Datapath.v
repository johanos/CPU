`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:18:55 04/16/2016 
// Design Name: 
// Module Name:    Datapath 
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
module Datapath(ALUOut,Out_to_Control,ALUSelect,PCWriteCond,PCWrite,MemWrite,MemAddr,MemtoReg,IRWrite,BranchCond,PCSource,ALUSrcB,ALUSrcA,RegRead,RegWrite,Reset,Clk);

parameter DATA_WIDTH = 32;
parameter DATA_SELECT_WIDTH = 5;

	/******INPUTS ********/
input PCWriteCond,PCWrite,MemWrite,MemAddr,IRWrite,ALUSrcA,RegRead,RegWrite;
input [1:0] PCSource,ALUSrcB,MemtoReg,BranchCond;
input [2:0] ALUSelect;
input Reset,Clk;
	/*********************/

	/*******OUTPUTS*******/
output [5:0] Out_to_Control;				//first 6 bits of instruction to control
output [DATA_WIDTH-1:0] ALUOut;				//ALUOut for testing
	/*********************/

	/********WIRES********/
wire Write;
assign Write = 1'b1;

wire [DATA_WIDTH-1:0] ZE26_Out;
wire [DATA_WIDTH-1:0] ZE16_Out;
wire zero_not;
wire [DATA_WIDTH-1:0] DMem_Addr;
wire Branch_Out;
wire and_to_or_PC_Out;
wire or_to_PC_Out;
wire [DATA_WIDTH-1:0] PC_Out;
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
wire [DATA_WIDTH-1:0] ALUResult_Reg_Out;
wire [DATA_WIDTH-1:0] DMem_Out;
wire [DATA_WIDTH-1:0] DMem_Reg_Out;
wire [DATA_WIDTH-1:0] mux_PCSource_Out;
wire [DATA_WIDTH-1:0] SL16_Out;
wire or_ble_Out;
wire and_blt_Out;

	/*********************/

//ShiftLeft16
assign SL16_Out = {Imm,16'h0000};

//ZeroExtend26
assign ZE26_Out = {6'b000000,ReadReg1,ReadReg2,Imm};

//ZeroExtend16
assign ZE16_Out = {16'h0000,Imm};

//SignExtend
assign SE16_Out = (Imm[15]==1)? {16'hFFFF,Imm}:{16'h0000,Imm};

assign ALUOut = ALUResult_Reg_Out;

//NOT gate to invert zero
not not_zero (zero_not,zero);

//AND gate to allow next Branch Instruction to be written to PC
and and_to_or_PC (and_to_or_PC_Out,PCWriteCond,Branch_Out);		//PCWriteCond

//OR gate to allow next instruciton to be written to PC
or or_to_PC (or_to_PC_Out,PCWrite,and_to_or_PC_Out);//PCWrite

//OR gate to check ble
or or_ble (or_ble_Out,(~ALUResult[31]),zero_not);

//AND gate to check blt
and and_blt (and_blt_Out,(~ALUResult[31]),zero);

	//BREAKING UP INTO STAGES

	/******STAGE 1 PROGRAM COUNTER******/

	Register #(.DATA_SIZE(16)) PC (.WriteData(mux_PCSource_Out [15:0]), .ReadData(PC_Out),.Clk(Clk), .Rst(Reset), .Enable(or_to_PC_Out));

	/***********END STAGE 1*************/

	/******STAGE 2 DMem && IMem ********/

	//Mux that selects the address of the memory
	MUX_2_1 MemToRegMUX(.in0(ALUResult_Reg_Out), .in1(ZE16_Out), .Op(MemAddr), .MuxOut(DMem_Addr));

	//DMEM
	DMem dataMemory (.WriteData(B_Out), .MemData(DMem_Out), .Address(DMem_Addr[15:0]), .MemWrite(MemWrite), .Clk(Clk));

	//IMEM
	IMem instructionMemory (.PC(PC_Out), .Instruction(IMem_Out));		//No Control Signal

	/***********END STAGE 2*************/

	/******STAGE 3 IR and Mem Data Reg***/

	//IR_REG
	InstructionRegister IR (.Instruction(IMem_Out), .Clk(Clk), .Rst(Reset), .IRWrite(IRWrite), .Opcode(Out_to_Control), .R1(ReadReg1), .R2(ReadReg2), .R3(ReadReg3), .Imm(Imm));

	//DMEM_Reg
	Register MDR (.WriteData(DMem_Out), .ReadData(DMem_Reg_Out), .Clk(Clk), .Rst(Reset), .Enable(Write));

	MUX_4_1 MemToReg_mux(.in0(ALUResult_Reg_Out), .in1(ZE16_Out), .in2(DMem_Reg_Out), .in3(SL16_Out), .Op(MemtoReg), .MuxOut(RegFile_WriteData));

	/************STAGE 3 END*************/

	/************STAGE 4 REG FILE && RA && RB********/

	//MUX_Read2_Select
	MUX_2_1 #(.W(5)) R1orR3Mux(.in0(ReadReg3), .in1(ReadReg1), .Op(RegRead), .MuxOut(Read2Select_Out));

	//Register File
	nbit_register_file Register_File (
				.write_data(RegFile_WriteData), 
				.read_data_1(DataRead1), .read_data_2(DataRead2),
				.read_sel_1(ReadReg2), .read_sel_2(Read2Select_Out), 
            	.write_address(ReadReg1), .RegWrite(RegWrite), .clk(Clk));    

	//RegA
	Register A (.WriteData(DataRead1), .ReadData(A_Out), .Clk(Clk), .Rst(Reset), .Enable(Write));

	//RegB
	Register B (.WriteData(DataRead2), .ReadData(B_Out), .Clk(Clk), .Rst(Reset), .Enable(Write));

	/**********STAGE 4 END***************/

	/**********STAGE 5 BEGIN*************/

	//mux_ALUSrcA
	MUX_2_1 ALUSrcASel(.in0(PC_Out), .in1(A_Out), .Op(ALUSrcA), .MuxOut(A_Select));

	//mux_ALUSrcB
	MUX_4_1 ALUSrcBSel(.in0(B_Out), .in1(32'd1), .in2(SE16_Out), .in3(ZE16_Out), .Op(ALUSrcB), .MuxOut(B_Select));

	//ALU
	Ideal_ALU ALU (.R1(ALUResult) , .R2(A_Select), .R3(B_Select), .ALUOp(ALUSelect), .Zero(zero));

	//ALU_Result_Reg
	Register ALUout (.WriteData(ALUResult), .ReadData(ALUResult_Reg_Out), .Clk(Clk), .Rst(Reset), .Enable(Write) );

	//Mux that selects the next instruction address
	MUX_4_1 mux_PCSource(.in0(ALUResult), .in1(ALUResult_Reg_Out), .in2(ZE26_Out), .in3(32'b0), .Op(PCSource), .MuxOut(mux_PCSource_Out));

	//Mux that selects if branch is taken
	MUX_4_1 Branch_MUX(.in0(zero_not), .in1(zero), .in2(and_blt_Out), .in3(or_ble_Out), .Op(BranchCond), .MuxOut(Branch_Out));

	/*************STAGE 5 END************/

endmodule
