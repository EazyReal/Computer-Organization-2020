/***************************************************
Student Name: 高魁駿
Student ID: 0712245
***************************************************/

`timescale 1ns/1ps

module MUX_3to1(
	input  [31:0] data0_i,       
	input  [31:0] data1_i,
	input  [31:0] data2_i,
	input  [ 1:0] select_i,
	output [31:0] data_o
    );		   

reg     [32-1:0] data_out;

//Main function
always@(*)begin
    case(select_i)
        2'b00:
            data_out = data0_i;
        2'b01:
            data_out = data1_i;
        2'b10:
            data_out = data2_i;
    endcase
end
  
assign data_o = data_out;
  


endmodule      
          