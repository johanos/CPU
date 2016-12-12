module CPU_Datapath(Out_to_Control,ALUOut,PCWriteCond,PCWrite,MemRead,IRWrite,R1orR3,RegWrite,ALUSrCA, ALUSrcB,ALUOp,PCSource,MemtoReg,MemWrite,MemRead,Reset,Clk);
	
	/******INPUTS ********/
	
input PCWriteCond,PCWrite,MemRead,IRWrite,R1orR3,RegWrite,ALUSrCA,MemtoReg,MemWrite,MemRead;
input [1:0]ALUSrcB, PCSource;
input [2:0]ALUOp;
input Reset,Clk;

	/*********************/
	
	/*******OUTPUTS*******/
	
output [5:0] Out_to_Control;				//first 6 bits of instruction to control
output [31:0] ALUOut;						//ALUOut for testing

	/*********************/
	
	/********WIRES********/
	
wire Write;
assign Write = 1'b1;

wire or_to_PC;
wire [15:0] mux_PCSource_Out,PC_Out;
wire [31:0] IMem_Out;
wire [31:0] ALU_out;
wire [31:0] DMem_Out;

wire [4:0] ReadReg1, ReadReg2, ReadReg3;
wire [15:0] Imm;

wire [31:0] DMem_Reg_Out;
wire [4:0] Read2Select_Out;

wire [31:0] RegFile_WriteData;
wire [31:0] DataRead1,DataRead2;
wire [31:0] A_Out;
wire [31:0] B_Out;

wire [31:0] SE16_Out, SL2_B;
wire [31:0] A_Select, B_Select;

wire [31:0]ALUResult;
wire zero;

wire [15:0] mux_PCSource_Out;

wire [25:0]PC_b4_SL2;
wire [27:0]PC_after_SL2;
wire [31:0]PC_sel2;

wire not_zero;
wire Branch_Out;


	/*********************/
	
	
	//BREAKING UP INTO STAGES
	
	/******STAGE 1 PROGRAM COUNTER******/
	
	Register #(16) PC (mux_PCSource_Out,PC_Out,or_to_PC,Reset,Clk);

	/***********END STAGE 1*************/
	
	/******STAGE 2 DMem && IMem ********/
	
	//DMEM
	DMem dataMemory (ALU_out,DMem_Out,ALU_out,MemWrite,Clk);//MemWrite
	
	//IMEM
	IMem instructionMemory (PC_Out,IMem_Out);//No Control Signal
	
	/***********END STAGE 2*************/
	
	
	/******STAGE 3 IR and Mem Data Reg***/
	
	//IR_Reg
	InstructionRegister IR (IMem_Out, Clk, Reset, IRWrite, Out_to_Control, ReadReg1, ReadReg2, ReadReg3, Imm);

	//DMEM_Reg
	Register MDR (DMem_Out,DMem_Reg_Out,Write,Reset,Clk);
	
	/************STAGE 3 END*************/
	
	/************STAGE 4 REG FILE && RA && RB********/
	
	//MUX_Read2_Select
	MUX_2_1 mux_Read2_Sel(ReadReg3, ReadReg1, R1orR3, Read2Select_Out);

	//Register File
	nbit_register_file Register_File (RegFile_WriteData, DataRead1, DataRead2, ReadReg2, Read2Select_Out, ReadReg1, RegWrite, Clk);
	
	//RegA
	Register A (DataRead1,A_Out,Write,Reset,Clk);
	
	//RegB
	Register B (DataRead2,B_Out,Write,Reset,Clk);

	assign PC_b4_SL2 = {ReadReg1,ReadReg2,Imm};

	//Shift Left 2
	SL2_PC ShiftLeft2Module(PC_b4_SL2, PC_after_SL2);

	assign PC_sel2 = {Out_to_Control, PC_after_SL2};

	/**********STAGE 4 END***************/
	
	/**********STAGE 5 BEGIN*************/
	
	//mux_ALUSrcA
	MUX_2_1 mux_A_sel(PC_Out, A_Out, ALUSrcA, A_Select);

	//SignExtend
	SignExtend SE( Imm, SE16_Out);

	//Shift Left 2
	SL2_muxB ShiftLeft2Module(SE16_Out, SL2_B);

	//mux_ALUSrcB
	MUX_4_1 mux_B_sel(B_Out, 32'b4, SE16_Out, SL2_B, ALUSrcB, B_Select);

	//ALU
	Ideal_ALU ALU (ALUResult, A_Select, B_Select, ALUOp, zero);
	
	//ALU_Result_Reg
	Register ALUout (ALUResult,ALU_out,Write,Reset,Clk);

	//Mux that selects the next instruction address
	MUX_4_1 mux_PC_ADDR(ALUResult, ALU_out, PC_sel2, 0, PCSource, mux_PCSource_Out);

	assign ALUOut = ALU_out;

	//NOT gate to invert zero
	not not_zero (zero_not,zero);

	//AND gate to allow next Branch Instruction to be written to PC
	and and_to_or_PC (not_zero,PCWriteCond,Branch_Out);

	//OR gate to allow next instruciton to be written to PC
	or or_to_PC (Branch_Out,PCWrite,or_to_PC);//PCWrite;

   /*************STAGE 5 END************/

endmodule
