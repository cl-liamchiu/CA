module Sign_Extend
(
    imm_i,
    imm_o
);

input [31:20] imm_i;
output [31:0] imm_o;

assign imm_o = {{20{imm_i[31]}}, imm_i};

endmodule