/***************************************************
Student Name: 
Student ID: 
***************************************************/

`timescale 1ns/1ps

module Decoder(
	input 		 [31:0] 	instr_i,
	output  reg		        ALUSrc,
	output  reg		        MemtoReg,
	output  reg  		        RegWrite,
	output  reg		        MemRead,
	output  reg		        MemWrite,
	output  reg		        Branch,
	output	reg	 [1:0]		ALUOp,
	output  reg	 [1:0]		Jump
	);


always@ * 
	begin
	case(instr_i[7-1:0]) 
		/* R-format */
		7'b0110011:
			begin
				ALUSrc <= 0; 
				MemtoReg <= 0; 
				RegWrite <= 1; 
				MemRead <= 0; 
				MemWrite <= 0; 
				Branch <= 0; 
				ALUOp <= 2'b10; 
				Jump <= 2'b00;
			end
		//Load
		7'b0000011:
			begin
				ALUSrc <= 1; 
				MemtoReg <= 1; 
				RegWrite <= 1; 
				MemRead <= 1; 
				MemWrite <= 0; 
				Branch <= 0; 
				ALUOp <= 2'b00; 
				Jump <= 2'b00;
			end
		/* S-type */
		7'b0100011:
			begin
				ALUSrc <= 1; 
				RegWrite <= 0; 
				MemRead <= 0; 
				MemWrite <= 1; 
				Branch <= 0; 
				ALUOp <= 2'b00; 
				Jump <= 2'b00;
			end
		/* SB-type */
		7'b1100011:
			begin
				ALUSrc <= 0; 
				RegWrite <= 0; 
				MemRead <= 0; 
				MemWrite <= 0; 
				Branch <= 1; 
				ALUOp <= 2'b01; 
				Jump <= 2'b00;
			end
		//Immediate
		7'b0010011:
			begin
				ALUSrc <= 1; 
				MemtoReg <= 0; 
				RegWrite <= 1; 
				MemRead <= 0; 
				MemWrite <= 0; 
				Branch <= 0; 
				ALUOp <= 2'b11; 
				Jump <= 2'b00;
			end

		// JAL
		7'b1101111:
			begin
				ALUSrc <= 0; 
				MemtoReg <= 0; 
				RegWrite <= 1; 
				MemRead <= 0; 
				MemWrite <= 0; 
				Branch <= 0; 
				ALUOp <= 2'b11; 
				Jump <= 2'b01;
			end
		// JALR 
		7'b1100111:
			begin
				ALUSrc <= 0; 
				MemtoReg <= 0; 
				RegWrite <= 1; 
				MemRead <= 0; 
				MemWrite <= 0; 
				Branch <= 0; 
				ALUOp <= 2'b11; 
				Jump <= 2'b10;
			end
		default: 
			begin
				ALUSrc <= 1'bx; 
				MemtoReg <= 1'b0; 
				RegWrite <= 1'bx; 
				MemRead <= 1'bx; 
				MemWrite <= 1'bx; 
				Branch <= 1'b0; 
				ALUOp <= 2'bxx; 
				Jump <= 2'bxx;
			end
	endcase
end


endmodule

