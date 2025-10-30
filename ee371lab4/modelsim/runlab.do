# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "../src/bit_counter.sv"
vlog "../src/bit_counter_ctrl.sv"
vlog "../src/bit_counter_reg.sv"
vlog "../src/bit_counter_tb.sv"


# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work bit_counter_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do bit_counter_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End


