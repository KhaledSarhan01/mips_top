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
    // Fetch Stage
        // PC
        logic [1:0]  f_pcsrc;
        logic [31:0] f_regfile;
        logic [31:0] f_BTA,f_JTA;
        logic [31:0] f_pc_plus4;
        logic [31:0] f_pc;
        pc_reg u_fetch_pc(
            .clk(clk),
            .rst_n(rst_n),
            .pcsrc(f_pcsrc),
            .regfile(f_regfile),
            .BTA(f_BTA),
            .JTA(f_JTA),
            .pc_plus4(f_pc_plus4),
            .pc_next(f_pc) 
        ); 
        // Instruction Memory 
        logic [INSTR_WITDTH-1:0] f_instr;
        assign pc      = f_pc;
        assign f_instr = instr;
        // Fetch Decode Register
        logic [31:0] d_pc;
        logic [31:0] d_instr;
        logic [31:0] d_pc_plus4;
        always_ff @( posedge clk or negedge rst_n ) begin 
            if (!rst_n) begin
                d_pc       <= 'b0;
                d_instr    <= 'b0;
                d_pc_plus4 <= 'b0;
            end else begin
                d_pc       <= f_pc;
                d_instr    <= f_instr;
                d_pc_plus4 <= f_pc_plus4;
            end
        end
    // Decode Stage
        // Controller
        // Flags //TODO: Apply Early Flag Detection Here
        logic d_zero_flag;
        logic d_neg_flag;
        logic d_overflow_flag;
        // Controls
        logic                         d_memwrite     ;
        logic [2:0]                   d_imm_se_sel   ;
        logic [2:0]                   d_mem_se_sel   ;
        logic [1:0]                   d_pcsrc        ;
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
        mips_controller u_decode_controller(
            .clk(clk),
            .rst_n(rst_n),
            .instr(d_instr),
            // Flags
            .zero_flag(d_zero_flag),
            .neg_flag(d_neg_flag),
            .overflow_flag(d_overflow_flag),
            .arth_overflow_exception(arth_overflow_exception),
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

        // Register File
        // Read ports
        logic [31:0] d_rs_data;
        logic [31:0] d_rt_data;
        logic [4:0]  d_instr_rs,d_instr_rt;
        assign d_instr_rs = d_instr[25:21];
        assign d_instr_rt = d_instr[20:16];
        // Write port
        logic [4:0]  wb_addr;
        logic [31:0] wb_data;
        logic wb_regwrite;
        reg_file u_decode_regfile (
            .clk_n(clk),
            .rst_n(rst_n),
            .s0(s0),
            // Read port 1
            .read_addr1(d_instr_rs),
            .read_data1(d_rs_data),
            // Read port 2
            .read_addr2(d_instr_rt),    
            .read_data2(d_rt_data),
            // Write port
            .write_addr(wb_addr),
            .write_data(wb_data),
            .write_enable(wb_regwrite)
        );
        // Immediate Sign Extention
        logic [15:0] d_instr_imm;
        assign d_instr_imm = d_instr[15:0];
        logic [31:0] d_se_imm;
        sign_extended u_decsode_signExtent(
            .se_select(d_imm_se_sel),
            .in_data(d_instr_imm),
            .out_data(d_se_imm)
        );
        
        // JTA/BTA //TODO: Remove the pipeline from them for Early Flag Detection
        logic [31:0] d_JTA;
        logic [31:0] d_BTA;
        logic [25:0] d_instr_jaddress;
        assign d_instr_jaddress = d_instr[25:0];
        assign d_BTA = d_pc_plus4 + (d_se_imm << 2);            // Branch target
        assign d_JTA = {d_pc[31:28], d_instr_jaddress, 2'b00};  // Jump target
        
        // Decode Execute Register
        // Previous Stage
        logic [31:0]                  e_pc_plus4;
        logic [31:0]                  e_instr   ;
        // Controls
        logic                         e_memwrite     ;
        logic [2:0]                   e_mem_se_sel   ;
        logic [1:0]                   e_pcsrc        ;
        logic [ALU_SRC_WIDTH-1:0]     e_alusrc       ;
        logic [REG_WR_ADDR_WIDTH-1:0] e_regdst       ;
        logic                         e_regwrite     ;   
        logic [ALU_CTRL_WIDTH-1:0]    e_alucontrl    ;
        logic [REG_WR_SRC_WIDTH-1:0]  e_writeBack_sel;
        logic                         e_hi_write     ;
        logic                         e_lo_write     ;
        logic                         e_unsigned_div ;
        logic                         e_unsigned_mult;
        logic [HI_LO_SEL_WIDTH-1:0]   e_hi_select    ;
        logic [HI_LO_SEL_WIDTH-1:0]   e_lo_select    ;
        // JTA/BTA
        logic [31:0]                  e_JTA;
        logic [31:0]                  e_BTA;
        // Register File
        logic [31:0]                  e_rs_data;
        logic [31:0]                  e_rt_data;
        // Immediate Sign Extention
        logic [31:0]                  e_se_imm;
        always_ff @( posedge clk or negedge rst_n ) begin 
            if (!rst_n) begin
                // Previous Stage
                e_pc_plus4 <= 'b0;
                e_instr    <= 'b0;
                // Controls
                e_memwrite      <= 'b0;
                e_mem_se_sel    <= 'b0;
                e_pcsrc         <= 'b0;
                e_alusrc        <= 'b0;
                e_regdst        <= 'b0;
                e_regwrite      <= 'b0;   
                e_alucontrl     <= 'b0;
                e_writeBack_sel <= 'b0;
                e_hi_write      <= 'b0;
                e_lo_write      <= 'b0;
                e_unsigned_div  <= 'b0;
                e_unsigned_mult <= 'b0;
                e_hi_select     <= 'b0;
                e_lo_select     <= 'b0;
                // JTA/BTA
                e_JTA <='b0;
                e_BTA <='b0;
                // Register File
                e_rs_data <= 'b0;
                e_rt_data <= 'b0;
                // Immediate Sign Extention
                e_se_imm <= 'b0;
            end else begin
                // Previous Stage
                e_pc_plus4 <= d_pc_plus4;
                e_instr    <= d_instr   ;
                // Controls
                e_memwrite      <= d_memwrite     ;
                e_mem_se_sel    <= d_mem_se_sel   ;
                e_pcsrc         <= d_pcsrc        ;
                e_alusrc        <= d_alusrc       ;
                e_regdst        <= d_regdst       ;
                e_regwrite      <= d_regwrite     ;   
                e_alucontrl     <= d_alucontrl    ;
                e_writeBack_sel <= d_writeBack_sel;
                e_hi_write      <= d_hi_write     ;
                e_lo_write      <= d_lo_write     ;
                e_unsigned_div  <= d_unsigned_div ;
                e_unsigned_mult <= d_unsigned_mult;
                e_hi_select     <= d_hi_select    ;
                e_lo_select     <= d_lo_select    ;
                // JTA/BTA // TODO: Remove
                e_JTA <= d_JTA;
                e_BTA <= d_BTA;
                // Register File
                e_rs_data <= d_rs_data;
                e_rt_data <= d_rt_data;
                // Immediate Sign Extention
                e_se_imm <= d_se_imm;
            end
        end
    // Execute Stage
        // ALU
        // output result
        logic [31:0] e_alu_result;
        // Flag // NOTE: NOT USED
        logic e_zero_flag;
        logic e_overflow_flag;
        logic e_neg_flag;

        logic [4:0]  e_instr_shmat;
        assign e_instr_shmat = e_instr[10:6];

        logic [31:0] e_srcb;
        mux4 #(32) u_execute_srcbmux (   
            .in0(e_rt_data),
            .in1(e_se_imm),
            .in2('b0),
            .in3('b0), 
            .sel(e_alusrc),
            .out(e_srcb)
        );
        alu u_execute_alu(
            // input operands 
            .operand_a(e_rs_data),  // [rs]
            .operand_b(e_srcb),     // [rt] or signimm
            .shmat(e_instr_shmat),
            // ALU control signal
            .alu_control(e_alucontrl),
            // output result
            .alu_result(e_alu_result),
            // Flag 
            .zero_flag(e_zero_flag),
            .overflow_flag(e_overflow_flag),
            .neg_flag(e_neg_flag)
        );
        // Multipler/Divider
        logic [31:0] e_div_hi;
        logic [31:0] e_div_lo;
        logic [31:0] e_mult_hi;
        logic [31:0] e_mult_lo;
        multipler u_mips_datapath_mult(
            // input clk,rst_n
            .operand_a(e_rs_data),
            .operand_b(e_rt_data),
            .unsigned_mult(e_unsigned_mult),
            .out_hi(e_mult_hi),
            .out_lo(e_mult_lo)
        ); 
        divider u_mips_datapath_div(
           // input clk,rst_n,
           .operand_a(e_rs_data),
           .operand_b(e_rt_data),
           .unsigned_div(e_unsigned_div),
           .out_hi(e_div_hi),
           .out_lo(e_div_lo)
        ); 
        // assign div_hi = 'b0;
        // assign div_lo = 'b0;

        // Execute Memory Register
        // Previous Stage
        logic [31:0]  m_pc_plus4;
        logic [31:0]  m_instr   ;
        logic [31:0]  m_JTA     ;
        logic [31:0]  m_BTA     ;
        logic [31:0]  m_rs_data ;
        logic [31:0]  m_rt_data ;
        logic [31:0]  m_se_imm  ;
        // Controls
        logic                         m_memwrite     ;
        logic [2:0]                   m_mem_se_sel   ;
        logic [1:0]                   m_pcsrc        ;
        logic [REG_WR_ADDR_WIDTH-1:0] m_regdst       ;
        logic                         m_regwrite     ;
        logic [REG_WR_SRC_WIDTH-1:0]  m_writeBack_sel;
        logic                         m_hi_write     ;
        logic                         m_lo_write     ;
        logic [HI_LO_SEL_WIDTH-1:0]   m_hi_select    ;
        logic [HI_LO_SEL_WIDTH-1:0]   m_lo_select    ;
        // ALU
        logic [31:0] m_alu_result;
        // Multipler/Divider
        logic [31:0] m_div_hi ;
        logic [31:0] m_div_lo ;
        logic [31:0] m_mult_hi;
        logic [31:0] m_mult_lo;

        always_ff @( posedge clk or negedge rst_n) begin 
            if (!rst_n) begin
                // Previous Stage
                m_pc_plus4 <= 'b0;
                m_instr    <= 'b0;
                m_JTA      <= 'b0;
                m_BTA      <= 'b0;
                m_rs_data  <= 'b0;
                m_rt_data  <= 'b0;
                m_se_imm   <= 'b0;
                // Controls
                m_memwrite      <= 'b0;
                m_mem_se_sel    <= 'b0;
                m_pcsrc         <= 'b0;
                m_regdst        <= 'b0;
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
                // Previous Stage
                m_pc_plus4 <= e_pc_plus4;
                m_instr    <= e_instr   ;
                m_JTA      <= e_JTA     ;
                m_BTA      <= e_BTA     ;
                m_rs_data  <= e_rs_data ;
                m_rt_data  <= e_rt_data ;
                m_se_imm   <= e_se_imm  ;
                // Controls
                m_memwrite      <= e_memwrite     ;
                m_mem_se_sel    <= e_mem_se_sel   ;
                m_pcsrc         <= e_pcsrc        ;
                m_regdst        <= e_regdst       ;
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
    // Memory Stage
        // Data Memory
        logic [31:0] m_mem_data;
        assign memwrite  = m_memwrite;
        assign memaddr   = m_rt_data;
        assign writedata = m_alu_result;
        assign readdata  = m_mem_data;

        // Lo/Hi Register
        logic [31:0] wb_lo_reg,wb_hi_reg;
        lo_hi_reg u_mem_lo_hi_reg(
            // Clock and Active Low Reset
            .clk(clk),
            .rst_n(rst_n),
            // Inputs 
            .reg_file(m_rs_data),
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
        // Previous Stage
        logic [31:0]  wb_pc_plus4    ;
        logic [31:0]  wb_instr       ;
        logic [31:0]  wb_JTA         ;
        logic [31:0]  wb_BTA         ;
        logic [31:0]  wb_se_imm      ;
        logic [31:0]  wb_alu_result  ;
        logic [31:0]  wb_mult_lo     ;
        // Controls
        logic [1:0]                   wb_pcsrc        ;
        logic [REG_WR_ADDR_WIDTH-1:0] wb_regdst       ;
        logic [REG_WR_SRC_WIDTH-1:0]  wb_writeBack_sel;
        // Data Memory
        logic [31:0] wb_mem_data;
        // Memory Data Sign Extention
        logic [31:0] wb_mem_se_data;
        always_ff @( posedge clk or negedge rst_n ) begin 
            if (!rst_n) begin
                // Previous Stage
                wb_pc_plus4   <= 'b0;
                wb_instr      <= 'b0;
                wb_JTA        <= 'b0;
                wb_BTA        <= 'b0;
                wb_se_imm     <= 'b0;
                wb_alu_result <= 'b0;
                wb_mult_lo    <= 'b0;
                // Controls
                wb_pcsrc         <= 'b0;
                wb_regdst        <= 'b0;
                wb_regwrite      <= 'b0;
                wb_writeBack_sel <= 'b0;
                // Data Memory
                wb_mem_data      <= 'b0;
                // Memory Data Sign Extention
                wb_mem_se_data  <= 'b0;
            end else begin
                // Previous Stage
                wb_pc_plus4   <= m_pc_plus4  ;
                wb_instr      <= m_instr     ;
                wb_JTA        <= m_JTA       ;
                wb_BTA        <= m_BTA       ;
                wb_se_imm     <= m_se_imm    ;
                wb_alu_result <= m_alu_result;
                wb_mult_lo    <= m_mult_lo   ;
                // Controls
                wb_pcsrc         <= m_pcsrc        ;
                wb_regdst        <= m_regdst       ;
                wb_regwrite      <= m_regwrite     ;
                wb_writeBack_sel <= m_writeBack_sel;
                // Data Memory
                wb_mem_data      <= m_mem_data;
                // Memory Data Sign Extention
                wb_mem_se_data   <= m_mem_se_data;
            end
        end
    // Write Back Stage 
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
        // Write Back Address Source
        logic [4:0] wb_instr_rt,wb_instr_rd;
        assign wb_instr_rs = wb_instr[25:21];
        assign wb_instr_rt = wb_instr[20:16];
        mux4 #(5) u_mips_datapath_wrmux(
            .in0(wb_instr_rt), 
            .in1(wb_instr_rd),
            .in2(5'd31),
            .in3(5'd0),
            .sel(wb_regdst), 
            .out(wb_addr)
        );
        // Write Back to Fetch passing 
        assign f_JTA = wb_JTA;
        assign f_BTA = wb_BTA;
        assign f_pcsrc = wb_pcsrc;
        
endmodule