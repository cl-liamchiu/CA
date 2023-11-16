module MUX32
(
    sel,
    src1_i,
    src2_i,
    mux_o
);

input sel;
input [31:0] src1_i;
input [31:0] src2_i;
output [31:0] mux_o;

assign mux_o = sel ? src2_i : src1_i;

endmodule