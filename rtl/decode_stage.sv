import mips_pkg::*;
module decode_stage (
    input logic clk,rst_n,
    // Pipeline input
    input logic [31:0] d_pc,
    input logic [31:0] d_instr,
    input logic [31:0] d_pc_plus4,
    // Pipeline outputs
    output logic [31:0]                  s0,
    output logic [31:0]                  e_pc_plus4,
    output logic [31:0]                  e_instr   ,
    output logic                         e_memwrite     ,
    output logic [2:0]                   e_mem_se_sel   ,
    output logic [ALU_SRC_WIDTH-1:0]     e_alusrc       ,
    output logic [4:0]                   e_wbaddr       ,
    output logic                         e_regwrite     ,   
    output logic [ALU_CTRL_WIDTH-1:0]    e_alucontrl    ,
    output logic [REG_WR_SRC_WIDTH-1:0]  e_writeBack_sel,
    output logic                         e_hi_write     ,
    output logic                         e_lo_write     ,
    output logic                         e_unsigned_div ,
    output logic                         e_unsigned_mult,
    output logic [HI_LO_SEL_WIDTH-1:0]   e_hi_select    ,
    output logic [HI_LO_SEL_WIDTH-1:0]   e_lo_select    ,
    output logic                         e_overflow_mask,
    output logic [31:0]                  e_rs_data,
    output logic [31:0]                  e_rt_data,
    output logic [31:0]                  e_se_imm,
    // Write Back inputs/outputs
    input  logic        wb_regwrite,
    input  logic [4:0]  wb_addr,
    output logic [1:0]  d_pcsrc,
    output logic [31:0] d_JTA,
    output logic [31:0] d_BTA,
    output logic [31:0] d_regfile,
    // Bypass Inputs
    input logic [31:0] m_alu_result,
    input logic [31:0] m_mult_lo,
    input logic [31:0] m_se_imm,
    input logic [31:0] wb_mem_data,
    input logic [31:0] wb_data,
    // Hazards
    input  logic [2:0] bypass_decode_rs_sel,
    input  logic [2:0] bypass_decode_rt_sel,
    output logic branch_used,
    input  logic d2e_flush,
    input  logic d2e_stall
);

// Register File
    // Read ports
    logic [31:0] d_rs_data_regfile;
    logic [31:0] d_rt_data_regfile;
    logic [4:0]  d_instr_rs,d_instr_rt;
    assign d_instr_rs = d_instr[25:21];
    assign d_instr_rt = d_instr[20:16];
    // Return Address
    logic ra_handle;
    reg_file u_decode_regfile (
        .clk_n(clk),
        .rst_n(rst_n),
        .s0(s0),
        // Read port 1
        .read_addr1(d_instr_rs),
        .read_data1(d_rs_data_regfile),
        // Read port 2
        .read_addr2(d_instr_rt),    
        .read_data2(d_rt_data_regfile),
        // Write port
        .write_addr(wb_addr),
        .write_data(wb_data),
        .write_enable(wb_regwrite),
        // return address port
        .pc_plus4(d_pc_plus4),
        .ra_handle(ra_handle)
    );
    // Jump regfile bypass
    assign d_regfile = d_rs_data_regfile;

