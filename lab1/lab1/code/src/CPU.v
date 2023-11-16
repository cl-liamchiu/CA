module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;

// 程式計數器（Program Counter）的輸入和輸出
wire [31:0] pc_i, pc_o;

// instruction
wire [31:0] instr;

// 控制訊號
wire [1:0] ALUOp;
wire ALUSrc, RegWrite;

// 寫入 Register 的資料和從 Register 讀取的資料
wire [31:0] RDdata, RS1data, RS2data;

// instruction 裡的常數值
wire [31:0] immediate;

// MUX 的輸出（等於 RS2data 或 immediate）
wire [31:0] MUXResult;

// ALU 的運算符號
wire [2:0] operation;


PC PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pc_i(pc_i),
    .pc_o(pc_o)
);


// 使用 Adder 模塊實現 Program Counter 的增加
Adder Add(
    .src1_i(pc_o), // 目前的 Program Counter 值
    .src2_i(3'd4), // 常數 4，表示每次增加 4
    .adder_o(pc_i)   // 增加後的 Program Counter 值
);


Instruction_Memory Instruction_Memory(
    .addr_i(pc_o), 
    .instr_o(instr)
);


Control Control(
    .opcode_i(instr[6:0]),
    .ALUOp_o(ALUOp),
    .ALUSrc_o(ALUSrc),
    .RegWrite_o(RegWrite)
);


Registers Registers(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .RS1addr_i(instr[19:15]),
    .RS2addr_i(instr[24:20]),
    .RDaddr_i(instr[11:7]), 
    .RDdata_i(RDdata),
    .RegWrite_i(RegWrite), 
    .RS1data_o(RS1data), 
    .RS2data_o(RS2data)
);


Sign_Extend Sign_Extend(
    .imm_i(instr[31:20]),
    .imm_o(immediate)
);


MUX32 MUX(
    .sel(ALUSrc),
    .src1_i(RS2data),
    .src2_i(immediate),
    .mux_o(MUXResult)
);


ALU_Control ALU_Control(
    .funct7_i(instr[31:25]),
    .funct3_i(instr[14:12]),
    .ALUOp_i(ALUOp),
    .op_o(operation)
);


ALU ALU(
    .op_i(operation),
    .src1_i(RS1data),
    .src2_i(MUXResult),
    .ALUResult_o(RDdata)
);

endmodule

