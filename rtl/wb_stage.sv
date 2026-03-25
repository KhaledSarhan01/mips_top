import mips_pkg::*;
module wb_stage (
    input logic clk,rst_n,
    // Pipeline Inputs 
    input logic [31:0]  wb_hi_reg,
    input logic [31:0]  wb_lo_reg,
    input logic [31:0]  wb_pc_plus4    ,
    input logic [31:0]  wb_instr       ,
    input logic [31:0]  wb_se_imm      ,
    input logic [31:0]  wb_alu_result  ,
    input logic [31:0]  wb_mult_lo     ,
    input logic [REG_WR_SRC_WIDTH-1:0]  wb_writeBack_sel,
    input logic [31:0] wb_mem_data,
    input logic [31:0] wb_mem_se_data,
    // Pipeline outputs
    output logic [31:0] wb_data
);
// Write Back Data Source
    mux8 #(32) u_WriteBack_datamux(
        .in0(wb_alu_result), 
        .in1(wb_mem_data),
        .in2(wb_hi_reg),
        .in3(wb_lo_reg),
        .in4(wb_pc_plus4),
        .in5(wb_se_imm),
        .in6(wb_mult_lo),
        .in7(wb_mem_se_data),
        .sel(wb_writeBack_sel), 
        .out(wb_data)
    ); 


endmodule