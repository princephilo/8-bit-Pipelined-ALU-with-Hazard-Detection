// datapath.v
// Combines regfile + ALU. write_data_sel chooses what gets written back:
//   0 = ALU result (normal operation)
//   1 = external test_value (only used for seeding registers in testing)

module datapath (
    input  wire        clk,
    input  wire        write_enable,
    input  wire        write_data_sel,
    input  wire [7:0]  test_value,
    input  wire [2:0]  write_addr,
    input  wire [2:0]  read_addr_a,
    input  wire [2:0]  read_addr_b,
    input  wire [2:0]  op,
    output wire [7:0]  result
);

    wire [7:0] operand_a, operand_b;
    wire [7:0] write_data;

    assign write_data = write_data_sel ? test_value : result;

    regfile rf (
        .clk(clk),
        .write_enable(write_enable),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_addr_a(read_addr_a),
        .read_addr_b(read_addr_b),
        .read_data_a(operand_a),
        .read_data_b(operand_b)
    );

    alu my_alu (
        .a(operand_a),
        .b(operand_b),
        .op(op),
        .result(result)
    );

endmodule
