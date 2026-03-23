module divider (
    // input clk,rst_n,
    input [31:0] operand_a,operand_b,
    input logic unsigned_div,
    output [31:0] out_hi,out_lo
);
    assign out_lo = operand_a / operand_b;
    assign out_hi = operand_a % operand_b;
endmodule