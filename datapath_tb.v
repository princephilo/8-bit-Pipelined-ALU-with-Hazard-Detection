// datapath_tb.v
// Seed R1=10, R2=5 directly, then run ALU ops reading them, writing result to R3.

`timescale 1ns/1ps

module datapath_tb;

    reg clk;
    reg write_enable;
    reg write_data_sel;
    reg [7:0] test_value;
    reg [2:0] write_addr;
    reg [2:0] read_addr_a, read_addr_b;
    reg [2:0] op;
    wire [7:0] result;

    datapath uut (
        .clk(clk),
        .write_enable(write_enable),
        .write_data_sel(write_data_sel),
        .test_value(test_value),
        .write_addr(write_addr),
        .read_addr_a(read_addr_a),
        .read_addr_b(read_addr_b),
        .op(op),
        .result(result)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("---- Datapath Test (ALU + Regfile combined) ----");

        write_enable = 0;
        write_data_sel = 1;
        read_addr_a = 0; read_addr_b = 0; op = 3'b000;

        @(negedge clk);
        write_enable = 1;
        write_addr = 0;
        test_value = 8'd0;

        @(negedge clk);
        write_addr = 1;
        test_value = 8'd10;

        @(negedge clk);
        write_addr = 2;
        test_value = 8'd5;

        @(negedge clk);
        write_enable = 0;
        write_data_sel = 0;

        read_addr_a = 1;
        read_addr_b = 2;
        op = 3'b000;
        #1;
        $display("ADD R1(10)+R2(5): result = %0d (expect 15)", result);

        @(negedge clk);
        write_enable = 1;
        write_addr = 3;

        @(negedge clk);
        write_enable = 0;
        read_addr_a = 3;
        read_addr_b = 0;
        op = 3'b000;
        #1;
        $display("R3 verified via ADD-with-zero = %0d (expect 15)", result);

        read_addr_a = 1;
        read_addr_b = 2;
        op = 3'b001;
        #1;
        $display("SUB R1(10)-R2(5): result = %0d (expect 5)", result);

        $finish;
    end

endmodule
