import mips_pkg::*;
module mem_stage (
    input logic clk,rst_n,
    // To Data Memory
    output memwrite,
    output [DATA_MEM_WIDTH-1:0] memaddr,
    output [DATA_MEM_WIDTH-1:0] writedata,
    input  [DATA_MEM_WIDTH-1:0] readdata,
    // Pipeline inputs 
    input logic [31:0]  m_pc_plus4,
    input logic [31:0]  m_instr   ,
    input logic [31:0]  m_rs_data,
    input logic [31:0]  m_rt_data,
    input logic [31:0]  m_alu_result,
    input logic [31:0]  m_se_imm,
    input logic                         m_memwrite     ,
    input logic [2:0]                   m_mem_se_sel   ,
    input logic [4:0]                   m_wbaddr       ,
    input logic                         m_regwrite     ,
    input logic [REG_WR_SRC_WIDTH-1:0]  m_writeBack_sel,
    input logic                         m_hi_write     ,
    input logic                         m_lo_write     ,
    input logic [HI_LO_SEL_WIDTH-1:0]   m_hi_select    ,
    input logic [HI_LO_SEL_WIDTH-1:0]   m_lo_select    ,
    input logic [31:0]                  m_div_hi ,
    input logic [31:0]                  m_div_lo ,
    input logic [31:0]                  m_mult_hi,
    input logic [31:0]                  m_mult_lo,
    // Pipeline outputs
    output logic [31:0]  wb_hi_reg,
    output logic [31:0]  wb_lo_reg,
    output logic [31:0]  wb_pc_plus4    ,
    output logic [31:0]  wb_instr       ,
    output logic [31:0]  wb_se_imm      ,
    output logic [31:0]  wb_alu_result  ,
    output logic [31:0]  wb_mult_lo     ,
    output logic         wb_regwrite    ,
    output logic [4:0]   wb_addr,
    output logic [REG_WR_SRC_WIDTH-1:0]  wb_writeBack_sel,
    output logic [31:0] wb_mem_data,
    output logic [31:0] wb_mem_se_data,
    // Bypass inputs
    input logic [31:0] wb_data,
    // Hazards
    input logic [1:0] bypass_mem_rs_sel, 
    input logic [1:0] bypass_mem_rt_sel, 
    input logic m2wb_flush,
    input logic m2wb_stall
);
// Bypass
    logic [31:0] m_rs_data_bypass,m_rt_data_bypass;
    // WB 2 Memory Bypass
        mux4 #(.DATA_WIDTH(32)) u_mem_bypass_rs_data(
            .in0(m_rs_data),
            .in1(wb_mem_data),
            .in2(wb_data),
            .in3('b0),
            .out(m_rs_data_bypass),
            .sel(bypass_mem_rs_sel)
        );
        mux4 #(.DATA_WIDTH(32)) u_mem_bypass_rt_data(
            .in0(m_rt_data),
            .in1(wb_mem_data),
            .in2(wb_data),
            .in3('b0),
            .out(m_rt_data_bypass),
            .sel(bypass_mem_rt_sel)
        ); 
// Data Memory
    logic [31:0] m_mem_data;
    assign memwrite  = m_memwrite;
    assign memaddr   = m_alu_result;
    assign writedata = m_rt_data_bypass;
    assign m_mem_data = readdata;

// Lo/Hi Register
    lo_hi_reg u_mem_lo_hi_reg(
        // Clock and Active Low Reset
        .clk(clk),
        .rst_n(rst_n),
        // Inputs 
        .reg_file(m_rs_data_bypass),
        .mult_lo(m_mult_lo),
        .mult_hi(m_mult_hi),
        .div_lo(m_div_lo),
        .div_hi(m_div_hi),
        // Controls
        .hi_write(m_hi_write),
        .lo_write(m_lo_write),
        .hi_select(m_hi_select),
        .lo_select(m_lo_select),
        // Outputs
        .lo_reg(wb_lo_reg),
        .hi_reg(wb_hi_reg)        
    );
// Memory Data Sign Extention
    logic [31:0] m_mem_se_data;
    sign_extended u_mem_write_back_signextent (
        .in_data(m_mem_data[15:0]),
        .se_select(m_mem_se_sel),
        .out_data(m_mem_se_data)
    );
// Memory to Write Back Register
    always_ff @( posedge clk or negedge rst_n ) begin 
        if (!rst_n) begin
            // Previous Stage
            wb_pc_plus4   <= 'b0;
            wb_instr      <= 'b0;
            wb_se_imm     <= 'b0;
            wb_alu_result <= 'b0;
            wb_mult_lo    <= 'b0;
            // Controls
            wb_addr          <= 'b0;
            wb_regwrite      <= 'b0;
            wb_writeBack_sel <= 'b0;
            // Data Memory
            wb_mem_data      <= 'b0;
            // Memory Data Sign Extention
            wb_mem_se_data  <= 'b0;
        end else begin
            if (m2wb_flush) begin
                // Previous Stage
                wb_pc_plus4   <= 'b0;
                wb_instr      <= 'b0;
                wb_se_imm     <= 'b0;
                wb_alu_result <= 'b0;
                wb_mult_lo    <= 'b0;
                // Controls
                wb_addr          <= 'b0;
                wb_regwrite      <= 'b0;
                wb_writeBack_sel <= 'b0;
                // Data Memory
                wb_mem_data      <= 'b0;
                // Memory Data Sign Extention
                wb_mem_se_data  <= 'b0;
            end else if(~m2wb_stall)begin
                // Previous Stage
                wb_pc_plus4   <= m_pc_plus4  ;
                wb_instr      <= m_instr     ;
                wb_se_imm     <= m_se_imm    ;
                wb_alu_result <= m_alu_result;
                wb_mult_lo    <= m_mult_lo   ;
                // Controls
                wb_addr          <= m_wbaddr       ;
                wb_regwrite      <= m_regwrite     ;
                wb_writeBack_sel <= m_writeBack_sel;
                // Data Memory
                wb_mem_data      <= m_mem_data;
                // Memory Data Sign Extention
                wb_mem_se_data   <= m_mem_se_data;    
            end
        end
    end
endmodule