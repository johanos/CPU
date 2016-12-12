module CPU_Datapath(
		Out_to_Control,ALUOut,PCWriteCond,PCWrite,
		IRWrite,R1orR3,RegWrite,ALUSrcA, 
		ALUSrcB,ALUOp,PCSource,MemtoReg,MemWrite,Reset,Clk);
	
	/******INPUTS ********/
	
input PCWriteCond,PCWrite,IRWrite;
input R1orR3,RegWrite,ALUSrcA,MemtoReg,MemWrite;
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

//NAMING CONVENTION = Output module_Input module_Portname
//PC
wire [15:0] PCSourceMux_PC_WriteData;
wire [15:0] PC_IM_PC;
//

//IM

wire [31:0] PC_ALUScrA_0;
wire [31:0] IMem_IR_Instruction;



wire [31:0] ALUout_DateMem_ALURes;
wire [31:0] ALUout_PCSourceMux_1;
wire [31:0] ALUout_MuxMemToReg_0;

assign ALUout_PCSourceMux_1 = ALUout_DateMem_ALURes;
assign ALUout_MuxMemToReg_0 = ALUout_DateMem_ALURes;



wire [31:0] DMem_MDR_In;
wire [31:0] MDR_MuxMemToReg_1;




wire [4:0] IM_MuxR1orR3_1andWriteReg;
wire [4:0] IM_MuxR1orR3_0;
wire [4:0] IM_RegFile_ReadReg1;

wire [15:0] IM_SignExtend_Imm;
wire [31:0] SignExtend_MUX_Inand2;
wire [31:0] One_MuxALUSrcB_1;
assign One_MuxALUSrcB_1 = 31'd1;


wire [25:0] IM_MuxPCSource_2;


assign IM_MuxPCSource_2 = {IM_MuxR1orR3_1andWriteReg, IM_RegFile_ReadReg1, IM_SignExtend_Imm};




wire [4:0] MuxR1orR3_RegFile_ReadReg2;


wire [31:0] MuxMemToReg_RegFile_WriteData;

wire [31:0] RegFile_RA_in;

wire [31:0] RegFile_RB_in;

wire [31:0] RA_MuxALUSrcA_1;
wire [31:0] RB_MuxALUSrcB_0;


wire [31:0] MuxALUSrcA_R2_in;
wire [31:0] MuxALUSrcB_R3_in;
wire [31:0] ALU_ALUoutAndMuxPCSource_inAnd0;

wire [31:0] Truncated_MuxPCSource_2;

assign Truncated_MuxPCSource_2 = IM_MuxPCSource_2[15:0];

wire PCWrite_AND_PCEnable;

