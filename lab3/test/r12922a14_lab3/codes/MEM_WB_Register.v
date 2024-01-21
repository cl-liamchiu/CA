module MEM_WB_Register
(
    clk_i,
    rst_i,
    RegWrite_i,
    MemtoReg_i,
    ALUResult_i,
    MemData_i,
    RDaddr_i,
    RegWrite_o,
    MemtoReg_o,
    ALUResult_o,
    MemData_o,
    RDaddr_o
);

input clk_i;
input rst_i;
input RegWrite_i;
input MemtoReg_i;
input [31:0] ALUResult_i;
input [31:0] MemData_i;
input [4:0] RDaddr_i;
output RegWrite_o;
output MemtoReg_o;
output [31:0] ALUResult_o;
output [31:0] MemData_o;
output [4:0] RDaddr_o;

reg RegWrite_o;
reg MemtoReg_o;
reg [31:0] ALUResult_o;
reg [31:0] MemData_o;
reg [4:0] RDaddr_o;

always @(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        RegWrite_o <= 0;
        MemtoReg_o <= 0;
        ALUResult_o <= 0;
        MemData_o <= 0;
        RDaddr_o <= 0;
    end
    else begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        ALUResult_o <= ALUResult_i;
        MemData_o <= MemData_i;
        RDaddr_o <= RDaddr_i;
    end
end

endmodule