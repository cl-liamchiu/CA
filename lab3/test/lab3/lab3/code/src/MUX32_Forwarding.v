module MUX32_Forwarding
(
    sel,
    src1_i,
    src2_i,
    src3_i,
    mux_o
);

input [1:0] sel;
input [31:0] src1_i;
input [31:0] src2_i;
input [31:0] src3_i;
output [31:0] mux_o;

reg [31:0] mux_o;

always @(*) begin
    if (sel == 2'b00) begin
        mux_o = src1_i;
    end
    else if (sel == 2'b01) begin
        mux_o = src2_i;
    end
    else begin
        mux_o = src3_i;
    end
end

endmodule