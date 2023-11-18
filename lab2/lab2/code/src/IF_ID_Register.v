module IF_ID_Register
(
    clk_i,
    rst_i,
    ID_FlushIF_i,
    Stall_i,
    instr_i,
    PC_i,
    instr_o,
    PC_o
);

input clk_i;
input rst_i;
input ID_FlushIF_i;
input Stall_i;
input [31:0] instr_i;
input [31:0] PC_i;
output [31:0] instr_o;
output [31:0] PC_o;

reg [31:0] instr_o;
reg [31:0] PC_o;

always @(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        instr_o <= 0;
        PC_o <= 0;
    end
    else if (ID_FlushIF_i) begin
        instr_o <= 0;
        PC_o <= 0;
    end
    else if (Stall_i) begin
    end
    else begin
        instr_o <= instr_i;
        PC_o <= PC_i;
    end
end


endmodule