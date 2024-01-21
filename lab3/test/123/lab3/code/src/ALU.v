module ALU
(
    op_i,
    src1_i,
    src2_i,
    data_o,
    zero_o
);

input [2:0] op_i;
input signed [31:0] src1_i;
input signed [31:0] src2_i;
output [31:0] data_o;
output zero_o;

reg zero_o;
reg [31:0] tmpResult;

always @(*) begin
    case(op_i)
        3'b000: tmpResult = src1_i & src2_i;
        3'b001: tmpResult = src1_i ^ src2_i;
        3'b010: tmpResult = src1_i << src2_i[4:0];
        3'b011: tmpResult = src1_i + src2_i;
        3'b100: tmpResult = src1_i - src2_i;
        3'b101: tmpResult = src1_i * src2_i;
        3'b111: tmpResult = src1_i >>> src2_i[4:0];
    endcase

    if(tmpResult == 32'b0) begin
        zero_o = 1'b1;
    end else begin
        zero_o = 1'b0;
    end
end

assign data_o = tmpResult;

endmodule