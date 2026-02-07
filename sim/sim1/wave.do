onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mips_top/clk
add wave -noupdate /tb_mips_top/rst_n
add wave -noupdate /tb_mips_top/DUT/pc
add wave -noupdate -divider Instruction
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_control/instr_opcode
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_control/instr_funct
add wave -noupdate -radix unsigned /tb_mips_top/DUT/u_mips_core/u_mips_datapath/instr_rd
add wave -noupdate -radix unsigned /tb_mips_top/DUT/u_mips_core/u_mips_datapath/instr_rs
add wave -noupdate -radix unsigned /tb_mips_top/DUT/u_mips_core/u_mips_control/instr_rt
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_datapath/instr_shmat
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_datapath/instr_imm
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_datapath/instr_jaddress
add wave -noupdate -divider Registers
add wave -noupdate /tb_mips_top/DUT/u_mips_core/arth_overflow_exception
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_lo_hi_reg/lo_reg
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_lo_hi_reg/hi_reg
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[31]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[30]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[29]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[28]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[27]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[26]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[25]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[24]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[23]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[22]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[21]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[20]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[19]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[18]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[17]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[16]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[15]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[14]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[13]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[12]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[11]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[10]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[9]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[8]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[7]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[6]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[5]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[4]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[3]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[2]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[1]}
add wave -noupdate {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[0]}
add wave -noupdate -divider DataMem
add wave -noupdate /tb_mips_top/DUT/u_data_mem/mem
add wave -noupdate /tb_mips_top/DUT/u_data_mem/address
add wave -noupdate /tb_mips_top/DUT/u_data_mem/write_en
add wave -noupdate /tb_mips_top/DUT/u_data_mem/data_in
add wave -noupdate /tb_mips_top/DUT/u_data_mem/data_out
add wave -noupdate -divider Instance
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {36 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 222
configure wave -valuecolwidth 130
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
WaveRestoreZoom {0 ns} {172 ns}
