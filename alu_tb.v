// alu_tb.v
`timescale 1ns/1ps

module alu_tb;

    reg  [7:0] a, b;
    reg  [2:0] op;
    wire [7:0] result;

    alu uut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );

    initial begin
        $display("op    a    b    result");

        a = 8'd10; b = 8'd5; op = 3'b000; #5;
        $display("ADD  %0d   %0d    %0d  (expect 15)", a, b, result);

        a = 8'd10; b = 8'd5; op = 3'b001; #5;
        $display("SUB  %0d   %0d    %0d  (expect 5)", a, b, result);

        a = 8'b1100; b = 8'b1010; op = 3'b010; #5;
        $display("AND  %0b %0b %0b  (expect 1000)", a, b, result);

        a = 8'b1100; b = 8'b1010; op = 3'b011; #5;
        $display("OR   %0b %0b %0b  (expect 1110)", a, b, result);

        a = 8'b1100; b = 8'b1010; op = 3'b100; #5;
        $display("XOR  %0b %0b %0b  (expect 0110)", a, b, result);

        $finish;
    end

endmodule
