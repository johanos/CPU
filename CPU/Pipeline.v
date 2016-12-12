`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:19:01 10/16/2015 
// Design Name: 
// Module Name:    Pipeline 
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
module Pipeline(
	input clk,
	input rst,
	input [31:0] InstrIn,
	input  WriteEnable,
	output [31:0] Out
   );


	// The naming format for wire: Source_Destination_portname
	// What goes into the S1 reg? 
	
	// InstrIn, clk, rst, 
	
	// What comes out of S1? 
	
	// Read Select 1
	wire [4:0]  S1_Reg_ReadSelect1; //Read Select 1 from S1
	// Read Select 2
	wire [4:0]  S1_Reg_ReadSelect2; //Read Select 2 from 
	// S1 to S2 Immediate
	wire [15:0] S1_S2_Immediate;	  //Immediate from S1
	// S1 to S2 Data Source
	wire 			S1_S2_DataSource;
	// S1 to S2 ALU op
	wire [2:0]  S1_S2_ALUOp;
	// S1 to S2 Write Select
	wire [4:0]  S1_S2_WriteSelect;
	// S1 to S2 Write Enable
	wire        S1_S2_WriteEnable;
	wire [31:0] ALU_S3_ALUOut;
	
	wire [31:0] S3_Out_ALUOut; //final output but goes register file!
	
	wire [4:0] S2_S3_WriteSelect;
	wire 		  S2_S3_WriteEnable;
	
	wire [4:0] S3_Out_WriteSelect;
	wire 		  S3_Out_WriteEnable;
	
	/* MUX PARAMETERS */
	
	wire [31:0] S2_Mux0_ReadData2;
	wire [15:0] S2_Mux1_Immediate;
	wire 			S2_MuxSel_DataSource;
	wire [31:0] Mux_ALU_R3;
	
	/*                */
	wire [31:0] S2_ALU_R2;
	wire [2:0]  S2_ALU_ALUOp;
	
	
	S1_Register S1_Reg(
		.clk(clk),
		.rst(rst),
		.InstrIn(InstrIn),
		.S1_ReadSelect1(S1_Reg_ReadSelect1),
		.S1_ReadSelect2(S1_Reg_ReadSelect2),
		.S1_WriteSelect(S1_S2_WriteSelect),
		.S1_WriteEnable(S1_S2_WriteEnable),
		.S1_Imm(S1_S2_Immediate),
		.S1_DataSrc(S1_S2_DataSource),
		.S1_ALUOp(S1_S2_ALUOp)
   );
	
	
	//what goes into nbit register file?
	// Read  Select 1 from S1 -- S1_Reg_ReadSelect1
	// Read  Select 2 from S1 -- S1_Reg_ReadSelect2
	// Write Data     from S3 -- S3_Out_ALUOut
	// Write Select   from S3 -- S3_Out_WriteSelect
	// Write Enable   from S3 -- S3_Out_WriteEnable
	
	//what comes out 
	//Read Data 1 to S2 Reg
	wire [31:0] Reg_S2_ReadData1;	  //Read Data 1 from register file 
	
	//Read Data 2 to S2 Reg
	wire [31:0] Reg_S2_ReadData2;   //Read Data 2 from register file
	
	nbit_register_file #(.data_width(32), .select_width(5)) Register_File (
		.read_sel_1(S1_Reg_ReadSelect1),
		.read_sel_2(S1_Reg_ReadSelect2),
		.write_data(S3_Out_ALUOut),	  //S3 ALUOut 							
		.read_data_1(Reg_S2_ReadData1),
		.read_data_2(Reg_S2_ReadData2),
		.write_address(S3_Out_WriteSelect),
		.RegWrite(S3_Out_WriteEnable),
		.clk(clk)
	);
	
	
	
	
	S2_Register S2_Reg(
		.clk(clk),
		.rst(rst),
		
		.Reg_ReadData1(Reg_S2_ReadData1),
		.Reg_ReadData2(Reg_S2_ReadData2),
		
		.S1_Immediate(S1_S2_Immediate),
		.S1_Datasource(S1_S2_DataSource),
		.S1_ALUOp(S1_S2_ALUOp),
		.S1_WriteSelect(S1_S2_WriteSelect),
		.S1_WriteEnable(S1_S2_WriteEnable),
		
		.S2_ReadData1(S2_ALU_R2),
		.S2_ReadData2(S2_Mux0_ReadData2),
		.S2_Immediate(S2_Mux1_Immediate),
		.S2_Datasource(S2_MuxSel_DataSource),
		.S2_ALUOp(S2_ALU_ALUOp),
		.S2_WriteSelect(S2_S3_WriteSelect),
		.S2_WriteEnable(S2_S3_WriteEnable)
   );
	
	
	
	
	Mux_32bits 
	#(.input_size(32)) 
	mux ( .MuxIn0(S2_Mux0_ReadData2), 
			.MuxIn1( { 16'b0 , S2_Mux1_Immediate} ),
			.MuxOut(Mux_ALU_R3),
			.MuxSel(S2_MuxSel_DataSource)
			
		 );
	 
	 
	 
	
	
	
	Ideal_ALU 
	#(.word_size(32)) 
	alu( 
		  .R1   (ALU_S3_ALUOut),
		  .R2   (S2_ALU_R2),
		  .R3   (Mux_ALU_R3), 
		  .ALUOp(S2_ALU_ALUOp)
		  
	);	
	
	
	
	 

	S3_Register S3_Reg(
		.clk(clk),
		.rst(rst),
		.ALU_ALUOut(ALU_S3_ALUOut),
		.S2_WriteSelect(S2_S3_WriteSelect),
		.S2_WriteEnable(S2_S3_WriteEnable),
		.S3_ALUOut(S3_Out_ALUOut),
		.S3_WriteSelect(S3_Out_WriteSelect),
		.S3_WriteEnable(S3_Out_WriteEnable)
		
	);
	
	assign Out = S3_Out_ALUOut;

endmodule
