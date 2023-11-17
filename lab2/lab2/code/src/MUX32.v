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

reg [31:0] mux_o;

always @(*) begin
    if (sel) begin
        mux_o = src2_i;        
    end
    else
        mux_o = src1_i;
end

endmodule