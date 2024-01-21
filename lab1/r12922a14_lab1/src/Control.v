module Control(
    input [6:0] opcode, 
    output reg [1:0] ALUOp, 
    output reg ALUSrc,
    output reg RegWrite);

    always @(*) begin
        case (opcode)
            7'b0010011: begin // I-type
                ALUOp = 2'b00;
                ALUSrc = 1'b1; // read imm
                RegWrite = 1'b1;
            end
            7'b0110011: begin // R-type
                ALUOp = 2'b01;
                ALUSrc = 1'b0; // read rs2
                RegWrite = 1'b1;
            end
            default: begin
                ALUOp = 2'b00;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
            end
        endcase
        
    end

endmodule