// rs/rt Data Bypass
    logic [31:0] d_rs_data,d_rt_data;
    // Execute/Memory/WB 2 Decode Bypass
        mux8 #(.DATA_WIDTH(32)) u_decode_bypass_rs_data(
            .in0(d_rs_data_regfile),
            .in1(m_alu_result),
            .in2(m_mult_lo),
            .in3(m_se_imm),
            .in4(wb_mem_data),
            .in5(wb_data),
            .in6('b0),
            .in7('b0),
            .out(d_rs_data),
            .sel(bypass_decode_rs_sel)
        );
        mux8 #(.DATA_WIDTH(32)) u_decode_bypass_rt_data(
            .in0(d_rt_data_regfile),
            .in1(m_alu_result),
            .in2(m_mult_lo),
            .in3(m_se_imm),
            .in4(wb_mem_data),
            .in5(wb_data),
            .in6('b0),
            .in7('b0),
            .out(d_rt_data),
            .sel(bypass_decode_rt_sel)
        );

// Early Branch Detection
    logic d_zero_flag;
    logic d_neg_flag;
    early_branch_detect u_decode_earlyBranchDetect (
        // inputs
        .d_instr(d_instr),
        .d_rs_data(d_rs_data),
        .d_rt_data(d_rt_data),
        // outputs
        .d_zero_flag(d_zero_flag),
        .d_neg_flag(d_neg_flag),
        .ra_handle(ra_handle),
        .branch_used(branch_used)
    );
// Controls
    logic                         d_memwrite     ;
    logic [2:0]                   d_imm_se_sel   ;
    logic [2:0]                   d_mem_se_sel   ;
    logic [ALU_SRC_WIDTH-1:0]     d_alusrc       ;
    logic [REG_WR_ADDR_WIDTH-1:0] d_regdst       ;
    logic                         d_regwrite     ;   
    logic [ALU_CTRL_WIDTH-1:0]    d_alucontrl    ;
    logic [REG_WR_SRC_WIDTH-1:0]  d_writeBack_sel;
    logic                         d_hi_write     ;
    logic                         d_lo_write     ;
    logic                         d_unsigned_div ;
    logic                         d_unsigned_mult;
    logic [HI_LO_SEL_WIDTH-1:0]   d_hi_select    ;
    logic [HI_LO_SEL_WIDTH-1:0]   d_lo_select    ; 
    logic                         d_overflow_mask;
    mips_controller u_decode_controller(
        .clk(clk),
        .rst_n(rst_n),
        .instr(d_instr),
        // Flags
        .zero_flag(d_zero_flag),
        .neg_flag(d_neg_flag),
        .overflow_mask(d_overflow_mask),
        // Controls
        .memwrite(d_memwrite),
        .se_select(d_imm_se_sel),
        .wb_se_select(d_mem_se_sel),
        .pcsrc(d_pcsrc),
        .alusrc(d_alusrc),
        .regdst(d_regdst),
        .regwrite(d_regwrite),   
        .alucontrl(d_alucontrl),
        .write_back_sel(d_writeBack_sel),
        .hi_write(d_hi_write),
        .lo_write(d_lo_write),
        .unsigned_div(d_unsigned_div),
        .unsigned_mult(d_unsigned_mult),
        .hi_select(d_hi_select),
        .lo_select(d_lo_select)
    );
// Write Back Address Source
    logic [4:0] d_wbaddr;
    logic [4:0] d_instr_rd;
    assign d_instr_rd = d_instr[15:11];
    mux4 #(5) u_execute_wb_addrmux(
        .in0(d_instr_rt), 
        .in1(d_instr_rd),
        .in2(5'd31),
        .in3(5'd0),
        .sel(d_regdst), 
        .out(d_wbaddr)
    );    
// Immediate Sign Extention
    logic [15:0] d_instr_imm;
    assign d_instr_imm = d_instr[15:0];
    logic [31:0] d_se_imm;
    sign_extended u_decode_signExtent(
        .se_select(d_imm_se_sel),
        .in_data(d_instr_imm),
        .out_data(d_se_imm)
    );  
// JTA/BTA
    logic [25:0] d_instr_jaddress;
    assign d_instr_jaddress = d_instr[25:0];
    assign d_BTA = d_pc_plus4 + (d_se_imm << 2);            // Branch target
    assign d_JTA = {d_pc[31:28], d_instr_jaddress, 2'b00};  // Jump target
// Decode Execute Register
    always_ff @( posedge clk or negedge rst_n ) begin 
        if (!rst_n) begin
            // Previous Stage
            e_pc_plus4 <= 'b0;
            e_instr    <= 'b0;
            // Controls
            e_memwrite      <= 'b0;
            e_mem_se_sel    <= 'b0;
            e_alusrc        <= 'b0;
            e_wbaddr        <= 'b0;
            e_regwrite      <= 'b0;   
            e_alucontrl     <= 'b0;
            e_writeBack_sel <= 'b0;
            e_hi_write      <= 'b0;
            e_lo_write      <= 'b0;
            e_unsigned_div  <= 'b0;
            e_unsigned_mult <= 'b0;
            e_hi_select     <= 'b0;
            e_lo_select     <= 'b0;
            e_overflow_mask <= 'b0;
            // Register File
            e_rs_data <= 'b0;
            e_rt_data <= 'b0;
            // Immediate Sign Extention
            e_se_imm <= 'b0;
        end else begin
            if (d2e_flush) begin
                // Previous Stage
                e_pc_plus4 <= 'b0;
                e_instr    <= 'b0;
                // Controls
                e_memwrite      <= 'b0;
                e_mem_se_sel    <= 'b0;
                e_alusrc        <= 'b0;
                e_wbaddr        <= 'b0;
                e_regwrite      <= 'b0;   
                e_alucontrl     <= 'b0;
                e_writeBack_sel <= 'b0;
                e_hi_write      <= 'b0;
                e_lo_write      <= 'b0;
                e_unsigned_div  <= 'b0;
                e_unsigned_mult <= 'b0;
                e_hi_select     <= 'b0;
                e_lo_select     <= 'b0;
                e_overflow_mask <= 'b0;
                // Register File
                e_rs_data<= 'b0;
                e_rt_data<= 'b0;
                // Immediate Sign Extention
                e_se_imm <= 'b0;
            end else if(~d2e_stall)begin
                // Previous Stage
                e_pc_plus4 <= d_pc_plus4;
                e_instr    <= d_instr   ;
                // Controls
                e_memwrite      <= d_memwrite     ;
                e_mem_se_sel    <= d_mem_se_sel   ;
                e_alusrc        <= d_alusrc       ;
                e_wbaddr        <= d_wbaddr       ;
                e_regwrite      <= d_regwrite     ;   
                e_alucontrl     <= d_alucontrl    ;
                e_writeBack_sel <= d_writeBack_sel;
                e_hi_write      <= d_hi_write     ;
                e_lo_write      <= d_lo_write     ;
                e_unsigned_div  <= d_unsigned_div ;
                e_unsigned_mult <= d_unsigned_mult;
                e_hi_select     <= d_hi_select    ;
                e_lo_select     <= d_lo_select    ; 
                e_overflow_mask <= d_overflow_mask;
                // Register File
                e_rs_data <= d_rs_data;
                e_rt_data <= d_rt_data;
                // Immediate Sign Extention
                e_se_imm <= d_se_imm; 
            end
        end
    end    
endmodule