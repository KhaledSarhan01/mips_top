# Load necessary packages
load_package report
load_package flow

# # Set your project name here (without .qpf extension)
# set project_name "mips_top"

# project_open $project_name

# 1. Ensure all reports are loaded
load_report

# 2. Function to safe-save a panel to a file
proc save_panel {panel_path output_file} {
    set panel_id [get_report_panel_id $panel_path]
    if {$panel_id != -1} {
        write_report_panel -file $output_file -id $panel_id
        post_message "Successfully saved: $panel_path"
    } else {
        post_message -type warning "Could not find report panel: $panel_path"
    }
}

# --- GENERATE REPORTS ---

# Utilization (Fitter Summary)
save_panel "Fitter||Fitter Summary" "report/report_utilization.txt"
# save_panel "Fitter||Resource Section||Resource Usage Summary" "report_utilization.txt"

# Timing (Setup Summary) - Adjust path if using older Quartus versions
save_panel "Timing Analyzer||Multicorner Timing Analysis Summary" "report/report_timing.txt"

# Power (Power Analyzer Summary)
# Note: You must run Power Analysis first for this to exist!
save_panel "Power Analyzer||Power Analyzer Summary" "report/report_power.txt"

# project_close