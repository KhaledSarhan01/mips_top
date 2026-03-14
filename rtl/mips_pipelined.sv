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
/*
    TODO: 
    1. Hazard Unit
        -[] List All instruction and see what can be hazardous in each type.
             This is done by knowing 
                what stages are used in each instruction 
                how it affects the pipeline
        -[x] Create Stall Signal in PC 
        -[x] Create Stall/ Flush Signals in f2d,d2e,e2m,m2wb registers
        -[] Create Bypass in Execute Stage for rs_data/rt_data
        -[] Create Bypass in Decode Stage for rs_data/rt_data
        -[] Create Hazard Unit to control Hazard Signals 
    2. Early Branch Detection:
        -[x] Create Early Branch Detection for Branch Instructions 
        -[] Decide what to do in each Jump instruction.
        -[x] Do Necessary Modifications on the pipeline "pcsrc/JTA/BTA"
    - [x] remove overflow computation from decode stage into execute stage 
        - only output overflow_mask from controller
    - [] Test the Pipeline by running Tests 1..5    
*/
// Hazard Unit
    logic pc_stall;
    assign pc_stall = 1'b0;

    logic f2d_stall,f2d_flush;
    assign f2d_stall = 1'b0;
    assign f2d_flush = 1'b0;

    logic d2e_stall,d2e_flush;
    assign d2e_stall = 1'b0;
    assign d2e_flush = 1'b0;

    logic e2m_stall,e2m_flush;
    assign e2m_stall = 1'b0;
    assign e2m_flush = 1'b0;

    logic m2wb_stall,m2wb_flush;
    assign m2wb_stall = 1'b0;
    assign m2wb_flush = 1'b0;
    
// Main Pipeline
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
                .pc_stall(pc_stall),
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
                    if(f2d_flush)begin
                        d_pc       <= 'b0;
                        d_instr    <= 'b0;
                        d_pc_plus4 <= 'b0;
                    end else if(~f2d_stall)begin
                        d_pc       <= f_pc;
                        d_instr    <= f_instr;
                        d_pc_plus4 <= f_pc_plus4; 
                    end
                end
            end
    // Decode Stage
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
        // Early Branch Detection
            logic    d_zero_flag;
            logic    d_neg_flag;
            opcode_t d_instr_casted;
            assign d_instr_casted = opcode_t'(d_instr);
            
            logic  rs_equal_rt, rs_equal_zero,rs_less_zero;
            assign rs_equal_rt   = (d_rs_data == d_rt_data);
            assign rs_equal_zero = ~|(d_rs_data);
            assign rs_less_zero  = (d_rs_data[31]);
            always_comb begin 
                d_zero_flag     = 'b0;
                d_neg_flag      = 'b0;
                case (d_instr_casted)
                    BEQ,BNE: d_zero_flag = rs_equal_rt;
                    BLT_BGEZ,BLEZ,BGTZ:begin
                        d_zero_flag     = rs_equal_zero;
                        d_neg_flag      = rs_less_zero;
                    end 
                    default:begin
                        d_zero_flag     = 'b0;
                        d_neg_flag      = 'b0;
                    end 
                endcase
            end
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
            logic                         e_overflow_mask;
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
                        e_overflow_mask <= 'b0;
                        // Register File
                        e_rs_data <= 'b0;
                        e_rt_data <= 'b0;
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
                        e_overflow_mask <= d_overflow_mask;
                        // Register File
                        e_rs_data <= d_rs_data;
                        e_rt_data <= d_rt_data;
                        // Immediate Sign Extention
                        e_se_imm <= d_se_imm; 
                    end
                end
            end
    // Execute Stage
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
                .in0(e_rt_data),
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
                .operand_a(e_rs_data),  // [rs]
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
                .operand_a(e_rs_data),
                .operand_b(e_rt_data),
                .unsigned_mult(e_unsigned_mult),
                .out_hi(e_mult_hi),
                .out_lo(e_mult_lo)
            ); 
            divider u_excute_div(
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
            logic [31:0]  m_rs_data ;
            logic [31:0]  m_rt_data ;
            logic [31:0]  m_se_imm  ;
            // Controls
            logic                         m_memwrite     ;
            logic [2:0]                   m_mem_se_sel   ;
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
                    m_rs_data  <= 'b0;
                    m_rt_data  <= 'b0;
                    m_se_imm   <= 'b0;
                    // Controls
                    m_memwrite      <= 'b0;
                    m_mem_se_sel    <= 'b0;
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
                    end else if(~e2m_stall)begin
                        // Previous Stage
                        m_pc_plus4 <= e_pc_plus4;
                        m_instr    <= e_instr   ;
                        m_rs_data  <= e_rs_data ;
                        m_rt_data  <= e_rt_data ;
                        m_se_imm   <= e_se_imm  ;
                        // Controls
                        m_memwrite      <= e_memwrite     ;
                        m_mem_se_sel    <= e_mem_se_sel   ;
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
            logic [31:0]  wb_se_imm      ;
            logic [31:0]  wb_alu_result  ;
            logic [31:0]  wb_mult_lo     ;
            // Controls
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
                    wb_se_imm     <= 'b0;
                    wb_alu_result <= 'b0;
                    wb_mult_lo    <= 'b0;
                    // Controls
                    wb_regdst        <= 'b0;
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
                        wb_regdst        <= 'b0;
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
                        wb_regdst        <= m_regdst       ;
                        wb_regwrite      <= m_regwrite     ;
                        wb_writeBack_sel <= m_writeBack_sel;
                        // Data Memory
                        wb_mem_data      <= m_mem_data;
                        // Memory Data Sign Extention
                        wb_mem_se_data   <= m_mem_se_data;    
                    end
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
        mux4 #(5) u_WriteBack_addrmux(
            .in0(wb_instr_rt), 
            .in1(wb_instr_rd),
            .in2(5'd31),
            .in3(5'd0),
            .sel(wb_regdst), 
            .out(wb_addr)
        );
        // Write Back to Fetch passing 
        assign f_JTA   = d_JTA;
        assign f_BTA   = d_BTA;
        assign f_pcsrc = d_pcsrc;
        
endmodule