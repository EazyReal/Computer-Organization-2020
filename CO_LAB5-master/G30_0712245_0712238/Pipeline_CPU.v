/***************************************************
Student Name: 
Student ID: 
***************************************************/

`timescale 1ns/1ps
module Pipeline_CPU(
	input clk_i,
	input rst_i
	);
/*PC*/
//wire [31:0] pc_i;
wire [31:0] pc_o;
/* Mux 2-to-1 oringinalPCSrc */
wire [31:0] next_pc;


/*Adder PC+4*/
wire [31:0] pc_plus_4;

/*I_Mem*/
wire [31:0] instr;

/*ID Stage*/
wire [31:0] id_pc_o;
wire [31:0] id_instr_o;
wire [4-1:0] alu_ctrl_instr_id = {id_instr_o[30], id_instr_o[14:12]};

/*Decoder signal out*/
wire 	    MemRead,MemWrite;
wire 	    ALUSrc;
wire 	    Branch;
wire [1:0]  ALUOp;
wire 	    MemtoReg;
wire 	    RegWrite;
wire [1:0]  Jump;

/*RegFile*/
wire [31:0] RSdata_o;
wire [31:0] RSdata2_o;
wire [31:0] RTdata_o;
wire [31:0] RTdata2_o;
wire [31:0] RDdata_i;

/*Imm_Gen*/
wire [31:0] Imm_Gen_o;

/*EX Stage*/
wire 	    MemRead_ex,MemWrite_ex;
wire 	    ALUSrc_ex;
wire 	    branch_ex;
wire [1:0]  ALUOp_ex;
wire 	    MemtoReg_ex;
wire 	    RegWrite_ex;
wire [32-1:0] pc_ex;
wire [32-1:0] Imm_Gen_ex;
wire [4-1:0] alu_ctrl_instr_ex;
wire [32-1:0] RSData_ex;
wire [32-1:0] RTData_ex;
wire [5-1:0] RD_ex;

/* Fowarding unit input*/
wire [5-1:0] Rs1_id;
wire [5-1:0] Rs2_id;
wire [2-1:0]  select_Foward_A;
wire [2-1:0]  select_Foward_B;

/*Shift-Left 1*/
wire [31:0] shift_res;

/*Adder PC+Imm*/
wire [31:0] Adder_to_Mux;

/*Mux ALUSrc output*/
wire [31:0] src2;

/*Mux_Foward_A output*/
wire [32-1:0] Forward_A_o;

/*Mux_Foward_B output*/
wire [32-1:0] Forward_B_o;

/*ALU*/
wire [31:0] ALUresult;
wire        zero;
wire 	    cout;
wire        overflow;

/*ALU_Control*/
wire [4-1:0] alu_ctrl;

/*MEM Stage*/
wire 	    	MemRead_mem,MemWrite_mem;
wire 	    	branch_mem;
wire 	    	MemtoReg_mem;
wire 	    	RegWrite_mem;
wire  [32-1:0]  pc_mem;
wire        	zero_mem;
wire  [32-1:0]  alu_result_mem;     
wire  [32-1:0]  RTdata_mem;
wire  [5-1:0]   RD_mem; 

/*Data Memory*/
wire [31:0] DM_o;

/*Branch & Zero*/
wire 	     originalPCSrc = zero_mem & branch_mem;
	

/*WB Stage*/
wire 	    	MemtoReg_wb;
wire 	    	RegWrite_wb;

wire  [32-1:0]  alu_result_wb;     
wire  [32-1:0]  DM_wb;
wire  [5-1:0]   RD_wb; 

/*Mux MemtoReg*/
wire [31:0] Mux_MemtoReg_o;

MUX_2to1 Mux_OringinalPCSrc(
			.data0_i(pc_plus_4),       
			.data1_i(pc_mem),
			.select_i(originalPCSrc),
			.data_o(next_pc)
			);	

ProgramCounter PC(
            		.clk_i(clk_i),      
	    		.rst_i(rst_i),     
	    		.pc_i(next_pc) ,   
	    		.pc_o(pc_o) 
	    		);

Instr_Memory IM(
	        	.addr_i(pc_o),  
		    	.instr_o(instr)    
		    	);		

// PC+4		
Adder Adder1(
            		.src1_i(pc_o),     
		    	.src2_i(32'd4),     
		    	.sum_o(pc_plus_4)    
			);

/*IF/ID Stage*/
IF_ID_reg IF_ID(
	            	.clk_i(clk_i),      
		    	.rst_i(rst_i),
		    	.pc_i(pc_o),
		    	.instr_i(instr),
            		.pc_o(id_pc_o),
            		.instr_o(id_instr_o)
			);

Decoder Decoder(
            		.instr_i(id_instr_o), 
		    	.ALUSrc(ALUSrc),
		    	.MemtoReg(MemtoReg),
		    	.RegWrite(RegWrite),
		    	.MemRead(MemRead),
		    	.MemWrite(MemWrite),
		    	.Branch(Branch),
		    	.ALUOp(ALUOp),
    	    		.Jump(Jump) // need checking
	    		);


Reg_File RF(
	        	.clk_i(clk_i),      
			.rst_i(rst_i) ,     
	        	.RSaddr_i(id_instr_o[19:15]) ,  
	        	.RTaddr_i(id_instr_o[24:20]) ,  
	        	.RDaddr_i(RD_wb) , // from WB  
	        	.RDdata_i(Mux_MemtoReg_o)  , // from WB 
	        	.RegWrite_i (RegWrite_wb), // from MEM/WB
	        	.RSdata_o(RSdata_o) ,  
	        	.RTdata_o(RTdata_o)   
        		);	

Imm_Gen ImmGen(
			.instr_i(id_instr_o),
			.Imm_Gen_o(Imm_Gen_o)
			);



MUX_2to1 Mux_IDEX_control1(
    			.data0_i(RSdata_o),
    			.data1_i(Mux_MemtoReg_o),
    			.select_i(!(id_instr_o[19:15] ^ RD_wb)),
    			.data_o(RSdata2_o)
			);


MUX_2to1 Mux_IDEX_control2(
    			.data0_i(RTdata_o),
    			.data1_i(Mux_MemtoReg_o),
    			.select_i(!(id_instr_o[24:20] ^ RD_wb)),
    			.data_o(RTdata2_o)
			);



/*ID/EXE Stage*/
ID_EX_reg ID_EX(
			.clk_i(clk_i),      
			.rst_i(rst_i),

			/*Control signal input*/
			.ALUSrc_i(ALUSrc),
			.MemtoReg_i(MemtoReg),
			.RegWrite_i(RegWrite),
			.MemRead_i(MemRead),
			.MemWrite_i(MemWrite),
			.Branch_i(Branch),
			.ALUOp_i(ALUOp),
	
			/*Data input*/
			.pc_ID_EX_i(id_pc_o),
		    	.RSdata_i(RSdata2_o),
		    	.RTdata_i(RTdata2_o),
		    	.Imm_Gen_i(Imm_Gen_o),
			.ALU_Ctrl_i(alu_ctrl_instr_id),
			.RDaddr_i(id_instr_o[11:7]), // rd number
	
			/* Fowarding input*/
			.Rs1_IF_ID_i(id_instr_o[19:15]),
			.Rs2_IF_ID_i(id_instr_o[24:20]),

			/*Control signal output*/
			.ALUSrc_o(ALUSrc_ex),
			.MemtoReg_o(MemtoReg_ex),
			.RegWrite_o(RegWrite_ex),
			.MemRead_o(MemRead_ex),
			.MemWrite_o(MemWrite_ex),
			.Branch_o(branch_ex),
			.ALUOp_o(ALUOp_ex),

			/*Data output*/
			.pc_ID_EX_o(pc_ex),
			.RSdata_o(RSData_ex),
		    	.RTdata_o(RTData_ex),
			.Imm_Gen_o(Imm_Gen_ex),
			.ALU_Ctrl_o(alu_ctrl_instr_ex),
			.RDaddr_o(RD_ex),

			/* Fowarding output*/
			.Rs1_IF_ID_o(Rs1_id),
			.Rs2_IF_ID_o(Rs2_id)
			);

	
	
Shift_Left_1 SL1(
			.data_i(Imm_Gen_ex),
			.data_o(shift_res)
			);
	
			
ALU_Ctrl ALU_Ctrl(
			.instr(alu_ctrl_instr_ex),
			.ALUOp(ALUOp_ex),
			.ALU_Ctrl_o(alu_ctrl)
			);
		
Adder Adder2(
        		.src1_i(pc_ex),     
			.src2_i(shift_res),     
			.sum_o(Adder_to_Mux)    
			);

MUX_3to1 Mux_Foward_A(
			.data0_i(RSData_ex),       
			.data1_i(Mux_MemtoReg_o),
			.data2_i(alu_result_mem),
			.select_i(select_Foward_A),
			.data_o(Forward_A_o)
			);

MUX_3to1 Mux_Forward_B(
			.data0_i(RTData_ex),       
			.data1_i(Mux_MemtoReg_o),
			.data2_i(alu_result_mem),
			.select_i(select_Foward_B),
			.data_o(Forward_B_o)
			);	

MUX_2to1 Mux_ALUSrc(
			.data0_i(Forward_B_o),       
			.data1_i(Imm_Gen_ex),
			.select_i(ALUSrc_ex),
			.data_o(src2)
			);

alu alu(
			.rst_n(rst_i),
			.src1(Forward_A_o),
			.src2(src2),
			.ALU_control(alu_ctrl),
			.zero(zero),
			.result(ALUresult),
			.cout(cout),
			.overflow(overflow)
        		);

Forwarding_Unit FU(
			.clk_i(clk_i),      
			.rst_i(rst_i),
			.Rs1_ID_EX(Rs1_id),
			.Rs2_ID_EX(Rs2_id),
			.Rd_EX_MEM(RD_mem),
			.Rd_MEM_WB(RD_wb),
			.RegWrite_EX_MEM(RegWrite_mem),
			.RegWrite_MEM_WB(RegWrite_wb),
			.Forward_A(select_Foward_A),
			.Forward_B(select_Foward_B)
			);

/*EX/MEM Stage*/
EX_MEM_reg EX_MEM(
			.clk_i(clk_i),      
			.rst_i(rst_i),
			/*Control signal input*/
			.MemtoReg_i(MemtoReg_ex),
			.RegWrite_i(RegWrite_ex),
			.MemRead_i(MemRead_ex),
			.MemWrite_i(MemWrite_ex),
			.Branch_i(branch_ex),
			
			/*Data input*/
        		.PC_add_sum_i(Adder_to_Mux),
        		.zero_i(zero),
        		.alu_result_i(ALUresult),
			.RTdata_i(Forward_B_o),
			.RDaddr_i(RD_ex),

			/*Control signal output*/
			.MemtoReg_o(MemtoReg_mem),
			.RegWrite_o(RegWrite_mem),
			.MemRead_o(MemRead_mem),
			.MemWrite_o(MemWrite_mem),
			.Branch_o(branch_mem),
	

			/*Data output*/
			.PC_add_sum_o(pc_mem),
		    	.zero_o(zero_mem),
			.alu_result_o(alu_result_mem),
			.RTdata_o(RTdata_mem),
			.RDaddr_o(RD_mem)
			);

Data_Memory Data_Memory(
			.clk_i(clk_i),
			.addr_i(alu_result_mem),
			.data_i(RTdata_mem),
			.MemRead_i(MemRead_mem),
			.MemWrite_i(MemWrite_mem),
			.data_o(DM_o)
			);	


/*MEM/WB Stage*/
MEM_WB_reg MEM_WB(
			.clk_i(clk_i),      
			.rst_i(rst_i),
			/*Control signal input*/
			.MemtoReg_i(MemtoReg_mem),
			.RegWrite_i(RegWrite_mem),

	
			/*Data input*/
	        	.data_i(DM_o),
	        	.alu_result_i(alu_result_mem),
			.RDaddr_i(RD_mem),

			/*Control signal output*/
			.MemtoReg_o(MemtoReg_wb),
			.RegWrite_o(RegWrite_wb),
			
			/*Data output*/
			.data_o(DM_wb),
			.alu_result_o(alu_result_wb),
			.RDaddr_o(RD_wb)
			);

		
MUX_2to1 Mux_MemtoReg(
			.data0_i(alu_result_wb),       
			.data1_i(DM_wb),
			.select_i(MemtoReg_mem),
			.data_o(Mux_MemtoReg_o)
			);

endmodule
		