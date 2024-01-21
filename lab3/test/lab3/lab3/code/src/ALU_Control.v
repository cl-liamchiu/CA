module ALU_Control
(
    funct7_i,
    funct3_i,
    ALUOp_i,
    op_o
);

input [31:25] funct7_i;
input [14:12] funct3_i;
input [1:0] ALUOp_i;
output reg [2:0] op_o;

localparam ALU_and = 3'b000;
localparam ALU_xor = 3'b001;
localparam ALU_sll = 3'b010;
localparam ALU_add = 3'b011;
localparam ALU_sub = 3'b100;
localparam ALU_mul = 3'b101;
localparam ALU_srai = 3'b111;

always @(*) begin
    case(ALUOp_i)
        2'b00: begin // I-type
        case(funct3_i)
            3'b000: op_o = ALU_add;
            3'b101: op_o = ALU_srai;
        endcase

        end

        2'b01: begin // R-type
        case(funct3_i)
            3'b111: op_o = ALU_and;
            3'b100: op_o = ALU_xor;
            3'b001: op_o = ALU_sll;
            3'b000: begin
                case(funct7_i)
                    7'b0000000: op_o = ALU_add;
                    7'b0100000: op_o = ALU_sub;
                    7'b0000001: op_o = ALU_mul;
                endcase
            end  
        endcase
        end

        2'b10: begin // lw sw
            op_o = ALU_add;
        end

        2'b11: begin // beq
            op_o = ALU_sub;
        end

    endcase
end
    
endmodule