onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mips_top/clk
add wave -noupdate /tb_mips_top/rst_n
add wave -noupdate -divider instruction
add wave -noupdate /tb_mips_top/DUT/u_mips_core/instr
add wave -noupdate -radix hexadecimal /tb_mips_top/DUT/u_mips_core/u_mips_control/instr_opcode
add wave -noupdate -radix unsigned /tb_mips_top/DUT/u_mips_core/u_mips_datapath/instr_rs
add wave -noupdate -radix unsigned /tb_mips_top/DUT/u_mips_core/u_mips_datapath/instr_rt
add wave -noupdate -radix unsigned /tb_mips_top/DUT/u_mips_core/u_mips_datapath/instr_rd
add wave -noupdate -radix unsigned /tb_mips_top/DUT/u_mips_core/u_mips_datapath/instr_imm
add wave -noupdate -radix binary /tb_mips_top/DUT/u_mips_core/u_mips_control/instr_funct
add wave -noupdate -divider {Mips Processor}
add wave -noupdate /tb_mips_top/DUT/u_mips_core/pc
add wave -noupdate -radix unsigned -childformat {{{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[31]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[30]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[29]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[28]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[27]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[26]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[25]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[24]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[23]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[22]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[21]} -radix hexadecimal} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[20]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[19]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[18]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[17]} -radix hexadecimal} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[16]} -radix hexadecimal} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[15]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[14]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[13]} -radix hexadecimal} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[12]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[11]} -radix hexadecimal} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[10]} -radix hexadecimal} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[9]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[8]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[7]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[6]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[5]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[4]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[3]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[2]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[1]} -radix unsigned} {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[0]} -radix unsigned}} -subitemconfig {{/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[31]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[30]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[29]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[28]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[27]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[26]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[25]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[24]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[23]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[22]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[21]} {-height 15 -radix hexadecimal} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[20]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[19]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[18]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[17]} {-height 15 -radix hexadecimal} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[16]} {-height 15 -radix hexadecimal} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[15]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[14]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[13]} {-height 15 -radix hexadecimal} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[12]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[11]} {-height 15 -radix hexadecimal} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[10]} {-height 15 -radix hexadecimal} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[9]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[8]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[7]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[6]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[5]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[4]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[3]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[2]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[1]} {-height 15 -radix unsigned} {/tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers[0]} {-height 15 -radix unsigned}} /tb_mips_top/DUT/u_mips_core/u_mips_datapath/u_mips_datapath_regfile/registers
add wave -noupdate -divider {Mips Control}
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_control/zero
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_control/regwrite
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_control/regdst
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_control/alusrc
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_control/branch
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_control/memwrite
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_control/memtoreg
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_control/pcsrc
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_control/aluop
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_control/jump
add wave -noupdate /tb_mips_top/DUT/u_mips_core/u_mips_control/alucontrl
add wave -noupdate -divider {Insttruction Memory}
add wave -noupdate /tb_mips_top/DUT/u_instr_mem/address
add wave -noupdate /tb_mips_top/DUT/u_instr_mem/data_out
add wave -noupdate -radix unsigned /tb_mips_top/DUT/u_instr_mem/addr_reg
add wave -noupdate /tb_mips_top/DUT/u_instr_mem/mem
add wave -noupdate -divider {Data Memory}
add wave -noupdate /tb_mips_top/DUT/u_data_mem/address
add wave -noupdate /tb_mips_top/DUT/u_data_mem/write_en
add wave -noupdate /tb_mips_top/DUT/u_data_mem/data_in
add wave -noupdate /tb_mips_top/DUT/u_data_mem/data_out
add wave -noupdate /tb_mips_top/DUT/u_data_mem/addr_reg
add wave -noupdate /tb_mips_top/DUT/u_data_mem/mem
add wave -noupdate -divider instance
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {196 ns} 0}
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
WaveRestoreZoom {0 ns} {1061 ns}
