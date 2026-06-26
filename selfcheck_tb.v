`timescale 1ns/1ps

module selfcheck_tb;

    reg clk;
    reg d_write_data_sel;
    reg [7:0] d_test_value;
    reg d_write_enable;
    reg [2:0] d_write_addr;
    reg [2:0] read_addr_a, read_addr_b;
    reg [2:0] op;
    wire [7:0] w_result;

    integer pass_count;
    integer fail_count;

    task check;
        input [7:0] actual;
        input [7:0] expected;
        input [63:0] test_id;
        begin
            if (actual === expected) begin
                $display("  PASS [test %0d]: got %0d", test_id, actual);
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL [test %0d]: got %0d, expected %0d", test_id, actual, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

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

    task seed_reg;
        input [2:0] addr;
        input [7:0] val;
        begin
            @(negedge clk);
            d_write_enable   = 1;
            d_write_data_sel = 1;
            d_write_addr     = addr;
            d_test_value     = val;
        end
    endtask

    task issue_instr;
        input [2:0] ra;
        input [2:0] rb;
        input [2:0] operation;
        input [2:0] dst;
        begin
            @(negedge clk);
            read_addr_a      = ra;
            read_addr_b      = rb;
            op               = operation;
            d_write_enable   = 1;
            d_write_addr     = dst;
            d_write_data_sel = 0;
        end
    endtask

    initial begin
        // ---- VCD dump: these two lines enable waveform capture ----
        $dumpfile("waves.vcd");
        $dumpvars(0, selfcheck_tb);
        // -----------------------------------------------------------

        $display("========= Self-Checking Testbench =========");
        pass_count = 0;
        fail_count = 0;

        d_write_enable = 0;
        d_write_data_sel = 1;
        read_addr_a = 0; read_addr_b = 0; op = 3'b000;

        seed_reg(0, 8'd0);
        seed_reg(1, 8'd10);
        seed_reg(2, 8'd5);
        seed_reg(3, 8'd20);
        seed_reg(4, 8'd255);

        @(negedge clk); d_write_enable = 0;
        @(negedge clk); @(negedge clk);

        $display("\n-- Test 1: ADD R1(10)+R2(5) -> R5 --");
        issue_instr(1, 2, 3'b000, 5);
        @(negedge clk); d_write_enable = 0;
        @(negedge clk); @(negedge clk);
        check(w_result, 8'd15, 1);

        $display("\n-- Test 2: SUB R3(20)-R2(5) -> R5 --");
        issue_instr(3, 2, 3'b001, 5);
        @(negedge clk); d_write_enable = 0;
        @(negedge clk); @(negedge clk);
        check(w_result, 8'd15, 2);

        $display("\n-- Test 3: AND R1(10) & R2(5) -> R5 --");
        issue_instr(1, 2, 3'b010, 5);
        @(negedge clk); d_write_enable = 0;
        @(negedge clk); @(negedge clk);
        check(w_result, 8'd0, 3);

        $display("\n-- Test 4: OR R1(10) | R2(5) -> R5 --");
        issue_instr(1, 2, 3'b011, 5);
        @(negedge clk); d_write_enable = 0;
        @(negedge clk); @(negedge clk);
        check(w_result, 8'd15, 4);

        $display("\n-- Test 5: XOR R1(10) ^ R2(5) -> R5 --");
        issue_instr(1, 2, 3'b100, 5);
        @(negedge clk); d_write_enable = 0;
        @(negedge clk); @(negedge clk);
        check(w_result, 8'd15, 5);

        $display("\n-- Test 6: RAW hazard -- ADD R1+R2->R6, then ADD R6+R0->R7 --");
        issue_instr(1, 2, 3'b000, 6);
        issue_instr(6, 0, 3'b000, 7);
        @(negedge clk); d_write_enable = 0;
        @(negedge clk); @(negedge clk); @(negedge clk);
        check(w_result, 8'd15, 6);

        $display("\n-- Test 7: ADD R4(255)+R2(5) -> R5, expect wrap to 4 --");
        issue_instr(4, 2, 3'b000, 5);
        @(negedge clk); d_write_enable = 0;
        @(negedge clk); @(negedge clk);
        check(w_result, 8'd4, 7);

        $display("\n========= Results: %0d passed, %0d failed =========",
                 pass_count, fail_count);
        if (fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED - check above");

        $finish;
    end

endmodule
