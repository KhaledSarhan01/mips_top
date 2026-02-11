module multipler (
    // input clk,rst_n
    input [31:0] operand_a,operand_b,
    input logic unsigned_mult,
    output [31:0] out_hi,out_lo
);
    assign {out_hi,out_lo} = operand_a * operand_b;
endmodule