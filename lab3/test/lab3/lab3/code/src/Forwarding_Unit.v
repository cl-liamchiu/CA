module Forwarding_Unit
(
    ID_EX_RS1addr_i,
    ID_EX_RS2addr_i,
    EX_MEM_RegWrite_i,
    EX_MEM_RDaddr_i,
    MEM_WB_RegWrite_i,
    MEM_WB_RDaddr_i,
    ForwardA_o,
    ForwardB_o
);

input [4:0] ID_EX_RS1addr_i;
input [4:0] ID_EX_RS2addr_i;
input EX_MEM_RegWrite_i;
input [4:0] EX_MEM_RDaddr_i;
input MEM_WB_RegWrite_i;
input [4:0] MEM_WB_RDaddr_i;
output [1:0] ForwardA_o;
output [1:0] ForwardB_o;

reg [1:0] ForwardA_o;
reg [1:0] ForwardB_o;

always @(*) begin
    if (EX_MEM_RegWrite_i 
        && (EX_MEM_RDaddr_i != 0) 
        && (EX_MEM_RDaddr_i == ID_EX_RS1addr_i)) begin
        ForwardA_o = 2'b10;
    end
    else if (MEM_WB_RegWrite_i
            && (MEM_WB_RDaddr_i != 0) 
            && !(EX_MEM_RegWrite_i && (EX_MEM_RDaddr_i != 0) 
                && (EX_MEM_RDaddr_i == ID_EX_RS1addr_i)) 
            &&(MEM_WB_RDaddr_i == ID_EX_RS1addr_i)) begin 
        ForwardA_o = 2'b01;
    end
    else begin 
        ForwardA_o = 2'b00;
    end

    if (EX_MEM_RegWrite_i 
        && (EX_MEM_RDaddr_i != 0) 
        && (EX_MEM_RDaddr_i == ID_EX_RS2addr_i)) begin
        ForwardB_o = 2'b10;
    end
    else if (MEM_WB_RegWrite_i 
            && (MEM_WB_RDaddr_i != 0) 
            && !(EX_MEM_RegWrite_i && (EX_MEM_RDaddr_i != 0) 
                && (EX_MEM_RDaddr_i == ID_EX_RS2addr_i)) 
            &&(MEM_WB_RDaddr_i == ID_EX_RS2addr_i)) begin 
        ForwardB_o = 2'b01;
    end
    else begin
        ForwardB_o = 2'b00;
    end
end

endmodule