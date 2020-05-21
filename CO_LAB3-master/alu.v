/***************************************************
Student Name: 高魁駿
Student ID: 0712245
***************************************************/
`timescale 1ns/1ps

module alu(
	input                   rst_n,         // negative reset            (input)
	input	     [32-1:0]	src1,          // 32 bits source 1          (input)
	input	     [32-1:0]	src2,          // 32 bits source 2          (input)
	input 	     [ 4-1:0] 	ALU_control,   // 4 bits ALU control input  (input)
	output reg   [32-1:0]	result,        // 32 bits result            (output)
	output reg              zero,          // 1 bit when the output is 0, zero must be set (output)
	output reg              cout,          // 1 bit carry out           (output)
	output reg              overflow       // 1 bit overflow            (output)
	);


wire   [32-1:0] result_wire;
wire            carryout;
wire            overflow_wire;


always @* 
   begin
      if (rst_n) begin          
	cout <= 1'b0;
	overflow <= 1'b0; 
	case(ALU_control)
		/* AND :0*/
		4'b0000: 
			begin 
				result <= src1 & src2;
				zero <= (result == 0)?1:0; 
			end
		/* OR :1*/	
		4'b0001: 
			begin 
				result <= src1 | src2; 
				zero <= (result == 0)?1:0;  
			end
		/* ADD :2*/
		4'b0010: 
			begin
				result <= src1 + src2;
				zero <= (result == 0)?1:0; 
			end
		/* SLL :3*/
		4'b0011: 
			begin
				result <= src1 << src2;
				zero <= (result == 0)?1:0; 
			end
		/* SRL :4*/
		4'b0100: 
			begin
				result <= src1 >> src2;
				zero <= (result == 0)?1:0; 
			end
		/* SRA :5*/
		4'b0101: 
			begin
				result <= src1 >>> src2;
				zero <= (result == 0)?1:0; 
			
			end
		/* SUB :6*/
		4'b0110: 
			begin
				result <= src1 - src2;
				zero <= (result == 0)?1:0; 	
			end
		/* SLT :7*/
		4'b0111: 
			begin
				result <= (src1 < src2)?1:0;
				zero <= (result == 0)?1:0; 	   
			end
		/* BEQ :10*/
		4'b1010: 
			begin
				result <= src1 - src2;
				zero <= (result == 0)?1:0; 
			end

		/* BNE :11*/
		4'b1011: 
			begin
				result <= src1 - src2;
				zero <= (result == 0)?0:1;
			
			end
		/* XOR :13*/
		4'b1101: 
			begin
				result <= src1 ^ src2;
				zero <= (result == 0)?1:0; 
			end
		default: result <= 32'd0; 

	endcase
	
      end 
end

endmodule
