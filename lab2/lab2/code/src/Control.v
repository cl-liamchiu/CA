module Control
(
    NoOp_i,
    opcode_i, 
    ALUOp_o, 
    ALUSrc_o,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    Branch_o
);

input NoOp_i;
input [6:0] opcode_i;
output reg [1:0] ALUOp_o; 
output reg ALUSrc_o;
output reg RegWrite_o;
output reg MemtoReg_o;
output reg MemRead_o;
output reg MemWrite_o;
output reg Branch_o;

always @(*) begin
    if (NoOp_i) begin
        ALUOp_o = 2'b00;
        ALUSrc_o = 1'b0;
        RegWrite_o = 1'b0;
        MemtoReg_o = 1'b0;
        MemRead_o = 1'b0;
        MemWrite_o = 1'b0;
        Branch_o = 1'b0;
    end
    else
    case (opcode_i)
        7'b0010011: begin // I-type
            ALUOp_o = 2'b00;
            ALUSrc_o = 1'b1; // read imm
            RegWrite_o = 1'b1;
            MemtoReg_o = 1'b0;
            MemRead_o = 1'b0;
            MemWrite_o = 1'b0;
            Branch_o = 1'b0;
        end

        7'b0110011: begin // R-type
            ALUOp_o = 2'b01;
            ALUSrc_o = 1'b0; // read rs2
            RegWrite_o = 1'b1;
            MemtoReg_o = 1'b0;
            MemRead_o = 1'b0;
            MemWrite_o = 1'b0;
            Branch_o = 1'b0;       
        end

        7'b0000011: begin // lw
            ALUOp_o = 2'b10;
            ALUSrc_o = 1'b1; // read imm
            RegWrite_o = 1'b1;
            MemtoReg_o = 1'b1;
            MemRead_o = 1'b1;
            MemWrite_o = 1'b0;
            Branch_o = 1'b0;
        end

        7'b0100011: begin // sw
            ALUOp_o = 2'b10;
            ALUSrc_o = 1'b1; // read imm
            RegWrite_o = 1'b0;
            MemtoReg_o = 1'b0;
            MemRead_o = 1'b0;
            MemWrite_o = 1'b1;  
            Branch_o = 1'b0;
        end

        7'b1100011: begin // beq
            ALUOp_o = 2'b11;
            ALUSrc_o = 1'b0; // read rs2
            RegWrite_o = 1'b0;
            MemtoReg_o = 1'b0;
            MemRead_o = 1'b0;
            MemWrite_o = 1'b0;
            Branch_o = 1'b1;
        end

        default: begin
            ALUOp_o = 2'b00;
            ALUSrc_o = 1'b0;
            RegWrite_o = 1'b0;
            MemtoReg_o = 1'b0;
            MemRead_o = 1'b0;
            MemWrite_o = 1'b0;
            Branch_o = 1'b0;
        end
    endcase
    
end

endmodule