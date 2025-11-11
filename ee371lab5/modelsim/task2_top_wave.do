onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /task2_top_tb/CLOCK_50
add wave -noupdate /task2_top_tb/dut/key3
add wave -noupdate /task2_top_tb/dut/reset
add wave -noupdate -radix unsigned /task2_top_tb/dut/x0
add wave -noupdate -radix unsigned /task2_top_tb/dut/y0
add wave -noupdate -radix unsigned /task2_top_tb/dut/x1
add wave -noupdate -radix unsigned /task2_top_tb/dut/y1
add wave -noupdate -radix unsigned /task2_top_tb/dut/x
add wave -noupdate -radix unsigned /task2_top_tb/dut/y
add wave -noupdate -radix unsigned /task2_top_tb/dut/write
add wave -noupdate -label {clk (line_drawer)} -radix unsigned /task2_top_tb/dut/clk
add wave -noupdate -radix unsigned /task2_top_tb/dut/done
add wave -noupdate -radix unsigned /task2_top_tb/dut/count
add wave -noupdate /task2_top_tb/dut/lines/ctrl/ps
add wave -noupdate /task2_top_tb/dut/lines/ctrl/init_load
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3223 ps} 0}
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
WaveRestoreZoom {2602 ps} {3602 ps}
