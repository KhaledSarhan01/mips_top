
vlib work
vlog -f sourcefile.txt -svinputport=relaxed 
vsim -voptargs=+acc work.tb_mips_top
add wave *
run -all

# #Create the reports folder if it doesn't exist
# if {![file exists reports]} {
#     file mkdir reports
# }

# vlib work
# # 1. Enable coverage collection during compilation
# vlog -f sourcefile.txt -svinputport=relaxed +define+ASSERTIONS +cover -covercells 

# # 2. Enable coverage during simulation and name the database
# vsim -voptargs=+acc -coverage work.tb_mips_top

# add wave *

# # 3. Optional: Automatically save coverage data when simulation finishes
# # You can also do this manually in the transcript
# onfinish stop

# run -all

# # 4. Save the coverage database and generate the report
# coverage save reports/mips_coverage.ucdb