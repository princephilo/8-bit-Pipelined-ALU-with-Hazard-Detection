// pipelined_datapath.v
// 3-stage pipeline with forwarding to resolve RAW hazards

module pipelined_datapath (
    input  wire        clk,
    input  wire        d_write_data_sel,
    input  wire [7:0]  d_test_value,
    input  wire        d_write_enable,
    input  wire [2:0]  d_write_addr,
    input  wire [2:0]  read_addr_a,
    input  wire [2:0]  read_addr_b,
    input  wire [2:0]  op,
    output wire [7:0]  w_result
);

    // W-stage signals declared up front (regfile instantiation below needs them)
    reg [7:0] w_result_reg;
    reg       w_write_enable;
    reg [2:0] w_write_addr;
    reg       w_write_data_sel;
    reg [7:0] w_test_value;
    wire [7:0] w_write_data;

    // ---------- D stage: read operands from regfile ----------
    wire [7:0] d_operand_a, d_operand_b;

    regfile rf (
        .clk(clk),
        .write_enable(w_write_enable),
        .write_addr(w_write_addr),
        .write_data(w_write_data),
        .read_addr_a(read_addr_a),
        .read_addr_b(read_addr_b),
        .read_data_a(d_operand_a),
        .read_data_b(d_operand_b)
    );

    // ---------- D -> E pipeline register ----------
    reg [7:0] e_operand_a, e_operand_b;
    reg [2:0] e_op;
    reg       e_write_enable;
    reg [2:0] e_write_addr;
    reg       e_write_data_sel;
    reg [7:0] e_test_value;
    reg [2:0] e_read_addr_a, e_read_addr_b;  // carried so forwarding can compare addresses

    always @(posedge clk) begin
        e_operand_a      <= d_operand_a;
        e_operand_b      <= d_operand_b;
        e_op             <= op;
        e_write_enable   <= d_write_enable;
        e_write_addr     <= d_write_addr;
        e_write_data_sel <= d_write_data_sel;
        e_test_value     <= d_test_value;
        e_read_addr_a    <= read_addr_a;
        e_read_addr_b    <= read_addr_b;
    end

    // ---------- E stage: forwarding muxes + ALU ----------
    // Forward if: an instruction ahead is writing to the same register we're reading.
    // Priority: E-stage forward (more recent) beats W-stage forward.

    wire [7:0] e_result;  // declared early, needed by forwarding logic below

    wire fwd_a_from_w = (w_write_enable && !w_write_data_sel &&
                         w_write_addr == e_read_addr_a);
    wire fwd_a_from_e = 1'b0;  // E->E same-cycle forwarding not needed in 3-stage

    wire fwd_b_from_w = (w_write_enable && !w_write_data_sel &&
                         w_write_addr == e_read_addr_b);

    wire [7:0] alu_in_a = fwd_a_from_w ? w_result_reg : e_operand_a;
    wire [7:0] alu_in_b = fwd_b_from_w ? w_result_reg : e_operand_b;

    alu my_alu (
        .a(alu_in_a),
        .b(alu_in_b),
        .op(e_op),
        .result(e_result)
    );

    // ---------- E -> W pipeline register ----------
    always @(posedge clk) begin
        w_result_reg     <= e_result;
        w_write_enable   <= e_write_enable;
        w_write_addr     <= e_write_addr;
        w_write_data_sel <= e_write_data_sel;
        w_test_value     <= e_test_value;
    end

    // ---------- W stage: write back ----------
    assign w_write_data = w_write_data_sel ? w_test_value : w_result_reg;
    assign w_result = w_result_reg;

    // Debug
    always @(posedge clk) begin
        if (w_write_enable && !w_write_data_sel)
            $display("    [WRITE] R%0d = %0d", w_write_addr, w_write_data);
    end

endmodule
