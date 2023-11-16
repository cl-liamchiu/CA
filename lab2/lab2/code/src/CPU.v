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

// Pipeline registers
reg [31:0] IF_ID_instr; // instruction

// control signals
reg ID_EX_RegWrite;
reg ID_EX_MemtoReg;
reg ID_EX_MemRead;
reg ID_EX_MemWrite;
reg [1:0] ID_EX_ALUOp;
reg ID_EX_ALUSrc;

reg [31:0] ID_EX_RS1data;
reg [31:0] ID_EX_RS2data;

reg [31:0] ID_EX_immediate;

// for ALU Control
reg [6:0] ID_EX_func7;
reg [2:0] ID_EX_func3;

// for registers when writing back
reg [4:0] ID_EX_RS1addr;
reg [4:0] ID_EX_RS2addr;
reg [4:0] ID_EX_RDaddr;

reg EX_MEM_RegWrite;
reg EX_MEM_MemtoReg;
reg EX_MEM_MemRead;
reg EX_MEM_MemWrite;

reg [31:0] EX_MEM_ALUResult;
reg [31:0] EX_MEM_RS2data;
reg [4:0] EX_MEM_RDaddr;

reg MEM_WB_RegWrite;
reg MEM_WB_MemtoReg;

reg [31:0] MEM_WB_ALUResult;
reg [31:0] MEM_WB_MemData;
reg [4:0] MEM_WB_RDaddr;

always @(posedge clk_i) begin
    IF_ID_instr <= instr;

    ID_EX_RegWrite <= RegWrite;
    ID_EX_MemtoReg <= MemtoReg;
    ID_EX_MemRead <= MemRead;
    ID_EX_MemWrite <= MemWrite;
    ID_EX_ALUOp <= ALUOp;
    ID_EX_ALUSrc <= ALUSrc;
    ID_EX_RS1data <= RS1data;
    ID_EX_RS2data <= RS2data;
    ID_EX_immediate <= immediate;
    ID_EX_func7 <= IF_ID_instr[31:25];
    ID_EX_func3 <= IF_ID_instr[14:12];
    ID_EX_RS1addr <= IF_ID_instr[19:15];
    ID_EX_RS2addr <= IF_ID_instr[24:20];
    ID_EX_RDaddr <= IF_ID_instr[11:7];

    EX_MEM_RegWrite <= ID_EX_RegWrite;
    EX_MEM_MemtoReg <= ID_EX_MemtoReg;
    EX_MEM_MemRead <= ID_EX_MemRead;
    EX_MEM_MemWrite <= ID_EX_MemWrite;
    EX_MEM_ALUResult <= ALUResult;
    EX_MEM_RS2data <= ID_EX_RS2data;
    EX_MEM_RDaddr <= ID_EX_RDaddr;

    MEM_WB_RegWrite <= EX_MEM_RegWrite;
    MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
    MEM_WB_ALUResult <= EX_MEM_ALUResult;
    MEM_WB_MemData <= MemData;
    MEM_WB_RDaddr <= EX_MEM_RDaddr;
    
end
  

PC PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pc_i(pc_i),
    .pc_o(pc_o)
);


Adder Add(
    .src1_i(pc_o), 
    .src2_i('d4), 
    .adder_o(pc_i)
);


Instruction_Memory Instruction_Memory(
    .addr_i(pc_o), 
    .instr_o(instr)
);


Control Control(
    .opcode_i(IF_ID_instr[6:0]),
    .ALUOp_o(ALUOp),
    .ALUSrc_o(ALUSrc),
    .RegWrite_o(RegWrite),
    .MemtoReg_o(MemtoReg),
    .MemRead_o(MemRead),
    .MemWrite_o(MemWrite)
);


Registers Registers(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .RS1addr_i(IF_ID_instr[19:15]),
    .RS2addr_i(IF_ID_instr[24:20]),
    .RDaddr_i(IF_ID_instr[11:7]), 
    .RDdata_i(RDdata),
    .RegWrite_i(MEM_WB_RegWrite), 
    .RS1data_o(RS1data), 
    .RS2data_o(RS2data)
);


Imm_Gen Imm_Gen(
    .imm_i(IF_ID_instr),
    .imm_o(immediate)
);


Forwarding_Unit Forwarding_Unit(
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
    .src3_i(MEM_WB_ALUResult),
    .mux_o(ForwardAData)
);


MUX32_Forwarding MUX32_ForwardB(
    .sel(ForwardB),
    .src1_i(ID_EX_RS2data),
    .src2_i(RDdata),
    .src3_i(MEM_WB_ALUResult),
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
    .ALUResult_o(ALUResult)
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

