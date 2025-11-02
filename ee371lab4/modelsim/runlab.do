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
vlog "../src/task1/anti_metastability.sv"
vlog "../src/task1/seg7.sv"
vlog "../src/task1/task1_top_tb.sv"

vlog "../src/task2/ram_tb.sv"
vlog "../src/task2/binary_search_ctrl.sv"
vlog "../src/task2/binary_search_reg.sv"
vlog "../src/task2/binary_search.sv"
vlog "../src/task2/ram32x8.v"
vlog "../src/task2/binary_search_tb.sv"
vlog "../src/task2/seg7_two_outputs.sv"
vlog "../src/task2/task2_top.sv"
vlog "../src/task2/task2_top_tb.sv"

vlog "../src/DE1_SoC.sv"
vlog "../src/DE1_SoC_tb.sv"



# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work task1_top_tb -Lf altera_mf_ver

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


