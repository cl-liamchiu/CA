module ALU(
    input [2:0] ALU_control,
    input signed [31:0] rs1,
    input signed [31:0] rs2,
    output [31:0] ALU_result
);

    reg [31:0] tmp_result;
    always @(*) begin
        case(ALU_control)
            3'b000: tmp_result = rs1 & rs2;
            3'b001: tmp_result = rs1 ^ rs2;
            3'b010: tmp_result = rs1 << rs2[4:0];
            3'b011: tmp_result = rs1 + rs2;
            3'b100: tmp_result = rs1 - rs2;
            3'b101: tmp_result = rs1 * rs2;
            3'b110: tmp_result = rs1 + rs2;
            3'b111: tmp_result = rs1 >>> rs2[4:0];
        endcase
    end

    assign ALU_result = tmp_result;

endmodule