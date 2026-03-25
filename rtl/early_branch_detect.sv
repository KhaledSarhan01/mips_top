import mips_pkg::*;
module early_branch_detect(
    // inputs
    input logic [31:0] d_instr,
    input logic [31:0] d_rs_data,
    input logic [31:0] d_rt_data,
    // outputs
    output logic d_zero_flag,
    output logic d_neg_flag,
    output logic ra_handle,
    output logic branch_used
);
// Instruction Decoding
    opcode_t d_opcode;
    funct_t  d_funct;
    assign d_opcode = opcode_t'(d_instr[31:26]);
    assign d_funct  = funct_t'( d_instr[5:0]);
// Branch Handling
    logic  rs_equal_rt, rs_equal_zero,rs_less_zero;
    assign rs_equal_rt   = (d_rs_data == d_rt_data);
    assign rs_equal_zero = ~|(d_rs_data);
    assign rs_less_zero  = (d_rs_data[31]);
    always_comb begin 
        d_zero_flag = 'b0;
        d_neg_flag  = 'b0;
        branch_used = 'b0;
        case (d_opcode)
            BEQ,BNE: begin
                d_zero_flag = rs_equal_rt;
                branch_used = 'b1;
            end
            BLT_BGEZ,BLEZ,BGTZ:begin
                d_zero_flag = rs_equal_zero;
                d_neg_flag  = rs_less_zero;
                branch_used = 'b1;
            end 
            default:begin
                d_zero_flag = 'b0;
                d_neg_flag  = 'b0;
                branch_used = 'b0;
            end 
        endcase
    end
// Jump Handling
    assign ra_handle  = (d_opcode == JAL) | ((d_opcode == RType) & (d_funct == JALR));
endmodule