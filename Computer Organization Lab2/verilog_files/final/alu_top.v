/***************************************************
Student Name: Yan-Tong Lin
Student ID: 0712238
Date: 2020/04/20
***************************************************/

`timescale 1ns/1ps

module alu_top(
	src1,       //1 bit source 1 (input)
	src2,       //1 bit source 2 (input)
	A_invert,   //1 bit A_invert (input)
	B_invert,   //1 bit B_invert (input)
	cin,        //1 bit carry in (input)
	operation,  //operation      (input)
	//set,       //1 bit set     (input) signal from alu.v
	result,     //1 bit result   (output)
	cout       //1 bit carry out(output)
);

input         src1;
input         src2;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;
//input         set;

output   reg  result; //can be ressign
output   reg   cout;

reg s1, s2;

always@( * )begin

	s1 = A_invert ? ~src1 : src1;
	s2 = B_invert ? ~src2 : src2;

	case(operation)
		2'b00:begin//And
			result = s1 & s2;
			cout = 0;
			end
			
		2'b01:begin//Or
			result = s1 | s2;
			cout = 0;
			end
		
		2'b10:begin//Add
			result = s1 ^ s2 ^ cin;
			cout = (s1&s2) + (s1&cin) + (s2&cin); 
			end
		
		2'b11:begin//SLT
			result = 0;
			cout = (s1&s2) + (s1&cin) + (s2&cin); 
			end
	endcase
	
end

endmodule