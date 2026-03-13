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
add wave -noupdate -group Fetch /tb_mips_top/u_mips_core/f_pcsrc
add wave -noupdate -group Fetch /tb_mips_top/u_mips_core/f_regfile
add wave -noupdate -group Fetch /tb_mips_top/u_mips_core/f_BTA
add wave -noupdate -group Fetch /tb_mips_top/u_mips_core/f_JTA
add wave -noupdate -group Fetch /tb_mips_top/u_mips_core/f_pc_plus4
add wave -noupdate -group Fetch /tb_mips_top/u_mips_core/f_pc
add wave -noupdate -group Fetch /tb_mips_top/u_mips_core/f_instr
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_pc
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_instr
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_pc_plus4
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_zero_flag
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_neg_flag
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_overflow_flag
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_memwrite
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_imm_se_sel
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_mem_se_sel
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_pcsrc
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_alusrc
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_regdst
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_regwrite
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_alucontrl
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_writeBack_sel
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_hi_write
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_lo_write
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_unsigned_div
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_unsigned_mult
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_hi_select
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_lo_select
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_rs_data
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_rt_data
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_instr_rs
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_instr_imm
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_se_imm
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_JTA
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_BTA
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_instr_rt
add wave -noupdate -group Decode /tb_mips_top/u_mips_core/d_instr_jaddress
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_pc_plus4
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_instr
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_memwrite
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_mem_se_sel
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_pcsrc
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_alusrc
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_regdst
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_regwrite
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_alucontrl
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_writeBack_sel
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_hi_write
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_lo_write
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_unsigned_div
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_unsigned_mult
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_hi_select
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_lo_select
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_JTA
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_BTA
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_rs_data
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_rt_data
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_se_imm
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_alu_result
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_zero_flag
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_overflow_flag
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_neg_flag
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_instr_shmat
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_srcb
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_div_hi
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_div_lo
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_mult_hi
add wave -noupdate -group Execute /tb_mips_top/u_mips_core/e_mult_lo
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_pc_plus4
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_instr
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_JTA
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_BTA
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_rs_data
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_rt_data
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_se_imm
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_memwrite
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_mem_se_sel
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_pcsrc
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_regdst
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_regwrite
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_writeBack_sel
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_hi_write
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_lo_write
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_hi_select
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_lo_select
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_alu_result
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_div_hi
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_div_lo
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_mult_hi
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_mult_lo
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_mem_data
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/wb_lo_reg
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/wb_hi_reg
add wave -noupdate -group Memory /tb_mips_top/u_mips_core/m_mem_se_data
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_addr
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_data
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_regwrite
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_pc_plus4
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_instr
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_JTA
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_BTA
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_se_imm
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_alu_result
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_mult_lo
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_pcsrc
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_regdst
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_writeBack_sel
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_mem_data
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_mem_se_data
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_instr_rt
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_instr_rd
add wave -noupdate -group {Write Back} /tb_mips_top/u_mips_core/wb_instr_rs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {176 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 200
configure wave -valuecolwidth 84
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
WaveRestoreZoom {0 ns} {907 ns}
