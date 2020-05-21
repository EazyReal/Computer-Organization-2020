/***************************************************
Student Name: 高魁駿
Student ID: 0712245
***************************************************/

`timescale 1ns/1ps

module Decoder(
	input  [32-1:0] instr_i,
	output 		ALUSrc,
	output 		RegWrite,
	output 		Branch,
	output [2-1:0]	ALUOp
	);
	

reg            ALUSrc_o;
reg            RegWrite_o;
reg            Branch_o;
reg    [2-1:0] ALU_OP;

always@ * 
	begin
	case(instr_i[7-1:0]) 
		/* R-format */
		7'b0110011:
			begin
				ALUSrc_o <= 0; 
				RegWrite_o <= 1; 
				Branch_o <= 0; 
				ALU_OP <= 2'b10;
			end
		/* SB-type */
		7'b1100011:
			begin
				ALUSrc_o <= 0; 
				RegWrite_o <= 0; 
				Branch_o <= 1; 
				ALU_OP <= 2'b01;
			end
		/* I-type */
		7'b0010011:
			begin
				ALUSrc_o <= 1; 
				RegWrite_o <= 1; 
				Branch_o <= 0; 
				ALU_OP <= 2'b11;
			end
	endcase
end

assign ALUSrc = ALUSrc_o;
assign RegWrite = RegWrite_o;
assign Branch = Branch_o;
assign ALUOp = ALU_OP;

endmodule





                    
                    