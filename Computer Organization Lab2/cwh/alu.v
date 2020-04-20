`timescale 1ns/1ps
//0316044_0316225
module alu(
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

wire            zero;
wire            cout;
wire            overflow;

//for slt 
wire            eq31;
wire            lt;
wire            set;


reg [1:0] oper;
wire [31:0] carry;
reg a_in;
reg b_in;
reg less_sig;

//ZCY flag 
assign carry[0] = (ALU_control==4'b0110)? 1: (ALU_control==4'b0111)? 1: 0; //sub or slt, cin = 1
assign zero = (result == 0) ? 1 : 0;
assign overflow = carry[31] ^ cout;

//slt judge
assign eq31 = src1[31] ^ ~src2[31]; //a, -b same sign or not
assign lt = eq31 ? carry[31]^1 : src1[31]; //same => no overflow, not => use a sign(avoid overflow)
assign set = 0;
//assign res = less_sig ? (lt ? 1 : 0) : res;

always@(*)begin
	if(rst_n==1)begin
		less_sig <= 1'b0;
		
		case(ALU_control)
			4'b0000:begin//And
					a_in  	<= 0;
					b_in 	<= 0;
					oper  	<= 2'b00;//and
					end
			4'b0001:begin//Or
					a_in  	<= 0;
					b_in 	<= 0;
					oper  	<= 2'b01;//or
					end
			4'b0010:begin//Add
					a_in  	<= 0;
					b_in 	<= 0;
					oper  	<= 2'b10;//add
					end
			4'b0110:begin//Sub
					a_in  	<= 0;
					b_in 	<= 1;
					oper  	<= 2'b10;//add
					end
			4'b1100:begin//Nor
					a_in  	<= 1;
					b_in 	<= 1;
					oper  	<= 2'b00;//and
					end
			4'b1101:begin//Nand
					a_in  	<= 1;
					b_in 	<= 1;
					oper  	<= 2'b01;//or
					end
			4'b0111:begin//SetLessThan
					a_in  	<= 0;
					b_in 	<= 1;
					oper  	<= 2'b11;//less
					end
			default: ;
		endcase
	end
end

//diff lt
alu_last alu0( .src1(src1[0]), .src2(src2[0]), .less(lt), .A_invert(a_in), .B_invert(b_in),
					.cin(carry[0]), .operation(oper), .result(result[0]), .cout(carry[1]) );

parameter NBIT = 30;
generate
genvar i;
for (i=1; i<=NBIT; i=i+1)
begin: 
alu_top alui( .src1(src1[i]), .src2(src2[i]), .less(set), .A_invert(a_in), .B_invert(b_in),
				  .cin(carry[i]), .operation(oper), .result(result[i]), .cout(carry[i+1]) );
end
endgenerate 

//diff cout
alu_last alu31( .src1(src1[31]), .src2(src2[31]), .less(set), .A_invert(a_in), .B_invert(b_in),
					.cin(carry[31]), .operation(oper), .result(result[31]), .cout(cout) );


endmodule