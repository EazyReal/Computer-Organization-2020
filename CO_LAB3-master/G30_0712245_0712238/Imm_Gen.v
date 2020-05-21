/***************************************************
Student Name: 
Student ID: 
***************************************************/

`timescale 1ns/1ps

module Imm_Gen(
	input  [31:0] instr_i,
	output [31:0] Imm_Gen_o
	);


reg [31:0] Imm_Gen_out;
wire [7-1:0] opcode = instr_i[7-1:0];

always@ *
begin
	case(opcode)
		// R
		7'b0110011:
			begin 
				Imm_Gen_out <= instr_i;
			end
		// Imm
		7'b0010011: 
			begin
				Imm_Gen_out <= {{20{instr_i[31]}},instr_i[31:20]}; 
			end
		// SB
		7'b1100011: 
			begin
				Imm_Gen_out <= {{20{instr_i[31]}},instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8]}; 
			end

	endcase
end	

assign Imm_Gen_o = Imm_Gen_out;
		
endmodule