# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "../src/altera_up_avalon_video_vga_timing.v"
vlog "../src/CLOCK25_PLL/CLOCK25_PLL_0002.v"
vlog "../src/CLOCK25_PLL.v"
vlog "../src/video_driver.sv"
vlog "../src/DE1_SoC.sv"
vlog "../src/display_update.sv"
vlog "../src/display_update_tb.sv"
vlog "../src/ram_update_v3.sv"
vlog "../src/ram_update_v3_tb.sv"
vlog "../src/ram_update_ctrl_v3.sv"
vlog "../src/ram_update_datapath_v3.sv"
vlog "../quartus/black_ram16x7.v"
vlog "../quartus/red_ram16x7.v"
vlog "../src/DE1_SoC_tb.sv"
vlog "../quartus/spot_encodings64x3.v"
vlog "../src/ram_update_tb.sv"
vlog "../src/ram_update.sv"
vlog "../src/ram_update_ctrl.sv"
vlog "../src/ram_update_datapath.sv"
vlog "../src/anti_metastability.sv"



# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work DE1_SoC_tb -Lf altera_mf_ver
# used to be "-Lf altera_lnsim_ver" but this was throwing errors with altsyncram

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do DE1_SoC_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
