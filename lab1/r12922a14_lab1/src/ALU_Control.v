module ALU_Control(
    input [31:25] funct7,
    input [14:12] funct3,
    input [1:0] ALUOp,
    output reg [2:0] ALU_control
    );
    localparam ALU_and = 3'b000;
    localparam ALU_xor = 3'b001;
    localparam ALU_sll = 3'b010;
    localparam ALU_add = 3'b011;
    localparam ALU_sub = 3'b100;
    localparam ALU_mul = 3'b101;
    localparam ALU_addi = 3'b110;
    localparam ALU_srai = 3'b111;

    always @(*) begin
        case(ALUOp)
            2'b00: begin // I-type
            case(funct3)
                3'b000: ALU_control = ALU_addi;
                3'b101: ALU_control = ALU_srai;
            endcase

            end
            2'b01: begin // R-type
            case(funct3)
                3'b111: ALU_control = ALU_and;
                3'b100: ALU_control = ALU_xor;
                3'b001: ALU_control = ALU_sll;
                3'b000: begin
                    case(funct7)
                        7'b0000000: ALU_control = ALU_add;
                        7'b0100000: ALU_control = ALU_sub;
                        7'b0000001: ALU_control = ALU_mul;
                    endcase
                end  
            endcase
            end
        endcase
    end
    
endmodule