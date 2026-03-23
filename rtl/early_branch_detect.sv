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
    output logic jump_taken
);
opcode_t d_instr_opcode;
assign d_instr_opcode = opcode_t'(d_instr[31:26]);

logic  rs_equal_rt, rs_equal_zero,rs_less_zero;
assign rs_equal_rt   = (d_rs_data == d_rt_data);
assign rs_equal_zero = ~|(d_rs_data);
assign rs_less_zero  = (d_rs_data[31]);
always_comb begin 
    d_zero_flag     = 'b0;
    d_neg_flag      = 'b0;
    ra_handle       = 'b0;
    jump_taken      = 'b0;
    case (d_instr_opcode)
        BEQ,BNE: d_zero_flag = rs_equal_rt;
        BLT_BGEZ,BLEZ,BGTZ:begin
            d_zero_flag     = rs_equal_zero;
            d_neg_flag      = rs_less_zero;
        end 
        JAL,JALR: begin
            ra_handle  = 'b1;
            jump_taken = 'b1;
        end
        J,JR:begin
            ra_handle  = 'b0;
            jump_taken = 'b1;
        end
        default:begin
            d_zero_flag     = 'b0;
            d_neg_flag      = 'b0;
            ra_handle       = 'b0;
        end 
    endcase
end
endmodule