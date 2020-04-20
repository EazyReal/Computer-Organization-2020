/***************************************************
Student Name: Yan-Tong Lin
Student ID: 0712238
Date: 2020/04/20
***************************************************/

`timescale 1ns/1ps

module alu_top(
	src1,       //1 bit source 1 (input)
	src2,       //1 bit source 2 (input)
	set,       //1 bit set     (input) signal from alu.v
	A_invert,   //1 bit A_invert (input)
	B_invert,   //1 bit B_invert (input)
	cin,        //1 bit carry in (input)
	operation,  //operation      (input)
	result,     //1 bit result   (output)
	cout       //1 bit carry out(output)
);

input         src1;
input         src2;
input         set;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output   reg  result; //can be ressign
output   reg   cout;

reg s1, s2;

reg done;

always@( * )begin

done = 0;

if(done == 0)begin
	if(A_invert) s1 = ~src1;	else s1 = src1;
	if(B_invert) s2 = ~src2;	else s2 = src2;
	
	case(operation)
		2'b00:begin//And
			result = s1 & s2;
			cout = 0;end
			
		2'b01:begin//Or
			result = s1 | s2;
			cout = 0;end
		
		2'b10:begin//Add
			result = s1 ^ s2 ^ cin;
			cout = (s1&s2) + (s1&cin) + (s2&cin); 
			end
		
		2'b11:begin//less
			result = set;
			cout = (s1&s2) + (s1&cin) + (s2&cin); 
			end
	endcase
	
	done = 1;
	
end
else begin
	result = result;
	cout = cout;
end
	
end

endmodule