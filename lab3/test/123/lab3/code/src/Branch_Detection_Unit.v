module Branch_Detection_Unit
(   
    predict_i,
    Branch_i,
    flush_o
);


input predict_i;
input Branch_i;
output flush_o;

reg flush_o;

always @(*) begin
    flush_o = Branch_i & predict_i;
end

endmodule