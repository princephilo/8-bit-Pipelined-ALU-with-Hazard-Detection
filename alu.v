// alu.v
// Pure combinational 8-bit ALU. No clock - output reacts instantly to inputs.

module alu (
    input  wire [7:0] a,        // operand A
    input  wire [7:0] b,        // operand B
    input  wire [2:0] op,       // operation select
    output reg  [7:0] result    // result (reg here because it's assigned in always block)
);

    localparam OP_ADD = 3'b000;
    localparam OP_SUB = 3'b001;
    localparam OP_AND = 3'b010;
    localparam OP_OR  = 3'b011;
    localparam OP_XOR = 3'b100;

    always @(*) begin
        case (op)
            OP_ADD: result = a + b;
            OP_SUB: result = a - b;
            OP_AND: result = a & b;
            OP_OR:  result = a | b;
            OP_XOR: result = a ^ b;
            default: result = 8'b0;
        endcase
    end

endmodule
