import mips_pkg::*;
module mips_core (
    input clk,rst_n,
    // Status
    output logic arth_overflow_exception,
    output [31:0] s0,
    // To instruction Memory
    output [PC_WIDTH-1:0]     pc,
    input  [INSTR_WITDTH-1:0] instr,
    // To Data Memory
    output memwrite,
    output [DATA_MEM_WIDTH-1:0] memaddr,writedata,
    input  [DATA_MEM_WIDTH-1:0] readdata
);

// Bypass inputs
    logic [31:0] m_alu_result;
    logic [31:0] m_mult_lo;
    logic [31:0] m_se_imm ;
    logic [31:0] wb_mem_data;
    logic [31:0] wb_data;
// Hazard Unit Signals
    logic pc_stall;
    logic f2d_stall,f2d_flush;
    logic d2e_stall,d2e_flush;
    logic e2m_stall,e2m_flush;
    logic m2wb_stall,m2wb_flush;
    logic [2:0] bypass_decode_rs_sel;
    logic [2:0] bypass_decode_rt_sel;
    logic [2:0] bypass_execute_rs_sel; 
    logic [2:0] bypass_execute_rt_sel;
    logic [1:0] bypass_mem_rs_sel; 
    logic [1:0] bypass_mem_rt_sel; 
// Main Pipeline
    // Fetch Stage
        // Pipeline inputs
        logic [1:0]  f_pcsrc;
        logic [31:0] f_regfile;
        logic [31:0] f_BTA,f_JTA;
        // Pipeline outputs
        logic [31:0] d_pc;
        logic [31:0] d_instr;
        logic [31:0] d_pc_plus4;

       fetch_stage u_mips_fetch_stage (
        .clk(clk),
        .rst_n(rst_n), 
        // instruction Memory
        .pc(pc),
        .instr(instr), 
        // Pipeline inputs
        .f_pcsrc(f_pcsrc),
        .f_regfile(f_regfile),
        .f_BTA(f_BTA),
        .f_JTA(f_JTA),
        // Pipeline outputs
        .d_pc(d_pc),
        .d_instr(d_instr),
        .d_pc_plus4(d_pc_plus4),
        // Hazard
        .pc_stall(pc_stall),
        .f2d_flush(f2d_flush),
        .f2d_stall(f2d_stall)    
        ); 
    
    // Decode Stage
        // Pipeline input
        logic [4:0]  wb_addr;
        logic        wb_regwrite;
        // Pipeline outputs
        logic [31:0]                  e_rs_data;
        logic [31:0]                  e_rt_data;
        logic [31:0]                  e_pc_plus4;
        logic [31:0]                  e_instr   ;
        logic                         e_memwrite     ;
        logic [2:0]                   e_mem_se_sel   ;
        logic [ALU_SRC_WIDTH-1:0]     e_alusrc       ;
        logic [4:0]                   e_wbaddr       ;
        logic                         e_regwrite     ;   
        logic [ALU_CTRL_WIDTH-1:0]    e_alucontrl    ;
        logic [REG_WR_SRC_WIDTH-1:0]  e_writeBack_sel;
        logic                         e_hi_write     ;
        logic                         e_lo_write     ;
        logic                         e_unsigned_div ;
        logic                         e_unsigned_mult;
        logic [HI_LO_SEL_WIDTH-1:0]   e_hi_select    ;
        logic [HI_LO_SEL_WIDTH-1:0]   e_lo_select    ;
        logic                         e_overflow_mask;
        logic [31:0]                  e_se_imm;
        
        decode_stage u_mips_decode_stage (
            .clk(clk),
            .rst_n(rst_n),
            // Pipeline input
            .d_pc(d_pc),
            .d_instr(d_instr),
            .d_pc_plus4(d_pc_plus4),
            // Write Back inputs/outputs
            .s0(s0),
            .d_pcsrc(f_pcsrc),
            .d_regfile(f_regfile),
            .d_BTA(f_BTA),
            .d_JTA(f_JTA),
            .wb_addr(wb_addr),
            .wb_regwrite(wb_regwrite),
            // Bypass Inputs
            .m_alu_result(m_alu_result),
            .m_mult_lo(m_mult_lo),
            .m_se_imm(m_se_imm),
            .wb_mem_data(wb_mem_data),
            .wb_data(wb_data),
            // Pipeline outputs
            .e_pc_plus4(e_pc_plus4),
            .e_instr(e_instr),
            .e_memwrite(e_memwrite),
            .e_mem_se_sel(e_mem_se_sel),
            .e_alusrc(e_alusrc),
            .e_wbaddr(e_wbaddr),
            .e_regwrite(e_regwrite),   
            .e_alucontrl(e_alucontrl),
            .e_writeBack_sel(e_writeBack_sel),
            .e_hi_write(e_hi_write),
            .e_lo_write(e_lo_write),
            .e_unsigned_div(e_unsigned_div),
            .e_unsigned_mult(e_unsigned_mult),
            .e_hi_select(e_hi_select),
            .e_lo_select(e_lo_select),
            .e_overflow_mask(e_overflow_mask),
            .e_rs_data(e_rs_data),
            .e_rt_data(e_rt_data),
            .e_se_imm(e_se_imm),
            // Hazards
            .bypass_decode_rs_sel(bypass_decode_rs_sel),
            .bypass_decode_rt_sel(bypass_decode_rt_sel),
            .d2e_flush(d2e_flush),
            .d2e_stall(d2e_stall)
        ); 
    
    // Execute Stage
        // Pipeline Outputs
        logic [31:0]  m_pc_plus4;
        logic [31:0]  m_instr   ;
        logic [31:0]  m_rs_data;
        logic [31:0]  m_rt_data;
        logic                         m_memwrite     ;
        logic [2:0]                   m_mem_se_sel   ;
        logic [4:0]                   m_wbaddr       ;
        logic                         m_regwrite     ;
        logic [REG_WR_SRC_WIDTH-1:0]  m_writeBack_sel;
        logic                         m_hi_write     ;
        logic                         m_lo_write     ;
        logic [HI_LO_SEL_WIDTH-1:0]   m_hi_select    ;
        logic [HI_LO_SEL_WIDTH-1:0]   m_lo_select    ;
        logic [31:0]                  m_div_hi ;
        logic [31:0]                  m_div_lo ;
        logic [31:0]                  m_mult_hi;
        execute_stage u_mips_execute_stage (
            .clk(clk),
            .rst_n(rst_n),
            .arth_overflow_exception(arth_overflow_exception),
            // Pipeline inputs
            .e_pc_plus4(e_pc_plus4),
            .e_instr(e_instr),
            .e_memwrite(e_memwrite),
            .e_mem_se_sel(e_mem_se_sel),
            .e_alusrc(e_alusrc),
            .e_wbaddr(e_wbaddr),
            .e_regwrite(e_regwrite),   
            .e_alucontrl(e_alucontrl),
            .e_writeBack_sel(e_writeBack_sel),
            .e_hi_write(e_hi_write),
            .e_lo_write(e_lo_write),
            .e_unsigned_div(e_unsigned_div),
            .e_unsigned_mult(e_unsigned_mult),
            .e_hi_select(e_hi_select),
            .e_lo_select(e_lo_select),
            .e_overflow_mask(e_overflow_mask),
            .e_rs_data(e_rs_data),
            .e_rt_data(e_rt_data),
            .e_se_imm(e_se_imm),
            // Pipeline Outputs
            .m_pc_plus4(m_pc_plus4),
            .m_instr(m_instr),
            .m_rs_data(m_rs_data),
            .m_rt_data(m_rt_data),
            .m_alu_result(m_alu_result),
            .m_se_imm(m_se_imm),
            .m_memwrite(m_memwrite),
            .m_mem_se_sel(m_mem_se_sel),
            .m_wbaddr(m_wbaddr),
            .m_regwrite(m_regwrite),
            .m_writeBack_sel(m_writeBack_sel),
            .m_hi_write(m_hi_write),
            .m_lo_write(m_lo_write),
            .m_hi_select(m_hi_select),
            .m_lo_select(m_lo_select),
            .m_div_hi(m_div_hi),
            .m_div_lo(m_div_lo),
            .m_mult_hi(m_mult_hi),
            .m_mult_lo(m_mult_lo),
            // Bypass inputs
            .wb_mem_data(wb_mem_data),
            .wb_data(wb_data),
            // Hazards
            .bypass_execute_rs_sel(bypass_execute_rs_sel), 
            .bypass_execute_rt_sel(bypass_execute_rt_sel),
            .e2m_flush(e2m_flush),
            .e2m_stall(e2m_stall)
        );
    
    // Memory Stage
        // Pipeline outputs
        logic [31:0]  wb_hi_reg;
        logic [31:0]  wb_lo_reg;
        logic [31:0]  wb_pc_plus4    ;
        logic [31:0]  wb_instr       ;
        logic [31:0]  wb_se_imm      ;
        logic [31:0]  wb_alu_result  ;
        logic [31:0]  wb_mult_lo     ;
        logic [REG_WR_ADDR_WIDTH-1:0] wb_regdst;
        logic [REG_WR_SRC_WIDTH-1:0]  wb_writeBack_sel;
        logic [31:0] wb_mem_se_data;

        mem_stage u_mips_memory_stage(
            .clk(clk),
            .rst_n(rst_n),
            // To Data Memory
            .memwrite(memwrite),
            .memaddr(memaddr),
            .writedata(writedata),
            .readdata(readdata),
            // Pipeline inputs 
            .m_pc_plus4(m_pc_plus4),
            .m_instr(m_instr),
            .m_rs_data(m_rs_data),
            .m_rt_data(m_rt_data),
            .m_alu_result(m_alu_result),
            .m_se_imm(m_se_imm),
            .m_memwrite(m_memwrite),
            .m_mem_se_sel(m_mem_se_sel),
            .m_wbaddr(m_wbaddr),
            .m_regwrite(m_regwrite),
            .m_writeBack_sel(m_writeBack_sel),
            .m_hi_write(m_hi_write),
            .m_lo_write(m_lo_write),
            .m_hi_select(m_hi_select),
            .m_lo_select(m_lo_select),
            .m_div_hi(m_div_hi),
            .m_div_lo(m_div_lo),
            .m_mult_hi(m_mult_hi),
            .m_mult_lo(m_mult_lo),
            // Pipeline outputs
            .wb_hi_reg(wb_hi_reg),
            .wb_lo_reg(wb_lo_reg),
            .wb_pc_plus4(wb_pc_plus4),
            .wb_instr(wb_instr),
            .wb_se_imm(wb_se_imm),
            .wb_alu_result(wb_alu_result),
            .wb_mult_lo(wb_mult_lo),
            .wb_regwrite(wb_regwrite),
            .wb_addr(wb_addr),
            .wb_writeBack_sel(wb_writeBack_sel),
            .wb_mem_data(wb_mem_data),
            .wb_mem_se_data(wb_mem_se_data),
            // Bypass inputs
            .wb_data(wb_data),
            // Hazards
            .bypass_mem_rs_sel(bypass_mem_rs_sel), 
            .bypass_mem_rt_sel(bypass_mem_rt_sel), 
            .m2wb_flush(m2wb_flush),
            .m2wb_stall(m2wb_stall)
        );
    // Write Back Stage 
        wb_stage u_mips_writeBack_stage(
            .clk(clk),
            .rst_n(rst_n),
            // Pipeline Inputs 
            .wb_hi_reg(wb_hi_reg),
            .wb_lo_reg(wb_lo_reg),
            .wb_pc_plus4(wb_pc_plus4),
            .wb_instr(wb_instr),
            .wb_se_imm(wb_se_imm),
            .wb_alu_result(wb_alu_result),
            .wb_mult_lo(wb_mult_lo),
            .wb_writeBack_sel(wb_writeBack_sel),
            .wb_mem_data(wb_mem_data),
            .wb_mem_se_data(wb_mem_se_data),
            // Pipeline outputs
            .wb_data(wb_data)
        );    
