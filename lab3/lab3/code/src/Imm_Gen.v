module Imm_Gen
(
    instr_i,
    imm_o
);

input [31:0] instr_i;
output [31:0] imm_o;

reg [31:0] imm_o;

always @(*) begin
    case (instr_i[6:0]) // opcode
        7'b0100011: imm_o = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]}; // sw
        7'b1100011: imm_o = {{20{instr_i[31]}}, instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8]}; // beq
        default: imm_o = {{20{instr_i[31]}}, instr_i[31:20]};
    endcase

end

endmodule