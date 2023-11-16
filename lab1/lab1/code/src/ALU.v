module ALU
(
    op_i,
    src1_i,
    src2_i,
    ALUResult_o
);

input [2:0] op_i;
input [31:0] src1_i;
input [31:0] src2_i;
output [31:0] ALUResult_o;

reg [31:0] tmpResult;

always @(*) begin
    case(op_i)
        3'b000: tmpResult = src1_i & src2_i;
        3'b001: tmpResult = src1_i ^ src2_i;
        3'b010: tmpResult = src1_i << src2_i[4:0];
        3'b011: tmpResult = src1_i + src2_i;
        3'b100: tmpResult = src1_i - src2_i;
        3'b101: tmpResult = src1_i * src2_i;
        3'b110: tmpResult = src1_i + src2_i;
        3'b111: tmpResult = src1_i >>> src2_i[4:0];
    endcase
end

assign ALUResult_o = tmpResult;

endmodule