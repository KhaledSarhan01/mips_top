import mips_pkg::*;
module hazard_unit (
    // inputs 
    input logic [31:0] d_instr,
    input logic [31:0] e_instr,
    input logic [31:0] m_instr,
    input logic [31:0] wb_instr,
    input logic       e_regwrite,
    input logic       m_regwrite,
    input logic       wb_regwrite,
    input logic [4:0] e_wbaddr,
    input logic [4:0] m_wbaddr,
    input logic [4:0] wb_addr,
    input logic [1:0] f_pcsrc,
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
// -------------------------------------------------------------------------
// 0. Instruction Decoding
// -------------------------------------------------------------------------
    // Decode 
        rfaddr_t d_rs,d_rt;
        opcode_t d_opcode;
        funct_t d_funct;
        immediate_t d_imm;
        assign d_opcode = opcode_t'(d_instr[31:26]);
        assign d_rs  = rfaddr_t'(d_instr[25:21]);
        assign d_rt  = rfaddr_t'(d_instr[20:16]);
        assign d_imm = immediate_t'(d_instr[15:0]);
        assign d_funct  = funct_t'(d_instr[5:0]);

        logic d_is_load;
        assign d_is_load  = (d_opcode == LW) |(d_opcode == LH) | (d_opcode == LB);
        logic d_is_jump_reg;
        assign d_is_jump_reg = (d_opcode == RType)&((d_funct == JR)|(d_funct == JALR));
        logic d_is_branch;
        assign d_is_branch = (d_opcode == BEQ  
                            | d_opcode == BNE 
                            | d_opcode == BLT_BGEZ
                            | d_opcode == BLEZ 
                            | d_opcode == BGTZ );
    // Execute
        opcode_t e_opcode;
        rfaddr_t e_rs,e_rt,e_rd;
        immediate_t e_imm;
        
        assign e_opcode = opcode_t'(e_instr[31:26]);
        assign e_rs  = rfaddr_t'(e_instr[25:21]);
        assign e_rt  = rfaddr_t'(e_instr[20:16]);
        assign e_rd  = rfaddr_t'(e_instr[15:11]);
        assign e_imm = immediate_t'(e_instr[15:0]);
            
        logic e_is_load,e_is_store;
        assign e_is_load  = (e_opcode == LW) |(e_opcode == LH) | (e_opcode == LB);
        assign e_is_store = (e_opcode == Sw) |(e_opcode == SH) | (e_opcode == SB);
    // Memory Stage
        opcode_t m_opcode;
        funct_t  m_funct;
        rfaddr_t m_rt;
        assign m_rt     = rfaddr_t'(m_instr[20:16]);
        assign m_opcode = opcode_t'(m_instr[31:26]);
        assign m_funct  = funct_t'(m_instr[5:0]);

        logic m_is_mult,m_is_lui,m_is_load;
        assign m_is_mult = ((m_opcode == RType)&((m_funct == MULT)|(m_opcode == MULTU)))|(m_opcode == MUL);
        assign m_is_lui  = (m_opcode == LUI);
        assign m_is_load = (m_opcode == LW)|(m_opcode == LB)|(m_opcode == LH);

    // Write Back
        opcode_t wb_opcode; 
        assign wb_opcode = opcode_t'(wb_instr[31:26]); 

        logic wb_is_load;
        assign wb_is_load = (wb_opcode == LB) | (wb_opcode == LH) | (wb_opcode == LW);

/* --------------------------------------------------------------------------
    1. CORE BYPASS LOGIC FUNCTION
    This function implements your 3-bit mapping for D and E stages:
    0: RegFile | 1: M_ALU | 2: M_MULT | 3: M_IMM | 4: WB_MEM | 5: WB_DATA
    -------------------------------------------------------------------------- */

    // rt Decode
    always_comb begin   
        // Priority 1: Memory Stage (M) - The most recent producer
        if ((d_rt == m_wbaddr)&& m_regwrite && (d_rt != 'b0)) begin
            if(m_is_mult) begin
                bypass_decode_rt_sel = 3'b010; // Table index 2: m_mult_lo
            end else if(m_is_lui)begin
                bypass_decode_rt_sel = 3'b011; // Table index 3: m_se_imm
            end else begin
                bypass_decode_rt_sel = 3'b001; // Table index 1: m_alu_result
            end 
        end else if ((d_rt == wb_addr)&& wb_regwrite && (d_rt != 'b0)) begin
            if (wb_is_load) begin
                bypass_decode_rt_sel = 3'b100; // Table index 4: wb_mem_data
            end else begin
                bypass_decode_rt_sel = 3'b101; // Table index 5: wb_data        
            end
        end else begin
            bypass_decode_rt_sel = 3'b000; // Default
        end 
    end
    // rs Decode 
    always_comb begin   
        // Priority 1: Memory Stage (M) - The most recent producer
        if ((d_rs == m_wbaddr)&& m_regwrite && (d_rs != 'b0)) begin
            if(m_is_mult) begin
                bypass_decode_rs_sel = 3'b010; // Table index 2: m_mult_lo
            end else if(m_is_lui)begin
                bypass_decode_rs_sel = 3'b011; // Table index 3: m_se_imm
            end else begin
                bypass_decode_rs_sel = 3'b001; // Table index 1: m_alu_result
            end 
        end else if ((d_rs == wb_addr)&& wb_regwrite && (d_rs != 'b0)) begin
            if (wb_is_load) begin
                bypass_decode_rs_sel = 3'b100; // Table index 4: wb_mem_data
            end else begin
                bypass_decode_rs_sel = 3'b101; // Table index 5: wb_data        
            end
        end else begin
            bypass_decode_rs_sel = 3'b000; // Default
        end 
    end
    // rt execute
    always_comb begin   
        // Priority 1: Memory Stage (M) - The most recent producer
        if ((e_rt == m_wbaddr)&& m_regwrite && (e_rt != 'b0)) begin
            if(m_is_mult) begin
                bypass_execute_rt_sel = 3'b010; // Table index 2: m_mult_lo
            end else if(m_is_lui)begin
                bypass_execute_rt_sel = 3'b011; // Table index 3: m_se_imm
            end else begin
                bypass_execute_rt_sel = 3'b001; // Table index 1: m_alu_result
            end 
        end else if ((e_rt == wb_addr)&& wb_regwrite && (e_rt != 'b0)) begin
            if (wb_is_load) begin
                bypass_execute_rt_sel = 3'b100; // Table index 4: wb_mem_data
            end else begin
                bypass_execute_rt_sel = 3'b101; // Table index 5: wb_data        
            end
        end else begin
            bypass_execute_rt_sel = 3'b000; // Default
        end 
    end
    // rs Execute 
    always_comb begin   
        // Priority 1: Memory Stage (M) - The most recent producer
        if ((e_rs == m_wbaddr)&& m_regwrite && (e_rs != 'b0)) begin
            if(m_is_mult) begin
                bypass_execute_rs_sel = 3'b010; // Table index 2: m_mult_lo
            end else if(m_is_lui)begin
                bypass_execute_rs_sel = 3'b011; // Table index 3: m_se_imm
            end else begin
                bypass_execute_rs_sel = 3'b001; // Table index 1: m_alu_result
            end 
        end else if ((e_rs == wb_addr)&& wb_regwrite && (e_rs != 'b0)) begin
            if (wb_is_load) begin
                bypass_execute_rs_sel = 3'b100; // Table index 4: wb_mem_data
            end else begin
                bypass_execute_rs_sel = 3'b101; // Table index 5: wb_data        
            end
        end else begin
            bypass_execute_rs_sel = 3'b000; // Default
        end 
    end
/* --------------------------------------------------------------------------
    2. MEMORY STAGE BYPASS (2-bit Table)
    0: m_data_e2m | 1: wb_mem_data | 2: wb_data
    -------------------------------------------------------------------------- */
    assign bypass_mem_rs_sel = (e_rs != 0 && e_rs == wb_addr && wb_regwrite) ? 
                               (wb_is_load ? 2'b01 : 2'b10) : 2'b00;

    assign bypass_mem_rt_sel = (e_rt != 0 && e_rt == wb_addr && wb_regwrite) ? 
                               (wb_is_load ? 2'b01 : 2'b10) : 2'b00;


/* --------------------------------------------------------------------------
    3. STALLS
    -------------------------------------------------------------------------- */
    // --- Jump Register Hazard --- 
    // Since Jump Register is resolved in Decode Stage
    // So The register shouldn't be resolved in the pipeline
    logic jump_reg_stall;
    assign jump_reg_stall = d_is_jump_reg & ((d_rs == e_wbaddr) | (d_rs == m_wbaddr) | (d_rs == wb_addr)) &(d_rs != 0)&(d_rt != 0);
    
    // --- Execute Branch Hazard ---
    // Occurs when Branch instruction is in D and its targets 
    // is Computed in E so the data must be stalled to let be bypassed in M
    logic branch_stall_target_at_execute;
    assign branch_stall_target_at_execute = d_is_branch & (e_wbaddr == d_rs | e_wbaddr == d_rt) &(e_wbaddr != 0);
    
    // --- Memory Branch Hazard ---
    // Occurs when Branch instruction is in D and its targets 
    // is Computed in M so the data must be stalled to let be bypassed in wb
    logic branch_stall_target_at_memory;
    assign branch_stall_target_at_memory = d_is_branch & m_is_load & (m_rt == d_rs | m_rt == d_rt) &(m_rt != 0);
    
    // --- Load-Use Hazard ---
    // Occurs when a Load is in E and its target is used in D. 
    // Data is only available at the end of M, so D must stall.
    logic lw_stall_used_execute;
    assign lw_stall_used_execute = e_is_load & ((e_rd == d_rs) | (e_rd == d_rt)) &(e_rd != 0);
    
    // --- Store-Load Hazard ---
    // Corner Case Solution: Storing then loading from the same address
    // This corner case happens when loading and storing happens on the same address.
    // Solution Stall until the Storing Finish.
    logic lw_stall_sw_same_addr;  
    assign lw_stall_sw_same_addr = e_is_store & d_is_load & (d_imm == e_imm);
    

    // Drive Stall Signals
    logic lw_stall,branch_stall;
    assign lw_stall     = lw_stall_sw_same_addr 
                        | lw_stall_used_execute;
    
    assign branch_stall = branch_stall_target_at_execute 
                        | branch_stall_target_at_memory;

    assign pc_stall  = lw_stall | branch_stall | jump_reg_stall;
    assign f2d_stall = lw_stall | branch_stall | jump_reg_stall;

// -------------------------------------------------------------------------
// 4. FLUSHES
// -------------------------------------------------------------------------    
    // Drive Flush Signals
    // If we stall D, we must flush E to insert a bubble.
    // If we take a jump in D, we must flush F2D to clear the next instruction.
    logic jump_taken;
    assign jump_taken = (f_pcsrc != 0) & ~jump_reg_stall & ~branch_stall; // then there is change in Control

    assign d2e_flush = lw_stall | branch_stall | jump_taken; // Create a bubble of NOPs until the Control instruction is complete 
    assign f2d_flush = jump_taken;                           // Flush the old instruction  

// -------------------------------------------------------------------------
// 5. UNUSED STALLS/FLUSHES
// -------------------------------------------------------------------------
    assign d2e_stall  = 1'b0;
    assign e2m_stall  = 1'b0;
    assign e2m_flush  = 1'b0;
    assign m2wb_stall = 1'b0;
    assign m2wb_flush = 1'b0;

endmodule