# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "../src/task1/bit_counter.sv"
vlog "../src/task1/bit_counter_ctrl.sv"
vlog "../src/task1/bit_counter_reg.sv"
vlog "../src/task1/bit_counter_tb.sv"
vlog "../src/task1/task1_top.sv"
vlog "../src/task1/task1_top_tb.sv"
vlog "../src/task1/seg7.sv"



# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work task1_top_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do task1_top_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End