wire not_zero;
wire Zero_PCWriteCond_AND;


	/*********************/
	
	
	//BREAKING UP INTO STAGES
	
	/******STAGE 1 PROGRAM COUNTER******/
	
	Register #(.DATA_SIZE(16)) PC (.WriteData(PCSourceMux_PC_WriteData), .ReadData(PC_IM_PC), .Clk(Clk), .Rst(Reset), .Enable(PCWrite_AND_PCEnable));

	/***********END STAGE 1*************/
	
	/******STAGE 2 DMem && IMem ********/
	
	//DMEM
   
	DMem dataMemory (.WriteData(RB_MuxALUSrcB_0), .MemData(DMem_MDR_In), .Address(ALUout_DateMem_ALURes[15:0]), .MemWrite(MemWrite), .Clk(Clk)) ;
	
	//IMEM

	IMem instructionMemory (.PC(PC_IM_PC), .Instruction(IMem_IR_Instruction));//No Control Signal
	
	/***********END STAGE 2*************/
	
	
	/******STAGE 3 IR and Mem Data Reg***/
	
	//IR_Reg
	InstructionRegister IR (.Instruction(IMem_IR_Instruction), .Clk(Clk), .Rst(Reset), .IRWrite(IRWrite), .Opcode(Out_to_Control), .R1(IM_MuxR1orR3_1andWriteReg), .R2(IM_RegFile_ReadReg1), .R3(IM_MuxR1orR3_0),  .Imm(IM_SignExtend_Imm));

	//DMEM_Reg
	Register MDR (.WriteData(DMem_MDR_In), .ReadData(MDR_MuxMemToReg_1), .Clk(Clk), .Rst(Reset), .Enable(Write));
	
	MUX_2_1 MemToRegMUX(.in0(ALUout_MuxMemToReg_0), .in1(MDR_MuxMemToReg_1), .Op(MemtoReg), .MuxOut(MuxMemToReg_RegFile_WriteData));
	
	/************STAGE 3 END*************/
	
	/************STAGE 4 REG FILE && RA && RB********/
	
	//MUX_Read2_Select
	MUX_2_1 #(.W(5)) R1orR3Mux(.in0(IM_MuxR1orR3_0), .in1(IM_MuxR1orR3_1andWriteReg), .Op(R1orR3), .MuxOut(MuxR1orR3_RegFile_ReadReg2));

	//Register File
	nbit_register_file Register_File (
				.write_data(MuxMemToReg_RegFile_WriteData), 
				.read_data_1(RegFile_RA_in), .read_data_2(RegFile_RB_in),
				.read_sel_1(IM_RegFile_ReadReg1), .read_sel_2(MuxR1orR3_RegFile_ReadReg2), 
            .write_address(IM_MuxR1orR3_1andWriteReg), .RegWrite(RegWrite), .clk(Clk));      
	
	//RegA
	Register A (.WriteData(RegFile_RA_in), .ReadData(RA_MuxALUSrcA_1), .Clk(Clk), .Rst(Reset), .Enable(Write));
	
	
	//RegB
	Register B (.WriteData(RegFile_RB_in), .ReadData(RB_MuxALUSrcB_0), .Clk(Clk), .Rst(Reset), .Enable(Write));


	

	/**********STAGE 4 END***************/
	
	/**********STAGE 5 BEGIN*************/
	
	//mux_ALUSrcA

	MUX_2_1 ALUSrcASel(.in0(RegFile_RA_in), .in1(RA_MuxALUSrcA_1), .Op(ALUSrcA), .MuxOut(MuxALUSrcA_R2_in));

	//SignExtend
	SignExtend SE( .In(IM_SignExtend_Imm), .Out(SignExtend_MUX_Inand2));



	//mux_ALUSrcB
	MUX_4_1 ALUSrcBSel(.in0(RB_MuxALUSrcB_0), .in1(One_MuxALUSrcB_1), .in2(SignExtend_MUX_Inand2), .in3(32'b0), .Op(ALUSrcB), .MuxOut(MuxALUSrcB_R3_in));

	//ALU

	Ideal_ALU ALU (.R1(ALU_ALUoutAndMuxPCSource_inAnd0) , .R2(MuxALUSrcA_R2_in), .R3(MuxALUSrcB_R3_in), .ALUOp(ALUOp), .Zero(zero));
	
	//ALU_Result_Reg
	Register ALUout (.WriteData(ALU_ALUoutAndMuxPCSource_inAnd0), .ReadData(ALUout_DateMem_ALURes), .Clk(Clk), .Rst(Reset), .Enable(Write) );
	
	wire [31:0] tempPCSourceMux_PC_WriteData;
	
	//Mux that selects the next instruction address
	MUX_4_1 mux_PCSource(.in0(ALU_ALUoutAndMuxPCSource_inAnd0), .in1(ALUout_PCSourceMux_1), .in2({6'b0,IM_MuxPCSource_2}), .in3(32'b0), .Op(PCSource), .MuxOut(tempPCSourceMux_PC_WriteData));
	assign PCSourceMux_PC_WriteData = tempPCSourceMux_PC_WriteData[15:0];
	

	assign ALUOut = ALUout_DateMem_ALURes;
	
	//NOT gate to invert zero
	not  (not_zero , zero);

	//AND gate to allow next Branch Instruction to be written to PC
	and  (ZeroBar_PCWriteCond_AND, not_zero, PCWriteCond);

	//OR gate to allow next instruciton to be written to PC
	or  (PCWrite_AND_PCEnable, PCWrite, ZeroBar_PCWriteCond_AND);//PCWrite;

   /*************STAGE 5 END************/

endmodule
