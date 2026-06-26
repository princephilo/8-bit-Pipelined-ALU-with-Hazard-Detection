// regfile_tb.v
`timescale 1ns/1ps

module regfile_tb;

    reg clk;
    reg write_enable;
    reg [2:0] write_addr;
    reg [7:0] write_data;
    reg [2:0] read_addr_a, read_addr_b;
    wire [7:0] read_data_a, read_data_b;

    regfile uut (
        .clk(clk),
        .write_enable(write_enable),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_addr_a(read_addr_a),
        .read_addr_b(read_addr_b),
        .read_data_a(read_data_a),
        .read_data_b(read_data_b)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("---- Register File Test ----");

        write_enable = 0;
        read_addr_a = 0; read_addr_b = 0;

        @(negedge clk);
        write_enable = 1;
        write_addr = 3;
        write_data = 8'd42;

        @(negedge clk);
        write_enable = 0;
        read_addr_a = 3;
        #1;
        $display("Wrote 42 to R3. Reading R3 = %0d (expect 42)", read_data_a);

        @(negedge clk);
        write_enable = 1;
        write_addr = 5;
        write_data = 8'd99;

        @(negedge clk);
        write_enable = 0;
        read_addr_a = 3;
        read_addr_b = 5;
        #1;
        $display("R3 = %0d (expect 42), R5 = %0d (expect 99)", read_data_a, read_data_b);

        $finish;
    end

endmodule
