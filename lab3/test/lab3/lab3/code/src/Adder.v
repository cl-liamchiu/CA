module Adder
(
    src1_i,
    src2_i,
    adder_o
);

input [31:0] src1_i;
input [31:0] src2_i;
output [31:0] adder_o;

assign adder_o = src1_i + src2_i;

endmodule