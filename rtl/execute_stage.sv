import mips_pkg::*;
module execute_stage (
    input logic clk,rst_n,
    // exeception
    output logic arth_overflow_exception,
    // Pipeline inputs
    input logic [31:0]                  e_pc_plus4,
    input logic [31:0]                  e_instr   ,
    input logic                         e_memwrite     ,
    input logic [2:0]                   e_mem_se_sel   ,
    input logic [ALU_SRC_WIDTH-1:0]     e_alusrc       ,
    input logic [4:0]                   e_wbaddr       ,
    input logic                         e_regwrite     ,   
    input logic [ALU_CTRL_WIDTH-1:0]    e_alucontrl    ,
    input logic [REG_WR_SRC_WIDTH-1:0]  e_writeBack_sel,
    input logic                         e_hi_write     ,
    input logic                         e_lo_write     ,
    input logic                         e_unsigned_div ,
    input logic                         e_unsigned_mult,
    input logic [HI_LO_SEL_WIDTH-1:0]   e_hi_select    ,
    input logic [HI_LO_SEL_WIDTH-1:0]   e_lo_select    ,
    input logic                         e_overflow_mask,
    input logic [31:0]                  e_rs_data,
    input logic [31:0]                  e_rt_data,
    input logic [31:0]                  e_se_imm,
    // Pipeline Outputs
    output logic [31:0]  m_pc_plus4,
    output logic [31:0]  m_instr   ,
    output logic [31:0]  m_rs_data,
    output logic [31:0]  m_rt_data,
    output logic [31:0]  m_alu_result,
    output logic [31:0]  m_se_imm,
    output logic                         m_memwrite     ,
    output logic [2:0]                   m_mem_se_sel   ,
    output logic [4:0]                   m_wbaddr       ,
    output logic                         m_regwrite     ,
    output logic [REG_WR_SRC_WIDTH-1:0]  m_writeBack_sel,
    output logic                         m_hi_write     ,
    output logic                         m_lo_write     ,
    output logic [HI_LO_SEL_WIDTH-1:0]   m_hi_select    ,
    output logic [HI_LO_SEL_WIDTH-1:0]   m_lo_select    ,
    output logic [31:0]                  m_div_hi ,
    output logic [31:0]                  m_div_lo ,
    output logic [31:0]                  m_mult_hi,
    output logic [31:0]                  m_mult_lo,
    // Bypass inputs
    input logic [31:0] wb_mem_data,
    input logic [31:0] wb_data,
    // Hazards
    input logic [2:0] bypass_execute_rs_sel, 
    input logic [2:0] bypass_execute_rt_sel,
    input logic e2m_flush,
    input logic e2m_stall
);
// Memory/WB 2 Execute Bypass
    logic [31:0] e_rs_data_bypass,e_rt_data_bypass;
    mux8 #(.DATA_WIDTH(32)) u_execute_bypass_rs_data(
        .in0(e_rs_data),
        .in1(m_alu_result),
        .in2(m_mult_lo),
        .in3(m_se_imm),
        .in4(wb_mem_data),
        .in5(wb_data),
        .in6('b0),
        .in7('b0),
        .out(e_rs_data_bypass),
        .sel(bypass_execute_rs_sel)
    );
    mux8 #(.DATA_WIDTH(32)) u_execute_bypass_rt_data(
        .in0(e_rt_data),
        .in1(m_alu_result),
        .in2(m_mult_lo),
        .in3(m_se_imm),
        .in4(wb_mem_data),
        .in5(wb_data),
        .in6('b0),
        .in7('b0),
        .out(e_rt_data_bypass),
        .sel(bypass_execute_rt_sel)
    );
// ALU
    // output result
    logic [31:0] e_alu_result;
    // Flag // NOTE: NOT USED
    logic e_zero_flag;
    logic e_neg_flag;

    logic [4:0]  e_instr_shmat;
    assign e_instr_shmat = e_instr[10:6];

    logic [31:0] e_srcb;
    mux4 #(32) u_execute_srcbmux (   
        .in0(e_rt_data_bypass),
        .in1(e_se_imm),
        .in2('b0),
        .in3('b0), 
        .sel(e_alusrc),
        .out(e_srcb)
    );
    alu u_execute_alu(
        .clk(clk),
        .rst_n(rst_n),
        // input operands 
        .operand_a(e_rs_data_bypass),  // [rs]
        .operand_b(e_srcb),     // [rt] or signimm
        .shmat(e_instr_shmat),
        // ALU control signal
        .alu_control(e_alucontrl),
        // output result
        .alu_result(e_alu_result),
        // overflow
        .overflow_mask(e_overflow_mask),
        .arth_overflow_exception(arth_overflow_exception),
        // Flag 
        .zero_flag(e_zero_flag),
        .neg_flag(e_neg_flag)
    );
// Multipler/Divider
    logic [31:0] e_div_hi;
    logic [31:0] e_div_lo;
    logic [31:0] e_mult_hi;
    logic [31:0] e_mult_lo;
    multipler u_execute_mult(
        // input clk,rst_n
        .operand_a(e_rs_data_bypass),
        .operand_b(e_rt_data_bypass),
        .unsigned_mult(e_unsigned_mult),
        .out_hi(e_mult_hi),
        .out_lo(e_mult_lo)
    ); 
    // divider u_excute_div(
    // // input clk,rst_n,
    // .operand_a(e_rs_data_bypass),
    // .operand_b(e_rt_data_bypass),
    // .unsigned_div(e_unsigned_div),
    // .out_hi(e_div_hi),
    // .out_lo(e_div_lo)
    // ); 
    assign e_div_hi = 'b0;
    assign e_div_lo = 'b0;   
// Execute Memory Register
    always_ff @( posedge clk or negedge rst_n) begin 
        if (!rst_n) begin
            // Previous Stage
            m_pc_plus4 <= 'b0;
            m_instr    <= 'b0;
            m_rs_data  <= 'b0;
            m_rt_data  <= 'b0;
            m_se_imm   <= 'b0;
            // Controls
            m_memwrite      <= 'b0;
            m_mem_se_sel    <= 'b0;
            m_wbaddr        <= 'b0;
            m_regwrite      <= 'b0;
            m_writeBack_sel <= 'b0;
            m_hi_write      <= 'b0;
            m_lo_write      <= 'b0;
            m_hi_select     <= 'b0;
            m_lo_select     <= 'b0;
            // ALU
            m_alu_result <= 'b0;
            // Multipler/Divider
            m_div_hi  <= 'b0;
            m_div_lo  <= 'b0;
            m_mult_hi <= 'b0;
            m_mult_lo <= 'b0;
        end else begin
            if (e2m_flush) begin
                // Previous Stage
                m_pc_plus4 <= 'b0;
                m_instr    <= 'b0;
                m_rs_data  <= 'b0;
                m_rt_data  <= 'b0;
                m_se_imm   <= 'b0;
                // Controls
                m_memwrite      <= 'b0;
                m_mem_se_sel    <= 'b0;
                m_wbaddr        <= 'b0;
                m_regwrite      <= 'b0;
                m_writeBack_sel <= 'b0;
                m_hi_write      <= 'b0;
                m_lo_write      <= 'b0;
                m_hi_select     <= 'b0;
                m_lo_select     <= 'b0;
                // ALU
                m_alu_result <= 'b0;
                // Multipler/Divider
                m_div_hi  <= 'b0;
                m_div_lo  <= 'b0;
                m_mult_hi <= 'b0;
                m_mult_lo <= 'b0;
            end else if(~e2m_stall)begin
                // Previous Stage
                m_pc_plus4 <= e_pc_plus4;
                m_instr    <= e_instr   ;
                m_rs_data  <= e_rs_data_bypass ;
                m_rt_data  <= e_rt_data_bypass ;
                m_se_imm   <= e_se_imm  ;
                // Controls
                m_memwrite      <= e_memwrite     ;
                m_mem_se_sel    <= e_mem_se_sel   ;
                m_wbaddr        <= e_wbaddr       ;
                m_regwrite      <= e_regwrite     ;
                m_writeBack_sel <= e_writeBack_sel;
                m_hi_write      <= e_hi_write     ;
                m_lo_write      <= e_lo_write     ;
                m_hi_select     <= e_hi_select    ;
                m_lo_select     <= e_lo_select    ;
                // ALU
                m_alu_result <= e_alu_result;
                // Multipler/Divider
                m_div_hi  <= e_div_hi ;
                m_div_lo  <= e_div_lo ;
                m_mult_hi <= e_mult_hi;
                m_mult_lo <= e_mult_lo; 
            end
        end
    end
endmodule