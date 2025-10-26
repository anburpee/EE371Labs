# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.

vlog "../src/fifo.sv"
vlog "../src/fifo_tb.sv"
vlog "../src/fifo_ctrl.sv"
vlog "../src/reg_file.sv"
vlog "../src/fir.sv"
vlog "../src/fir_tb.sv"
vlog "../src/circuit2_tb.sv"
vlog "../src/rom_1port.v"
vlog "../src/circuit2.sv"



# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work fir_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do fir_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End


