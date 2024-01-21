module branch_predictor
(
  clk_i,         
  rst_i,
  zero_i, 
  Branch_i,
  taken_i,
  PCAddr_i,
  BranchAddr_i,
  
  AddrResult_o,
  right_o,
  predict_o,
  flush_o,

  state_reg_i,
  state_reg_o
);

input clk_i;
input rst_i;
input zero_i;
input Branch_i;
input taken_i;
input [31:0] PCAddr_i;
input [31:0] BranchAddr_i;

output [31:0] AddrResult_o;
output right_o;
output predict_o;
output flush_o;

input [1:0] state_reg_i;
output [1:0] state_reg_o;

reg [31:0] AddrResult_o;
reg right_o;
reg flush_o;
reg [1:0] next_state;
reg predict_o;
reg [1:0] state_reg_o;

localparam STRONGLY_NOT_TAKEN = 2'b00;
localparam WEAKLY_NOT_TAKEN = 2'b01;
localparam WEAKLY_TAKEN = 2'b10;
localparam STRONGLY_TAKEN = 2'b11;


always @(*) begin
    if (~rst_i) begin
        next_state = STRONGLY_TAKEN;
        right_o = 1'b1;
        flush_o = 1'b0;
    end
    else begin
        if (Branch_i == 1'b1) begin
            case (state_reg_i)
                STRONGLY_NOT_TAKEN: begin
                    if ((zero_i == 0 && taken_i == 0) || (zero_i == 1 && taken_i == 1)) begin
                        next_state = STRONGLY_NOT_TAKEN;
                        right_o = 1'b1;
                        flush_o = 1'b0;
                    end
                    else begin
                        next_state = WEAKLY_NOT_TAKEN;
                        right_o = 1'b0;
                        flush_o = 1'b1;
                    end
                end
                WEAKLY_NOT_TAKEN: begin
                    if ((zero_i == 0 && taken_i == 0) || (zero_i == 1 && taken_i == 1)) begin
                        next_state = STRONGLY_NOT_TAKEN;
                        right_o = 1'b1;
                        flush_o = 1'b0;
                    end
                    else begin
                        next_state = WEAKLY_TAKEN;
                        right_o = 1'b0;
                        flush_o = 1'b1;
                    end
                end
                WEAKLY_TAKEN: begin
                    if ((zero_i == 0 && taken_i == 0) || (zero_i == 1 && taken_i == 1)) begin
                        next_state = STRONGLY_TAKEN;
                        right_o = 1'b1;
                        flush_o = 1'b0;
                    end
                    else begin
                        next_state = WEAKLY_NOT_TAKEN;
                        right_o = 1'b0;
                        flush_o = 1'b1;
                    end
                end
                STRONGLY_TAKEN: begin
                    if ((zero_i == 0 && taken_i == 0) || (zero_i == 1 && taken_i == 1)) begin
                        next_state = STRONGLY_TAKEN;
                        right_o = 1'b1;
                        flush_o = 1'b0;
                    end
                    else begin
                        next_state = WEAKLY_TAKEN;
                        right_o = 1'b0;
                        flush_o = 1'b1;
                    end
                end
                default: begin
                    next_state = STRONGLY_TAKEN;
                    right_o = 1'b1;
                    flush_o = 1'b0;
                end
            endcase
        end
        else begin
            next_state = state_reg_i;
            right_o = 1'b1;
            flush_o = 1'b0;
        end

        if (taken_i == 0) begin
            AddrResult_o = BranchAddr_i;
        end
        else begin
            AddrResult_o = PCAddr_i;
        end
    end
end

always @(posedge clk_i or negedge rst_i) begin
    predict_o <= (next_state == WEAKLY_TAKEN || next_state == STRONGLY_TAKEN);
    state_reg_o = next_state;
end


endmodule
