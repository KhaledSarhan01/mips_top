
vlib work
vlog -f sourcefile.txt -svinputport=relaxed
#vlog -f sourcefile.txt -svinputport=relaxed +define+ASSERTIONS
vsim -voptargs=+acc work.tb_mips_top
add wave *
run -all
