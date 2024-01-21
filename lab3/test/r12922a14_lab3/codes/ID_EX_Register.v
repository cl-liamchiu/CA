module ID_EX_Register
(   
    flush_i,
    taken_i,
    Branch_i,
    BranchAddr_i,
    PCAddr_i,
    clk_i,
    rst_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    RS1data_i,
    RS2data_i,
    immediate_i,
    func7_i,
    func3_i,
    RS1addr_i,
    RS2addr_i,
    RDaddr_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    RS1data_o,
    RS2data_o,
    immediate_o,
    func7_o,
    func3_o,
    RS1addr_o,
    RS2addr_o,
    RDaddr_o,
    taken_o,
    Branch_o,
    BranchAddr_o,
    PCAddr_o,
);

input flush_i;
input taken_i;
input Branch_i;
input [31:0] BranchAddr_i;
input [31:0] PCAddr_i;
input clk_i;
input rst_i;
input RegWrite_i;
input MemtoReg_i;
input MemRead_i;
input MemWrite_i;
input [1:0] ALUOp_i;
input ALUSrc_i;
input [31:0] RS1data_i;
input [31:0] RS2data_i;
input [31:0] immediate_i;
input [6:0] func7_i;
input [2:0] func3_i;
input [4:0] RS1addr_i;
input [4:0] RS2addr_i;
input [4:0] RDaddr_i;
output RegWrite_o;
output MemtoReg_o;
output MemRead_o;
output MemWrite_o;
output [1:0] ALUOp_o;
output ALUSrc_o;
output [31:0] RS1data_o;
output [31:0] RS2data_o;
output [31:0] immediate_o;
output [6:0] func7_o;
output [2:0] func3_o;
output [4:0] RS1addr_o;
output [4:0] RS2addr_o;
output [4:0] RDaddr_o;
output taken_o;
output Branch_o;
output [31:0] BranchAddr_o;
output [31:0] PCAddr_o;

reg RegWrite_o;
reg MemtoReg_o;
reg MemRead_o;
reg MemWrite_o;
reg [1:0] ALUOp_o;
reg ALUSrc_o;
reg [31:0] RS1data_o;
reg [31:0] RS2data_o;
reg [31:0] immediate_o;
reg [6:0] func7_o;
reg [2:0] func3_o;
reg [4:0] RS1addr_o;
reg [4:0] RS2addr_o;
reg [4:0] RDaddr_o;
reg taken_o;
reg Branch_o;
reg [31:0] BranchAddr_o;
reg [31:0] PCAddr_o;

always @(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        RegWrite_o <= 0;
        MemtoReg_o <= 0;
        MemRead_o <= 0;
        MemWrite_o <= 0;
        ALUOp_o <= 0;
        ALUSrc_o <= 0;
        RS1data_o <= 0;
        RS2data_o <= 0;
        immediate_o <= 0;
        func7_o <= 0;
        func3_o <= 0;
        RS1addr_o <= 0;
        RS2addr_o <= 0;
        RDaddr_o <= 0;
        taken_o <= 0;
        Branch_o <= 0;
        BranchAddr_o <= 0;
        PCAddr_o <= 0;

    end
    else if (flush_i) begin
        RegWrite_o <= 0;
        MemtoReg_o <= 0;
        MemRead_o <= 0;
        MemWrite_o <= 0;
        ALUOp_o <= 0;
        ALUSrc_o <= 0;
        RS1data_o <= 0;
        RS2data_o <= 0;
        immediate_o <= 0;
        func7_o <= 0;
        func3_o <= 0;
        RS1addr_o <= 0;
        RS2addr_o <= 0;
        RDaddr_o <= 0;
        taken_o <= 0;
        Branch_o <= 0;
        BranchAddr_o <= 0;
        PCAddr_o <= 0;
        
    end
    else begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALUOp_o <= ALUOp_i;
        ALUSrc_o <= ALUSrc_i;
        RS1data_o <= RS1data_i;
        RS2data_o <= RS2data_i;
        immediate_o <= immediate_i;
        func7_o <= func7_i;
        func3_o <= func3_i;
        RS1addr_o <= RS1addr_i;
        RS2addr_o <= RS2addr_i;
        RDaddr_o <= RDaddr_i;
        taken_o <= taken_i;
        Branch_o <= Branch_i;
        BranchAddr_o <= BranchAddr_i;
        PCAddr_o <= PCAddr_i;
        
    end
end

endmodule