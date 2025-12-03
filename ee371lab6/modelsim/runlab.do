# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "../src/altera_up_avalon_video_vga_timing.sv"
vlog "../vga_driver/CLOCK25_PLL/CLOCK25_PLL_0002.sv"
vlog "../vga_driver/CLOCK25_PLL.sv"
vlog "../src/video_driver.sv"
vlog "../src/DE1_SoC.sv"
vlog "../src/display_update.sv"
vlog "../src/ram_update.sv"
vlog "../src/ram_update_ctrl.sv"
vlog "../src/ram_update_datapath.sv"


# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work ram_update_tb -Lf altera_lnsim_ver

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do ram_update_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
