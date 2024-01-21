module MUX32(
    input sel,
    input [31:0] input1,
    input [31:0] input2,
    output [31:0] out
);

    assign out = sel ? input2 : input1;
endmodule