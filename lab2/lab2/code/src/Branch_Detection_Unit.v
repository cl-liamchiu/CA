module Branch_Detection_Unit
(
    src1_i,
    src2_i,
    Branch_i,
    is_equal_o,
    flush_o
);

input [31:0] src1_i;
input [31:0] src2_i;
input Branch_i;
output is_equal_o;
output flush_o;

reg is_equal_o;
reg flush_o;

always @(*) begin
    if (src1_i == src2_i) begin
        is_equal_o = 1'b1;
    end
    else begin
        is_equal_o = 1'b0;
    end
    flush_o = Branch_i & is_equal_o;
end

endmodule