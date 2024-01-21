`timescale 1ns/1ps

module ALU_tb;

    // Parameters
    parameter PERIOD = 10;

    // Inputs
    reg [2:0] ALU_control;
    reg [31:0] rs1, rs2;

    // Outputs
    wire [31:0] ALU_result;

    // Instantiate the ALU module
    ALU my_ALU (
        .ALU_control(ALU_control),
        .rs1(rs1),
        .rs2(rs2),
        .ALU_result(ALU_result)
    );

    // Clock generation
    reg clk = 0;

    always #((PERIOD)/2) clk = ~clk;

    // Stimulus
    initial begin
        // Test case 1
        ALU_control = 3'b111;
        rs1 = 32'b00000000_00000000_00000010_00000000;
        rs2 = 32'b00000000_00000000_00000000_00000010;
        #PERIOD;
        $display("Test Case 1: ALU_result = %b", ALU_result);

        // Test case 2
        ALU_control = 3'b111;
        rs1 = 32'b11111111_11111111_11111110_00000000;
        rs2 = 32'b00000000_00000000_00000000_00000010;
        #PERIOD;
        $display("Test Case 2: ALU_result = %b", ALU_result);

        // Add more test cases as needed

        // End simulation
        $finish;
    end

endmodule
