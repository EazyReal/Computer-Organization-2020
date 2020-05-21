/***************************************************
Student Name: 高魁駿
Student ID: 0712245
***************************************************/

`timescale 1ns/1ps
module Simple_Single_CPU(
	input clk_i,
	input rst_i
	);

wire [31:0] pc_i;
wire [31:0] pc_o;
wire [31:0] pc_src_o;

wire [31:0] instr;
wire 	    RegWrite;
wire [31:0] RSdata_o;
wire [31:0] RTdata_o;
wire [31:0] RDdata_i;

wire [31:0] ALUresult;
wire 	    MemRead,MemWrite;
wire 	    ALUSrc;
wire 	    Branch;
wire [1:0]  ALUOp;
wire [31:0] Imm_Gen_o;
wire [31:0] shift_res;
wire [31:0] Mux_to_ALU;
wire        zero;
wire [31:0] pc_plus_4;
wire [31:0] Adder_to_Mux;
	
wire [4-1:0] alu_ctrl_instr = {instr[30], instr[14:12]};
wire [4-1:0] alu_ctrl;
wire cout;
wire overflow;

// new added
wire 	    MemtoReg;
wire [1:0]  Jump;
wire [31:0] DM_o;
wire [31:0] Mux_MemtoReg;


ProgramCounter PC(
            .clk_i(clk_i),      
	    .rst_i(rst_i),     
	    .pc_i(pc_i) ,   
	    .pc_o(pc_o) 
	    );

Instr_Memory IM(
            .addr_i(pc_o),  
	    .instr_o(instr)    
	    );		

Reg_File RF(
        .clk_i(clk_i),      
	.rst_i(rst_i) ,     
        .RSaddr_i(instr[19:15]) ,  
        .RTaddr_i(instr[24:20]) ,  
        .RDaddr_i(instr[11:7]) ,  
        .RDdata_i(RDdata_i)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(RSdata_o) ,  
        .RTdata_o(RTdata_o)   
        );		

Data_Memory Data_Memory(
		.clk_i(clk_i),
		.addr_i(ALUresult),
		.data_i(RTdata_o),
		.MemRead_i(MemRead),
		.MemWrite_i(MemWrite),
		.data_o(DM_o)
		);
		
Decoder Decoder(
            .instr_i(instr), 
	    .ALUSrc(ALUSrc),
	    .MemtoReg(MemtoReg),
	    .RegWrite(RegWrite),
	    .MemRead(MemRead),
	    .MemWrite(MemWrite),
	    .Branch(Branch),
	    .ALUOp(ALUOp),
    	    .Jump(Jump)
	    );
		
Adder Adder1(
            .src1_i(pc_o),     
	    .src2_i(32'd4),     
	    .sum_o(pc_plus_4)    
	    );
		
Imm_Gen ImmGen(
		.instr_i(instr),
		.Imm_Gen_o(Imm_Gen_o)
		);
	
Shift_Left_1 SL1(
		.data_i(Imm_Gen_o),
		.data_o(shift_res)
		);
	
MUX_2to1 Mux_ALUSrc(
		.data0_i(RTdata_o),       
		.data1_i(Imm_Gen_o),
		.select_i(ALUSrc),
		.data_o(Mux_to_ALU)
		);
			
ALU_Ctrl ALU_Ctrl(
		.instr(alu_ctrl_instr),
		.ALUOp(ALUOp),
		.ALU_Ctrl_o(alu_ctrl)
		);
		
Adder Adder2(
            .src1_i(pc_o),     
	    .src2_i(shift_res),     
	    .sum_o(Adder_to_Mux)    
	    );
		
alu alu(
	.rst_n(rst_i),
	.src1(RSdata_o),
	.src2(Mux_to_ALU),
	.ALU_control(alu_ctrl),
	.zero(zero),
	.result(ALUresult),
	.cout(cout),
	.overflow(overflow)
        );

MUX_2to1 Mux_PCSrc(
		.data0_i(pc_plus_4),       
		.data1_i(Adder_to_Mux),
		.select_i(zero & Branch),
		.data_o(pc_src_o)
		//.data_o(pc_i)
		);	

MUX_3to1 Mux_PCSrc_2(
		.data0_i(pc_src_o),
		//.data0_i(pc_i),       
		.data1_i(shift_res),
		.data2_i(RSdata_o),
		.select_i(Jump),
		.data_o(pc_i)
		);

MUX_3to1 Mux_Write_Reg(
		.data0_i(Mux_MemtoReg),       
		.data1_i(pc_o + 32'd4),
		.data2_i(32'd0),
		.select_i(Jump),
		.data_o(RDdata_i)
		);
		
MUX_2to1 Mux_Mem_To_Reg(
		.data0_i(ALUresult),       
		.data1_i(DM_o),
		.select_i(MemtoReg),
		.data_o(Mux_MemtoReg)
		);

endmodule
		  


