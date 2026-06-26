// pipelined_datapath_tb.v
`timescale 1ns/1ps

module pipelined_datapath_tb;

    reg clk;
    reg d_write_data_sel;
    reg [7:0] d_test_value;
    reg d_write_enable;
    reg [2:0] d_write_addr;
    reg [2:0] read_addr_a, read_addr_b;
    reg [2:0] op;
    wire [7:0] w_result;

    pipelined_datapath uut (
        .clk(clk),
        .d_write_data_sel(d_write_data_sel),
        .d_test_value(d_test_value),
        .d_write_enable(d_write_enable),
        .d_write_addr(d_write_addr),
        .read_addr_a(read_addr_a),
        .read_addr_b(read_addr_b),
        .op(op),
        .w_result(w_result)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("---- Pipelined Datapath Test ----");

        d_write_data_sel = 1;
        d_write_enable = 0;
        read_addr_a = 0; read_addr_b = 0; op = 3'b000;

        @(negedge clk);
        d_write_enable = 1;
        d_write_addr = 0;
        d_test_value = 8'd0;

        @(negedge clk);
        d_write_addr = 1;
        d_test_value = 8'd10;

        @(negedge clk);
        d_write_addr = 2;
        d_test_value = 8'd5;

        @(negedge clk);
        d_write_enable = 0;

        @(negedge clk);
        @(negedge clk);
        d_write_data_sel = 0;

        @(negedge clk);
        read_addr_a = 1;
        read_addr_b = 2;
        op = 3'b000;
        d_write_enable = 1;
        d_write_addr = 3;
        $display("Cycle A (D): issuing ADD R1+R2 -> R3");

        @(negedge clk);
        d_write_enable = 0;
        $display("Cycle B (E): d_opA=%0d d_opB=%0d", uut.d_operand_a, uut.d_operand_b);

        @(negedge clk);
        $display("Cycle C (W): w_result = %0d (expect 15)", w_result);

        $finish;
    end

endmodule
