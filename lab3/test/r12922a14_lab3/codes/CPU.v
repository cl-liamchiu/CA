module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;

wire [31:0] pc_i, pc_o;

wire [31:0] instr;

wire [1:0] ALUOp;
wire ALUSrc, RegWrite, MemtoReg, MemRead, MemWrite;

wire [31:0] RDdata, RS1data, RS2data, ALUResult, MemData;

wire [31:0] immediate;

wire [31:0] MUXResult;

wire [2:0] operation;

// Forwarding signals
wire [1:0] ForwardA, ForwardB;

wire [31:0] ForwardAData, ForwardBData;

// Hazard Detection signals
wire NoOp, Stall, PCWrite;

// Branch signal
wire Branch;
wire [31:0] branchAddr, AddrResult;
wire [31:0] muxPCResult, muxPCResult2;
wire equal, zero, right;
wire ID_FlushIF, EX_FlushID_IF;

// Pipeline registers
wire [31:0] IF_ID_instr; // instruction
wire [31:0] IF_ID_PC;

// control signals
wire ID_EX_RegWrite;
wire ID_EX_MemtoReg;
wire ID_EX_MemRead;
wire ID_EX_MemWrite;
wire [1:0] ID_EX_ALUOp;
wire ID_EX_ALUSrc;

wire [31:0] ID_EX_RS1data;
wire [31:0] ID_EX_RS2data;

wire [31:0] ID_EX_immediate;

// for ALU Control
wire [6:0] ID_EX_func7;
wire [2:0] ID_EX_func3;

// for registers when writing back
wire [4:0] ID_EX_RS1addr;
wire [4:0] ID_EX_RS2addr;
wire [4:0] ID_EX_RDaddr;

wire ID_EX_Branch;
wire [31:0] ID_EX_branchAddr;
wire [31:0] ID_EX_PCAddr;
wire [31:0] EX_PCAddr;

wire EX_MEM_RegWrite;
wire EX_MEM_MemtoReg;
wire EX_MEM_MemRead;
wire EX_MEM_MemWrite;

wire [31:0] EX_MEM_ALUResult;
wire [31:0] EX_MEM_RS2data;
wire [4:0] EX_MEM_RDaddr;

wire MEM_WB_RegWrite;
wire MEM_WB_MemtoReg;

wire [31:0] MEM_WB_ALUResult;
wire [31:0] MEM_WB_MemData;
wire [4:0] MEM_WB_RDaddr;

wire [1:0] state_reg;
wire take_branch, taken;

branch_predictor branch_predictor(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .zero_i(zero),
    .Branch_i(ID_EX_Branch),
    .taken_i(taken),
    .PCAddr_i(EX_PCAddr),
    .BranchAddr_i(ID_EX_branchAddr),

    .AddrResult_o(AddrResult),
    .right_o(right),
    .predict_o(take_branch),
    .flush_o(EX_FlushID_IF),

    .state_reg_i(state_reg),
    .state_reg_o(state_reg)
);

IF_ID_Register IF_ID(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush_i(ID_FlushIF || EX_FlushID_IF),
    .Stall_i(Stall),
    .instr_i(instr),
    .PC_i(pc_o),
    .instr_o(IF_ID_instr),
    .PC_o(IF_ID_PC)
);

ID_EX_Register ID_EX(
    .flush_i(EX_FlushID_IF),
    .taken_i(ID_FlushIF),
    .Branch_i(Branch),
    .BranchAddr_i(branchAddr),
    .PCAddr_i(IF_ID_PC),
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RegWrite_i(RegWrite),
    .MemtoReg_i(MemtoReg),
    .MemRead_i(MemRead),
    .MemWrite_i(MemWrite),
    .ALUOp_i(ALUOp),
    .ALUSrc_i(ALUSrc),
    .RS1data_i(RS1data),
    .RS2data_i(RS2data),
    .immediate_i(immediate),
    .func7_i(IF_ID_instr[31:25]),
    .func3_i(IF_ID_instr[14:12]),
    .RS1addr_i(IF_ID_instr[19:15]),
    .RS2addr_i(IF_ID_instr[24:20]),
    .RDaddr_i(IF_ID_instr[11:7]),
    .RegWrite_o(ID_EX_RegWrite),
    .MemtoReg_o(ID_EX_MemtoReg),
    .MemRead_o(ID_EX_MemRead),
    .MemWrite_o(ID_EX_MemWrite),
    .ALUOp_o(ID_EX_ALUOp),
    .ALUSrc_o(ID_EX_ALUSrc),
    .RS1data_o(ID_EX_RS1data),
    .RS2data_o(ID_EX_RS2data),
    .immediate_o(ID_EX_immediate),
    .func7_o(ID_EX_func7),
    .func3_o(ID_EX_func3),
    .RS1addr_o(ID_EX_RS1addr),
    .RS2addr_o(ID_EX_RS2addr),
    .RDaddr_o(ID_EX_RDaddr),
    .taken_o(taken),
    .Branch_o(ID_EX_Branch),
    .BranchAddr_o(ID_EX_branchAddr),
    .PCAddr_o(ID_EX_PCAddr)
);

EX_MEM_Register EX_MEM_Register(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RegWrite_i(ID_EX_RegWrite),
    .MemtoReg_i(ID_EX_MemtoReg),
    .MemRead_i(ID_EX_MemRead),
    .MemWrite_i(ID_EX_MemWrite),
    .ALUResult_i(ALUResult),
    .ForwardBData_i(ForwardBData),
    .RDaddr_i(ID_EX_RDaddr),
    .RegWrite_o(EX_MEM_RegWrite),
    .MemtoReg_o(EX_MEM_MemtoReg),
    .MemRead_o(EX_MEM_MemRead),
    .MemWrite_o(EX_MEM_MemWrite),
    .ALUResult_o(EX_MEM_ALUResult),
    .ForwardBData_o(EX_MEM_RS2data),
    .RDaddr_o(EX_MEM_RDaddr)
);

