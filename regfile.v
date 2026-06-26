// regfile.v
// 8 registers, 8 bits each. Synchronous write, asynchronous (instant) read.

module regfile (
    input  wire        clk,
    input  wire        write_enable,
    input  wire [2:0]  write_addr,
    input  wire [7:0]  write_data,
    input  wire [2:0]  read_addr_a,
    input  wire [2:0]  read_addr_b,
    output wire [7:0]  read_data_a,
    output wire [7:0]  read_data_b
);

    reg [7:0] registers [0:7];

    always @(posedge clk) begin
        if (write_enable) begin
            registers[write_addr] <= write_data;
        end
    end

    assign read_data_a = registers[read_addr_a];
    assign read_data_b = registers[read_addr_b];

endmodule
