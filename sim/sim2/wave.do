onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mips_top/clk
add wave -noupdate /tb_mips_top/rst_n
add wave -noupdate /tb_mips_top/pc
add wave -noupdate /tb_mips_top/instr
add wave -noupdate /tb_mips_top/memwrite
add wave -noupdate /tb_mips_top/memaddr
add wave -noupdate /tb_mips_top/writedata
add wave -noupdate /tb_mips_top/readdata
add wave -noupdate /tb_mips_top/u_mips_core/arth_overflow_exception
add wave -noupdate -divider Instruction
add wave -noupdate /tb_mips_top/instr_opcode
add wave -noupdate /tb_mips_top/instr_funct
add wave -noupdate -radix unsigned /tb_mips_top/instr_rs
add wave -noupdate -radix unsigned /tb_mips_top/instr_rt
add wave -noupdate -radix unsigned /tb_mips_top/instr_rd
add wave -noupdate -radix unsigned /tb_mips_top/instr_shmat
add wave -noupdate /tb_mips_top/instr_imm
add wave -noupdate /tb_mips_top/instr_jaddr
add wave -noupdate -divider Register
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_lo_hi_reg/lo_reg
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_lo_hi_reg/hi_reg
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[31]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[30]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[29]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[28]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[27]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[26]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[25]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[24]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[23]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[22]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[21]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[20]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[19]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[18]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[17]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[16]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[15]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[14]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[13]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[12]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[11]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[10]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[9]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[8]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[7]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[6]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[5]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[4]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[3]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[2]}
add wave -noupdate -radix hexadecimal {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[1]}
add wave -noupdate -radix unsigned {/tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[0]}
add wave -noupdate -divider Controls
add wave -noupdate -radix binary /tb_mips_top/u_mips_core/u_mips_control/regwrite
add wave -noupdate -radix binary /tb_mips_top/u_mips_core/u_mips_control/regdst
add wave -noupdate -radix binary /tb_mips_top/u_mips_core/u_mips_control/alusrc
add wave -noupdate -radix binary /tb_mips_top/u_mips_core/u_mips_control/memwrite
add wave -noupdate -radix binary /tb_mips_top/u_mips_core/u_mips_control/write_back_sel
add wave -noupdate -radix binary /tb_mips_top/u_mips_core/u_mips_control/pcsrc
add wave -noupdate -radix binary /tb_mips_top/u_mips_core/u_mips_control/hi_write
add wave -noupdate -radix binary /tb_mips_top/u_mips_core/u_mips_control/lo_write
add wave -noupdate -radix binary /tb_mips_top/u_mips_core/u_mips_control/hi_select
add wave -noupdate -radix binary /tb_mips_top/u_mips_core/u_mips_control/lo_select
add wave -noupdate -radix binary /tb_mips_top/u_mips_core/u_mips_control/alucontrl
add wave -noupdate /tb_mips_top/u_mips_core/se_select
add wave -noupdate -divider Instance
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {350 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 189
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
WaveRestoreZoom {62 ns} {586 ns}
