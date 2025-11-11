onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_tb/dut/CLOCK_50
add wave -noupdate /DE1_SoC_tb/dut/line_drawer_clk
add wave -noupdate /DE1_SoC_tb/dut/reset
add wave -noupdate -radix unsigned /DE1_SoC_tb/dut/xcounter
add wave -noupdate -radix unsigned /DE1_SoC_tb/dut/ycounter
add wave -noupdate -radix unsigned /DE1_SoC_tb/dut/clearing
add wave -noupdate -radix unsigned /DE1_SoC_tb/dut/clearing_prev
add wave -noupdate -radix unsigned /DE1_SoC_tb/dut/clear_done
add wave -noupdate -radix unsigned /DE1_SoC_tb/dut/done
add wave -noupdate -radix unsigned /DE1_SoC_tb/dut/count
add wave -noupdate -label reset(line_drawer) -radix unsigned /DE1_SoC_tb/dut/lines/reset
add wave -noupdate -radix unsigned /DE1_SoC_tb/dut/lines/ctrl/ps
add wave -noupdate -radix unsigned /DE1_SoC_tb/dut/x0
add wave -noupdate -radix unsigned /DE1_SoC_tb/dut/y0
add wave -noupdate -radix unsigned /DE1_SoC_tb/dut/x1
add wave -noupdate -radix unsigned /DE1_SoC_tb/dut/y1
add wave -noupdate -radix unsigned /DE1_SoC_tb/dut/x
add wave -noupdate -radix unsigned /DE1_SoC_tb/dut/y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30741302 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {30740912 ps} {30741788 ps}
