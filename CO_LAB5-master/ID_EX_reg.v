/***************************************************
Student Name: 
Student ID: 
***************************************************/

`timescale 1ns/1ps

module ID_EX_reg(
	input          clk_i,
    	input          rst_i,
	/*Control signal input*/
	input          ALUSrc_i,
	input          MemtoReg_i,
	input          RegWrite_i,
	input          MemRead_i,
	input          MemWrite_i,
	input          Branch_i,
	input [1:0]    ALUOp_i,
	
	/*Data input*/
	input  		[32-1:0] pc_ID_EX_i,
        input  		[32-1:0] RSdata_i,
        input  		[32-1:0] RTdata_i,
        input 		[32-1:0] Imm_Gen_i,
	input		[4-1:0]  ALU_Ctrl_i,
	input  		[5-1:0]  RDaddr_i,
	input		[5-1:0]  Rs1_IF_ID_i,
	input		[5-1:0]  Rs2_IF_ID_i,

	/*Control signal output*/
	output reg          ALUSrc_o,
	output reg          MemtoReg_o,
	output reg          RegWrite_o,
	output reg          MemRead_o,
	output reg          MemWrite_o,
	output reg          Branch_o,
	output reg [1:0]    ALUOp_o,
	
	/*Data output*/
	output reg [32-1:0] pc_ID_EX_o,
	output reg [32-1:0] RSdata_o,
        output reg [32-1:0] RTdata_o,
	output reg [32-1:0] Imm_Gen_o,
	output reg [4-1:0]  ALU_Ctrl_o,
	output reg [5-1:0]  RDaddr_o,
	output reg [5-1:0]  Rs1_IF_ID_o,
	output reg [5-1:0]  Rs2_IF_ID_o
);

always@(posedge clk_i) begin
	if(~rst_i) 
		begin
			/* WB */
			MemtoReg_o <= 1'd0;
	        	RegWrite_o <= 1'd0;
	        	/* M*/
			MemRead_o  <= 1'd0;
	        	MemWrite_o <= 1'd0;
	        	Branch_o   <= 1'd0;
	   		/* Ex*/
			ALUOp_o    <= 1'd0;
			ALUSrc_o   <= 2'd0;
			/* Data*/
			pc_ID_EX_o <= 32'd0;
			RSdata_o   <= 32'd0;
			RTdata_o   <= 32'd0;
			Imm_Gen_o  <= 32'd0;
			ALU_Ctrl_o <= 4'd0;
			RDaddr_o   <= 5'd0;
			Rs1_IF_ID_o <= 5'd0;
			Rs2_IF_ID_o <= 5'd0;
		end
    	else 
		begin
			/* WB */
			MemtoReg_o <= MemtoReg_i;
	        	RegWrite_o <= RegWrite_i;
	        	/* M*/
			MemRead_o  <= MemRead_i;
	        	MemWrite_o <= MemWrite_i;
	        	Branch_o   <= Branch_i;
	   		/* Ex*/
			ALUOp_o    <= ALUOp_i;
			ALUSrc_o   <= ALUSrc_i;
			/* Data*/
			pc_ID_EX_o <= pc_ID_EX_i;
			RSdata_o   <= RSdata_i;
			RTdata_o   <= RTdata_i;
			Imm_Gen_o  <= Imm_Gen_i;
			ALU_Ctrl_o <= ALU_Ctrl_i;
			RDaddr_o   <= RDaddr_i;
			Rs1_IF_ID_o <= Rs1_IF_ID_i;
			Rs2_IF_ID_o <= Rs2_IF_ID_i;
		end
end

endmodule 