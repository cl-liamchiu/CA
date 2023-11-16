module Imm_Gen
(
    imm_i,
    imm_o
);

input [31:0] imm_i;
output [31:0] imm_o;

reg [31:0] imm_o;

always @(*) begin
    case (imm_i[6:0]) // opcode
        7'b0100011: imm_o = {{20{imm_i[31]}}, imm_i[31:25], imm_i[11:7]}; // sw
        7'b1100011: imm_o = {{20{imm_i[31]}}, imm_i[31], imm_i[7], imm_i[30:25], imm_i[11:8]}; // beq
        default: imm_o = {{20{imm_i[31]}}, imm_i[31:20]};
    endcase

end

endmodule