MEM_WB_Register MEM_WB_Register(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RegWrite_i(EX_MEM_RegWrite),
    .MemtoReg_i(EX_MEM_MemtoReg),
    .ALUResult_i(EX_MEM_ALUResult),
    .MemData_i(MemData),
    .RDaddr_i(EX_MEM_RDaddr),
    .RegWrite_o(MEM_WB_RegWrite),
    .MemtoReg_o(MEM_WB_MemtoReg),
    .ALUResult_o(MEM_WB_ALUResult),
    .MemData_o(MEM_WB_MemData),
    .RDaddr_o(MEM_WB_RDaddr)
);


MUX32 MUX32_PC(
    .sel(ID_FlushIF),
    .src1_i(pc_i),
    .src2_i(branchAddr),
    .mux_o(muxPCResult)
);

MUX32 MUX32_PC2(
    .sel(right),
    .src1_i(AddrResult),
    .src2_i(muxPCResult),
    .mux_o(muxPCResult2)
);


PC PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .PCWrite_i(PCWrite),
    .pc_i(muxPCResult2),
    .pc_o(pc_o)
);


Adder Add(
    .src1_i(pc_o), 
    .src2_i('d4), 
    .adder_o(pc_i)
);


Adder Add3(
    .src1_i(ID_EX_PCAddr), 
    .src2_i('d4), 
    .adder_o(EX_PCAddr)
);


Instruction_Memory Instruction_Memory(
    .addr_i(pc_o), 
    .instr_o(instr)
);


Adder Add2(
    .src1_i(immediate << 1), 
    .src2_i(IF_ID_PC), 
    .adder_o(branchAddr)
);

Hazard_Detection_Unit Hazard_Detection(
    .rst_i(rst_i),
    .RS1addr_i(IF_ID_instr[19:15]),
    .RS2addr_i(IF_ID_instr[24:20]),
    .ID_EX_RDaddr_i(ID_EX_RDaddr),
    .ID_EX_MemRead_i(ID_EX_MemRead),
    .NoOp_o(NoOp),
    .Stall_o(Stall),
    .PCWrite_o(PCWrite)
);

Control Control(
    .NoOp_i(NoOp),
    .opcode_i(IF_ID_instr[6:0]),
    .ALUOp_o(ALUOp),
    .ALUSrc_o(ALUSrc),
    .RegWrite_o(RegWrite),
    .MemtoReg_o(MemtoReg),
    .MemRead_o(MemRead),
    .MemWrite_o(MemWrite),
    .Branch_o(Branch)
);


Registers Registers(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .RS1addr_i(IF_ID_instr[19:15]),
    .RS2addr_i(IF_ID_instr[24:20]),
    .RDaddr_i(MEM_WB_RDaddr), 
    .RDdata_i(RDdata),
    .RegWrite_i(MEM_WB_RegWrite), 
    .RS1data_o(RS1data), 
    .RS2data_o(RS2data)
);


Branch_Detection_Unit Branch_Detection(
    .predict_i(take_branch),
    .Branch_i(Branch),
    .flush_o(ID_FlushIF)
);


Imm_Gen Imm_Gen(
    .instr_i(IF_ID_instr),
    .imm_o(immediate)
);


Forwarding_Unit Forwarding(
    .ID_EX_RS1addr_i(ID_EX_RS1addr),
    .ID_EX_RS2addr_i(ID_EX_RS2addr),
    .EX_MEM_RegWrite_i(EX_MEM_RegWrite),
    .EX_MEM_RDaddr_i(EX_MEM_RDaddr),
    .MEM_WB_RegWrite_i(MEM_WB_RegWrite),
    .MEM_WB_RDaddr_i(MEM_WB_RDaddr),
    .ForwardA_o(ForwardA),
    .ForwardB_o(ForwardB)
);


MUX32_Forwarding MUX32_ForwardA(
    .sel(ForwardA),
    .src1_i(ID_EX_RS1data),
    .src2_i(RDdata),
    .src3_i(EX_MEM_ALUResult),
    .mux_o(ForwardAData)
);


MUX32_Forwarding MUX32_ForwardB(
    .sel(ForwardB),
    .src1_i(ID_EX_RS2data),
    .src2_i(RDdata),
    .src3_i(EX_MEM_ALUResult),
    .mux_o(ForwardBData)
);


MUX32 MUX(
    .sel(ID_EX_ALUSrc),
    .src1_i(ForwardBData),
    .src2_i(ID_EX_immediate),
    .mux_o(MUXResult)
);


ALU_Control ALU_Control(
    .funct7_i(ID_EX_func7),
    .funct3_i(ID_EX_func3),
    .ALUOp_i(ID_EX_ALUOp),
    .op_o(operation)
);


ALU ALU(
    .op_i(operation),
    .src1_i(ForwardAData),
    .src2_i(MUXResult),
    .data_o(ALUResult),
    .zero_o(zero)
);


Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_i(EX_MEM_ALUResult),
    .MemRead_i(EX_MEM_MemRead),
    .MemWrite_i(EX_MEM_MemWrite),
    .data_i(EX_MEM_RS2data),
    .data_o(MemData)
);


MUX32 MUX2(
    .sel(MEM_WB_MemtoReg),
    .src1_i(MEM_WB_ALUResult),
    .src2_i(MEM_WB_MemData),
    .mux_o(RDdata)
);

endmodule

