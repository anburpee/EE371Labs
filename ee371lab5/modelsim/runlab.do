# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "../src/line_drawer_ctrl.sv"
vlog "../src/line_drawer_reg.sv"
vlog "../src/line_drawer.sv"
vlog "../src/line_drawer_tb.sv"
vlog "../src/task2_top.sv"
vlog "../src/task2_top_tb.sv"
vlog "../src/anti_metastability.sv"
vlog "../src/clock_divider.sv"
vlog "../src/VGA_framebuffer.sv"


# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work task2_top_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do task2_top_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End


