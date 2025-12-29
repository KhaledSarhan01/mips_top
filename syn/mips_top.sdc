#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20.000ns [get_ports CLOCK2_50]
create_clock -period 20.000ns [get_ports CLOCK3_50]
create_clock -period 20.000ns [get_ports CLOCK4_50]
create_clock -period 20.000ns [get_ports CLOCK_50]

# for enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************
# Since SW and KEY are mechanical inputs pressed by a human, they are 
# asynchronous to the clock. We treat them as "False Paths" so the 
# Timing Analyzer doesn't fail setup/hold checks on them.

set_false_path -from [get_ports {SW[*]}] -to [get_clocks {CLOCK_50}]
set_false_path -from [get_ports {KEY[*]}] -to [get_clocks {CLOCK_50}]

# set_input_delay -clock CLOCK_50 -max 5.0 [get_ports {SW[*] KEY[*]}]
# set_input_delay -clock CLOCK_50 -min 0.0 [get_ports {SW[*] KEY[*]}]

#**************************************************************
# Set Output Delay
#**************************************************************
# Since LEDR and HEX are for visual display, the nanosecond timing 
# of the signal arrival doesn't matter to the human eye.
set_false_path -from [get_clocks {CLOCK_50}] -to [get_ports {LEDR[*]}]
set_false_path -from [get_clocks {CLOCK_50}] -to [get_ports {HEX*[*]}]

# set_output_delay -clock CLOCK_50 -max 5.0 [get_ports {LEDR[*] HEX*[*]}]
# set_output_delay -clock CLOCK_50 -min 0.0 [get_ports {LEDR[*] HEX*[*]}]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



