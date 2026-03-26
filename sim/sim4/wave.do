onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix ascii /tb_mips_top/test_name
add wave -noupdate /tb_mips_top/clk
add wave -noupdate /tb_mips_top/rst_n
add wave -noupdate /tb_mips_top/pc
add wave -noupdate /tb_mips_top/instr
add wave -noupdate /tb_mips_top/arth_overflow_exception
add wave -noupdate /tb_mips_top/memwrite
add wave -noupdate /tb_mips_top/memaddr
add wave -noupdate /tb_mips_top/writedata
add wave -noupdate /tb_mips_top/readdata
add wave -noupdate -divider Internals
add wave -noupdate -expand -group Fetch -divider Instruction
add wave -noupdate -expand -group Fetch /tb_mips_top/u_mips_core/u_mips_fetch_stage/f2d_flush
add wave -noupdate -expand -group Fetch /tb_mips_top/u_mips_core/u_mips_fetch_stage/pc_stall
add wave -noupdate -expand -group Fetch /tb_mips_top/u_mips_core/u_mips_fetch_stage/f2d_stall
add wave -noupdate -expand -group Fetch /tb_mips_top/f_opcode
add wave -noupdate -expand -group Fetch /tb_mips_top/f_funct
add wave -noupdate -expand -group Fetch /tb_mips_top/f_rs
add wave -noupdate -expand -group Fetch /tb_mips_top/f_rt
add wave -noupdate -expand -group Fetch /tb_mips_top/f_rd
add wave -noupdate -expand -group Fetch /tb_mips_top/f_shmat
add wave -noupdate -expand -group Fetch /tb_mips_top/f_imm
add wave -noupdate -expand -group Fetch /tb_mips_top/f_jaddr
add wave -noupdate -expand -group Fetch -divider Signals
add wave -noupdate -expand -group Fetch -group .9 /tb_mips_top/u_mips_core/u_mips_fetch_stage/instr
add wave -noupdate -expand -group Fetch -group .9 /tb_mips_top/u_mips_core/u_mips_fetch_stage/f_pcsrc
add wave -noupdate -expand -group Fetch -group .9 /tb_mips_top/u_mips_core/u_mips_fetch_stage/f_regfile
add wave -noupdate -expand -group Fetch -group .9 /tb_mips_top/u_mips_core/u_mips_fetch_stage/f_BTA
add wave -noupdate -expand -group Fetch -group .9 /tb_mips_top/u_mips_core/u_mips_fetch_stage/f_JTA
add wave -noupdate -expand -group Fetch -group .9 /tb_mips_top/u_mips_core/u_mips_fetch_stage/d_pc
add wave -noupdate -expand -group Fetch -group .9 /tb_mips_top/u_mips_core/u_mips_fetch_stage/d_instr
add wave -noupdate -expand -group Fetch -group .9 /tb_mips_top/u_mips_core/u_mips_fetch_stage/d_pc_plus4
add wave -noupdate -expand -group Decode -divider Instruction
add wave -noupdate -expand -group Decode /tb_mips_top/u_mips_core/u_mips_decode_stage/d2e_flush
add wave -noupdate -expand -group Decode /tb_mips_top/u_mips_core/u_mips_fetch_stage/f2d_stall
add wave -noupdate -expand -group Decode /tb_mips_top/d_opcode
add wave -noupdate -expand -group Decode /tb_mips_top/d_funct
add wave -noupdate -expand -group Decode -radix unsigned /tb_mips_top/d_rs
add wave -noupdate -expand -group Decode -radix unsigned /tb_mips_top/d_rt
add wave -noupdate -expand -group Decode -radix unsigned /tb_mips_top/d_rd
add wave -noupdate -expand -group Decode -radix unsigned /tb_mips_top/d_shmat
add wave -noupdate -expand -group Decode /tb_mips_top/d_jaddr
add wave -noupdate -expand -group Decode /tb_mips_top/d_imm
add wave -noupdate -expand -group Decode -divider Bypass
add wave -noupdate -expand -group Decode -expand -group .0 /tb_mips_top/u_mips_core/u_mips_decode_stage/d_rs_data
add wave -noupdate -expand -group Decode -expand -group .0 /tb_mips_top/u_mips_core/u_mips_decode_stage/d_rt_data
add wave -noupdate -expand -group Decode -expand -group .0 /tb_mips_top/u_mips_core/u_mips_decode_stage/bypass_decode_rs_sel
add wave -noupdate -expand -group Decode -expand -group .0 /tb_mips_top/u_mips_core/u_mips_decode_stage/bypass_decode_rt_sel
add wave -noupdate -expand -group Decode -expand -group .0 /tb_mips_top/u_mips_core/u_mips_decode_stage/d_rs_data_regfile
add wave -noupdate -expand -group Decode -expand -group .0 /tb_mips_top/u_mips_core/u_mips_decode_stage/d_rt_data_regfile
add wave -noupdate -expand -group Decode -expand -group .0 /tb_mips_top/u_mips_core/u_mips_decode_stage/m_alu_result
add wave -noupdate -expand -group Decode -expand -group .0 /tb_mips_top/u_mips_core/u_mips_decode_stage/m_mult_lo
add wave -noupdate -expand -group Decode -expand -group .0 /tb_mips_top/u_mips_core/u_mips_decode_stage/m_se_imm
add wave -noupdate -expand -group Decode -expand -group .0 /tb_mips_top/u_mips_core/u_mips_decode_stage/wb_mem_data
add wave -noupdate -expand -group Decode -expand -group .0 /tb_mips_top/u_mips_core/u_mips_decode_stage/wb_data
add wave -noupdate -expand -group Decode -divider Controls
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_zero_flag
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_neg_flag
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_regwrite
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_regdst
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_alusrc
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_memwrite
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_alucontrl
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_writeBack_sel
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_mem_se_sel
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_imm_se_sel
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_pcsrc
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_hi_write
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_lo_write
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_unsigned_div
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_unsigned_mult
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_hi_select
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_lo_select
add wave -noupdate -expand -group Decode -group . /tb_mips_top/u_mips_core/u_mips_decode_stage/d_overflow_mask
add wave -noupdate -expand -group Decode -divider signals
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/e_pc_plus4
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/e_instr
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/e_overflow_mask
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/e_rs_data
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/e_rt_data
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/e_se_imm
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/d_JTA
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/d_BTA
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/d_regfile
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/d_instr_rs
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/d_instr_rt
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/ra_handle
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/d_instr_imm
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/d_se_imm
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/d_instr_jaddress
add wave -noupdate -expand -group Decode -group .1 /tb_mips_top/u_mips_core/u_mips_decode_stage/d_pc
add wave -noupdate -group Execute -divider Instruction
add wave -noupdate -group Execute /tb_mips_top/e_opcode
add wave -noupdate -group Execute /tb_mips_top/e_funct
add wave -noupdate -group Execute /tb_mips_top/e_rs
add wave -noupdate -group Execute -radix unsigned /tb_mips_top/e_rt
add wave -noupdate -group Execute -radix unsigned /tb_mips_top/e_rd
add wave -noupdate -group Execute -radix unsigned /tb_mips_top/e_shmat
add wave -noupdate -group Execute /tb_mips_top/e_imm
add wave -noupdate -group Execute /tb_mips_top/e_jaddr
add wave -noupdate -group Execute -divider Signal
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/arth_overflow_exception
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_alu_result
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_memwrite
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_mem_se_sel
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_alusrc
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_regwrite
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_alucontrl
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_writeBack_sel
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_hi_write
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_lo_write
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_unsigned_div
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_unsigned_mult
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_hi_select
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_lo_select
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_overflow_mask
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_se_imm
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_instr_shmat
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_srcb
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_div_hi
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_div_lo
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_mult_hi
add wave -noupdate -group Execute -expand -group .2 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_mult_lo
add wave -noupdate -group Execute -divider Bypass
add wave -noupdate -group Execute -group .3 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_rs_data_bypass
add wave -noupdate -group Execute -group .3 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_rt_data_bypass
add wave -noupdate -group Execute -group .3 /tb_mips_top/u_mips_core/u_mips_execute_stage/bypass_execute_rs_sel
add wave -noupdate -group Execute -group .3 /tb_mips_top/u_mips_core/u_mips_execute_stage/bypass_execute_rt_sel
add wave -noupdate -group Execute -group .3 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_rs_data
add wave -noupdate -group Execute -group .3 /tb_mips_top/u_mips_core/u_mips_execute_stage/e_rt_data
add wave -noupdate -group Execute -group .3 /tb_mips_top/u_mips_core/u_mips_decode_stage/wb_mem_data
add wave -noupdate -group Execute -group .3 /tb_mips_top/u_mips_core/u_mips_decode_stage/m_se_imm
add wave -noupdate -group Execute -group .3 /tb_mips_top/u_mips_core/u_mips_decode_stage/m_mult_lo
add wave -noupdate -group Execute -group .3 /tb_mips_top/u_mips_core/u_mips_decode_stage/m_alu_result
add wave -noupdate -group Execute -group .3 /tb_mips_top/u_mips_core/u_mips_decode_stage/wb_data
add wave -noupdate -group Memory -divider Instruction
add wave -noupdate -group Memory /tb_mips_top/m_opcode
add wave -noupdate -group Memory /tb_mips_top/m_funct
add wave -noupdate -group Memory /tb_mips_top/m_rs
add wave -noupdate -group Memory /tb_mips_top/m_rt
add wave -noupdate -group Memory /tb_mips_top/m_rd
add wave -noupdate -group Memory /tb_mips_top/m_shmat
add wave -noupdate -group Memory /tb_mips_top/m_imm
add wave -noupdate -group Memory /tb_mips_top/m_jaddr
add wave -noupdate -group Memory -divider Signals
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/memwrite
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/writedata
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/memaddr
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/readdata
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_pc_plus4
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_instr
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_alu_result
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_se_imm
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_memwrite
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_mem_se_sel
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_regwrite
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_writeBack_sel
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_hi_write
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_lo_write
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_hi_select
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_lo_select
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_div_hi
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_div_lo
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_mult_hi
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_mult_lo
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_mem_data
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/wb_hi_reg
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/wb_lo_reg
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/wb_pc_plus4
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/wb_instr
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/wb_se_imm
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/wb_alu_result
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/wb_mult_lo
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/wb_regwrite
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/wb_writeBack_sel
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/wb_mem_se_data
add wave -noupdate -group Memory -group .4 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_mem_se_data
add wave -noupdate -group Memory -divider bypass
add wave -noupdate -group Memory -group 5 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_rs_data_bypass
add wave -noupdate -group Memory -group 5 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_rt_data_bypass
add wave -noupdate -group Memory -group 5 /tb_mips_top/u_mips_core/u_mips_memory_stage/bypass_mem_rs_sel
add wave -noupdate -group Memory -group 5 /tb_mips_top/u_mips_core/u_mips_memory_stage/bypass_mem_rt_sel
add wave -noupdate -group Memory -group 5 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_rs_data
add wave -noupdate -group Memory -group 5 /tb_mips_top/u_mips_core/u_mips_memory_stage/m_rt_data
add wave -noupdate -group Memory -group 5 /tb_mips_top/u_mips_core/u_mips_memory_stage/wb_mem_data
add wave -noupdate -group Memory -group 5 /tb_mips_top/u_mips_core/u_mips_memory_stage/wb_data
add wave -noupdate -group {Write Back} -divider Instruction
add wave -noupdate -group {Write Back} /tb_mips_top/wb_opcode
add wave -noupdate -group {Write Back} /tb_mips_top/wb_funct
add wave -noupdate -group {Write Back} -radix unsigned /tb_mips_top/wb_rs
add wave -noupdate -group {Write Back} -radix unsigned /tb_mips_top/wb_rt
add wave -noupdate -group {Write Back} -radix unsigned /tb_mips_top/wb_rd
add wave -noupdate -group {Write Back} /tb_mips_top/wb_shmat
add wave -noupdate -group {Write Back} /tb_mips_top/wb_imm
add wave -noupdate -group {Write Back} /tb_mips_top/wb_jaddr
add wave -noupdate -group {Write Back} -divider Signal
add wave -noupdate -group {Write Back} -group .6 /tb_mips_top/u_mips_core/u_mips_memory_stage/wb_regwrite
add wave -noupdate -group {Write Back} -group .6 /tb_mips_top/u_mips_core/u_mips_hazard_unit/wb_addr
add wave -noupdate -group {Write Back} -group .6 /tb_mips_top/u_mips_core/u_mips_writeBack_stage/wb_alu_result
add wave -noupdate -group {Write Back} -group .6 /tb_mips_top/u_mips_core/u_mips_writeBack_stage/wb_mem_data
add wave -noupdate -group {Write Back} -group .6 /tb_mips_top/u_mips_core/u_mips_writeBack_stage/wb_hi_reg
add wave -noupdate -group {Write Back} -group .6 /tb_mips_top/u_mips_core/u_mips_writeBack_stage/wb_lo_reg
add wave -noupdate -group {Write Back} -group .6 /tb_mips_top/u_mips_core/u_mips_writeBack_stage/wb_pc_plus4
add wave -noupdate -group {Write Back} -group .6 /tb_mips_top/u_mips_core/u_mips_writeBack_stage/wb_instr
add wave -noupdate -group {Write Back} -group .6 /tb_mips_top/u_mips_core/u_mips_writeBack_stage/wb_se_imm
add wave -noupdate -group {Write Back} -group .6 /tb_mips_top/u_mips_core/u_mips_writeBack_stage/wb_mult_lo
add wave -noupdate -group {Write Back} -group .6 /tb_mips_top/u_mips_core/u_mips_writeBack_stage/wb_writeBack_sel
add wave -noupdate -group {Write Back} -group .6 /tb_mips_top/u_mips_core/u_mips_writeBack_stage/wb_mem_se_data
add wave -noupdate -group {Write Back} -group .6 -radix hexadecimal /tb_mips_top/u_mips_core/u_mips_writeBack_stage/wb_data
add wave -noupdate -divider {Hazard Unit}
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/d_opcode
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/d_funct
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/e_opcode
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/m_opcode
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/m_funct
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/wb_opcode
add wave -noupdate -expand -group {Hazard Unit} -divider Flags
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/e_regwrite
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/m_regwrite
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/wb_regwrite
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/branch_used
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/f_pcsrc
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/d_is_load
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/d_is_jump_reg
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/e_is_load
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/e_is_store
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/m_is_mult
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/m_is_lui
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/m_is_load
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/wb_is_load
add wave -noupdate -expand -group {Hazard Unit} -divider Address
add wave -noupdate -expand -group {Hazard Unit} -radix unsigned /tb_mips_top/u_mips_core/u_mips_hazard_unit/d_rs
add wave -noupdate -expand -group {Hazard Unit} -radix unsigned /tb_mips_top/u_mips_core/u_mips_hazard_unit/d_rt
add wave -noupdate -expand -group {Hazard Unit} -radix unsigned /tb_mips_top/u_mips_core/u_mips_hazard_unit/d_imm
add wave -noupdate -expand -group {Hazard Unit} -radix unsigned /tb_mips_top/u_mips_core/u_mips_hazard_unit/e_rs
add wave -noupdate -expand -group {Hazard Unit} -radix unsigned /tb_mips_top/u_mips_core/u_mips_hazard_unit/e_rt
add wave -noupdate -expand -group {Hazard Unit} -radix unsigned /tb_mips_top/u_mips_core/u_mips_hazard_unit/e_rd
add wave -noupdate -expand -group {Hazard Unit} -radix unsigned /tb_mips_top/u_mips_core/u_mips_hazard_unit/m_rt
add wave -noupdate -expand -group {Hazard Unit} -radix unsigned /tb_mips_top/u_mips_core/u_mips_hazard_unit/e_imm
add wave -noupdate -expand -group {Hazard Unit} -radix unsigned /tb_mips_top/u_mips_core/u_mips_hazard_unit/e_wbaddr
add wave -noupdate -expand -group {Hazard Unit} -radix unsigned /tb_mips_top/u_mips_core/u_mips_hazard_unit/m_wbaddr
add wave -noupdate -expand -group {Hazard Unit} -radix unsigned /tb_mips_top/u_mips_core/u_mips_hazard_unit/wb_addr
add wave -noupdate -expand -group {Hazard Unit} -divider Output
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/pc_stall
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/f2d_stall
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/f2d_flush
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/d2e_stall
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/d2e_flush
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/e2m_stall
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/e2m_flush
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/m2wb_stall
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/m2wb_flush
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/bypass_decode_rs_sel
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/bypass_decode_rt_sel
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/bypass_execute_rs_sel
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/bypass_execute_rt_sel
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/bypass_mem_rs_sel
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/bypass_mem_rt_sel
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/jump_reg_stall
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/branch_stall_target_at_execute
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/branch_stall_target_at_memory
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/lw_stall_used_execute
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/lw_stall_sw_same_addr
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/lw_stall
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/branch_stall
add wave -noupdate -expand -group {Hazard Unit} /tb_mips_top/u_mips_core/u_mips_hazard_unit/jump_taken
add wave -noupdate -divider Registers
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[31]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[30]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[29]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[28]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[27]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[26]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[25]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[24]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[23]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[22]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[21]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[20]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[19]}
add wave -noupdate -group {Register File} -radix unsigned {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[18]}
add wave -noupdate -group {Register File} -radix unsigned {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[17]}
add wave -noupdate -group {Register File} -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[16]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[15]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[14]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[13]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[12]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[11]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[10]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[9]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[8]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[7]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[6]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[5]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[4]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[3]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[2]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[1]}
add wave -noupdate -group {Register File} {/tb_mips_top/u_mips_core/u_mips_decode_stage/u_decode_regfile/registers[0]}
add wave -noupdate -group {Hi/Lo Registers} /tb_mips_top/u_mips_core/u_mips_memory_stage/u_mem_lo_hi_reg/lo_reg
add wave -noupdate -group {Hi/Lo Registers} /tb_mips_top/u_mips_core/u_mips_memory_stage/u_mem_lo_hi_reg/hi_reg
add wave -noupdate -group {Hi/Lo Registers} -divider Internals
add wave -noupdate -divider Internals
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {445 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 191
configure wave -valuecolwidth 101
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {409 ns} {464 ns}
