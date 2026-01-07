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
add wave -noupdate -divider Instruction
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_control/instr_opcode
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_control/instr_funct
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_datapath/instr_rs
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_datapath/instr_rt
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_datapath/instr_rd
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_datapath/instr_imm
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_datapath/instr_shmat
add wave -noupdate -divider Controls
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_control/regdst
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_control/regwrite
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_control/alusrc
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_control/memwrite
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_control/memtoreg
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_control/jump
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_control/alucontrl
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_control/branch
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_control/aluop
add wave -noupdate -divider Register
add wave -noupdate /tb_mips_top/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25 ns} 0}
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
WaveRestoreZoom {0 ns} {154 ns}
