import mips_pkg::*;
module hazard_unit (
    // inputs 
    input logic jump_taken,
    // ouptuts
    output logic pc_stall,
    output logic f2d_stall,
    output logic f2d_flush,
    output logic d2e_stall,
    output logic d2e_flush,
    output logic e2m_stall,
    output logic e2m_flush,
    output logic m2wb_stall,
    output logic m2wb_flush,
    output logic [2:0] bypass_decode_rs_sel,
    output logic [2:0] bypass_decode_rt_sel,
    output logic [2:0] bypass_execute_rs_sel, 
    output logic [2:0] bypass_execute_rt_sel,
    output logic [1:0] bypass_mem_rs_sel,
    output logic [1:0] bypass_mem_rt_sel
);
// Hazard Unit Logic
    assign pc_stall  = 1'b0;
    assign f2d_stall = 1'b0;
    assign f2d_flush = 1'b0;
    assign d2e_stall = 1'b0;
    assign d2e_flush = 1'b0;
    assign e2m_stall = 1'b0;
    assign e2m_flush = 1'b0;
    assign m2wb_stall = 1'b0;
    assign m2wb_flush = 1'b0;
    assign bypass_decode_rs_sel = 'b0;
    assign bypass_decode_rt_sel = 'b0;
    assign bypass_execute_rs_sel = 'b0;
    assign bypass_execute_rt_sel = 'b0;
    assign bypass_mem_rs_sel = 'b0;
    assign bypass_mem_rt_sel = 'b0;
endmodule