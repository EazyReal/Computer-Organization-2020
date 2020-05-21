/***************************************************
Student Name: 
Student ID: 
***************************************************/

`timescale 1ns/1ps

module MUX_2to1(
	input  [32-1:0] data0_i,       
	input  [32-1:0] data1_i,
	input       	select_i,
	output [32-1:0] data_o
               );

reg [32-1:0] data_out;   

always@(*)begin
	case(select_i)
        	0: data_out = data0_i;
        	1: data_out = data1_i;
     	endcase
end

assign data_o = data_out;   

endmodule      
          