vlog -f sourcefile.txt -svinputport=relaxed
#vlog -f sourcefile.txt -svinputport=relaxed +define+ASSERTIONS
restart -force
run -all
