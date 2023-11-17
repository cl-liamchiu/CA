module Hazard_Detection_Unit
(
    rst_i,
    clk_i,
    RS1addr_i,
    RS2addr_i,
    ID_EX_RDaddr_i,
    ID_EX_MemRead_i,
    NoOp_o,
    Stall_o,
    PCWrite_o,
);

input rst_i;
input clk_i;
input [4:0] RS1addr_i;
input [4:0] RS2addr_i;
input [4:0] ID_EX_RDaddr_i;
input ID_EX_MemRead_i;
output NoOp_o;
output Stall_o;
output PCWrite_o;

reg NoOp_o;
reg Stall_o;
reg PCWrite_o;

always @(*) begin
    if (~rst_i) begin
        NoOp_o = 1'b0;
        Stall_o = 1'b0;
        PCWrite_o = 1'b1;
    end
    else
    if (ID_EX_MemRead_i && ((RS1addr_i == ID_EX_RDaddr_i) || (RS2addr_i == ID_EX_RDaddr_i))) begin
        NoOp_o = 1'b1;
        Stall_o = 1'b1;
        PCWrite_o = 1'b0;
    end
    else begin
        NoOp_o = 1'b0;
        Stall_o = 1'b0;
        PCWrite_o = 1'b1;
    end
end

endmodule