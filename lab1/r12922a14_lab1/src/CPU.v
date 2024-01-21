module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;

wire [31:0] pc_i, pc_o, instruction, RDdata, RS1data, RS2data, imm, ALU_src;
wire RegWrite, ALUSrc;
wire [2:0] ALU_control;
wire [1:0] ALUOp;

Control Control(
    .opcode(instruction[6:0]),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite)
);

Adder Add_PC(
    .input1(pc_o),
    .input2('d4),
    .out(pc_i)
);

PC PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pc_i(pc_i),
    .pc_o(pc_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i(pc_o), 
    .instr_o(instruction)
);

Registers Registers(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .RS1addr_i(instruction[19:15]),
    .RS2addr_i(instruction[24:20]),
    .RDaddr_i(instruction[11:7]), 
    .RDdata_i(RDdata),
    .RegWrite_i(RegWrite), 
    .RS1data_o(RS1data), 
    .RS2data_o(RS2data)
);

MUX32 MUX_ALUSrc(
    .sel(ALUSrc),
    .input1(RS2data),
    .input2(imm),
    .out(ALU_src)
);

Sign_Extend Sign_Extend(
    .imm_i(instruction[31:20]),
    .imm_o(imm)
);
  
ALU ALU(
    .ALU_control(ALU_control),
    .rs1(RS1data),
    .rs2(ALU_src),
    .ALU_result(RDdata)
);

ALU_Control ALU_Control(
    .funct7(instruction[31:25]),
    .funct3(instruction[14:12]),
    .ALUOp(ALUOp),
    .ALU_control(ALU_control)
);

endmodule

