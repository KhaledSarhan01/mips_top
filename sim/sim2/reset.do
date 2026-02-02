
vlog -f sourcefile.txt -svinputport=relaxed +define+ASSERTIONS
restart -force
run -all

# vlog -f sourcefile.txt -svinputport=relaxed +define+ASSERTIONS +cover -covercells 
# restart -force
# run -all

# # Save and update the report after the reset run
# coverage save reports/mips_coverage.ucdb