/***************************************************
Student Name: 高魁駿
Student ID: 0712245
***************************************************/

`timescale 1ns/1ps

module ALU_Ctrl(
	input		[3:0]	instr,
	input		[1:0]	ALUOp,
	output wire	[3:0] ALU_Ctrl_o
	);
	

reg [4-1:0] ALU_Ctrl_out;

always@* 
begin
	case(ALUOp)
		/* Imm&J */
	  	2'b11: 
			begin
				case(instr[3-1:0])
					///ANDI do and:0
					3'b111: ALU_Ctrl_out <= 4'b0000;
					//ORI 	do or: 1
					3'b110: ALU_Ctrl_out <= 4'b0001;
					//ADDI 	do add: 2
					3'b000: ALU_Ctrl_out <= 4'b0010;
					//SLLI 	do sll: 3
					3'b001: ALU_Ctrl_out <= 4'b0011;
					//SRAI 	do sra: 5
					3'b101: ALU_Ctrl_out <= 4'b0101;  
					//SLTI 	do slt: 7
					3'b010: ALU_Ctrl_out <= 4'b0111;
					//XORI 	do xor: 13
					3'b100: ALU_Ctrl_out <= 4'b1101;
					//J-type don't care
					default: ALU_Ctrl_out <= 4'bxxxx; 
				endcase 
 			end
		/* Load&Store*/
		2'b00: 
			begin
				ALU_Ctrl_out <= 4'b0010;
 			end
		/* SB */
		2'b01:  
			begin
				case(instr[3-1:0])
					//BLT 	do blt:8
					3'b100: ALU_Ctrl_out <= 4'b1000;
					//BGE 	do bge:9
					3'b101: ALU_Ctrl_out <= 4'b1001;
					//BEQ 	do beq:10
					3'b000: ALU_Ctrl_out <= 4'b1010;
					//BNE 	do bne:11
					3'b001: ALU_Ctrl_out <= 4'b1011;
				endcase  
 			end
		/* R */
	  	2'b10:
			begin
				case(instr)
					//AND 	do and: 0
					4'b0111: ALU_Ctrl_out <= 4'b0000;
					//OR 	do  or: 1
					4'b0110: ALU_Ctrl_out <= 4'b0001;
					//ADD 	do add: 2
					4'b0000: ALU_Ctrl_out <= 4'b0010;
					//SLL 	do sll: 3
					4'b0001: ALU_Ctrl_out <= 4'b0011;
					//SRL 	do srl: 4
					4'b0101: ALU_Ctrl_out <= 4'b0100;
					//SRA 	do sra: 5
					4'b1101: ALU_Ctrl_out <= 4'b0101;
					//SUB 	do sub: 6
					4'b1000: ALU_Ctrl_out <= 4'b0110;
					//SLT 	do slt: 7
					4'b0010: ALU_Ctrl_out <= 4'b0111;
					//XOR 	do xor: 13
					4'b0100: ALU_Ctrl_out <= 4'b1101;
				endcase
			end
		
	endcase
end

assign ALU_Ctrl_o = ALU_Ctrl_out; 
 
endmodule