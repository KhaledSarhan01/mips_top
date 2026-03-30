`define SIM
module multipler (
    // input clk,rst_n
    input [31:0] operand_a,operand_b,
    input logic unsigned_mult,
    output [31:0] out_hi,out_lo
);
`ifdef SIM
    // Signed Opeartion 
    logic signed [31:0] signed_operand_a,signed_operand_b;
    assign signed_operand_a = signed'(operand_a);
    assign signed_operand_b = signed'(operand_b);

    logic signed [31:0] signed_hi,signed_lo;
    assign {signed_hi,signed_lo} = signed_operand_a * signed_operand_b;
    // Unsigned Operation 
    logic signed [31:0] unsigned_hi,unsigned_lo;
    assign {unsigned_hi,unsigned_lo} = operand_a * operand_b;
    // Choosing 
    assign out_hi = (unsigned_mult)? unsigned_hi:signed_hi;
    assign out_lo = (unsigned_mult)? unsigned_lo:signed_lo;
`else
    // Synthesizable implementation must be applied here
    assign out_hi = 'b0;
    assign out_lo = 'b0;
`endif   
endmodule