// Hazard Unit
    hazard_unit u_mips_hazard_unit(
        // inputs 
        .d_instr(d_instr),
        .e_instr(e_instr),
        .m_instr(m_instr),
        .wb_instr(wb_instr),
        .e_regwrite(e_regwrite),
        .m_regwrite(m_regwrite),
        .wb_regwrite(wb_regwrite),
        .e_wbaddr(e_wbaddr),
        .m_wbaddr(m_wbaddr),
        .wb_addr(wb_addr),
        .f_pcsrc(f_pcsrc),
        // ouptuts
        .pc_stall(pc_stall),
        .f2d_stall(f2d_stall),
        .f2d_flush(f2d_flush),
        .d2e_stall(d2e_stall),
        .d2e_flush(d2e_flush),
        .e2m_stall(e2m_stall),
        .e2m_flush(e2m_flush),
        .m2wb_stall(m2wb_stall),
        .m2wb_flush(m2wb_flush),
        .bypass_decode_rs_sel(bypass_decode_rs_sel),
        .bypass_decode_rt_sel(bypass_decode_rt_sel),
        .bypass_execute_rs_sel(bypass_execute_rs_sel), 
        .bypass_execute_rt_sel(bypass_execute_rt_sel),
        .bypass_mem_rs_sel(bypass_mem_rs_sel),
        .bypass_mem_rt_sel(bypass_mem_rt_sel)
    );
endmodule