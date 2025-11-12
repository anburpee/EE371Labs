onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /task3_basic_tb/dut/lines/clk
add wave -noupdate -radix unsigned /task3_basic_tb/dut/lines/reset
add wave -noupdate -radix unsigned /task3_basic_tb/dut/lines/x0
add wave -noupdate -radix unsigned /task3_basic_tb/dut/lines/y0
add wave -noupdate -radix unsigned /task3_basic_tb/dut/lines/x1
add wave -noupdate -radix unsigned /task3_basic_tb/dut/lines/y1
add wave -noupdate -radix unsigned /task3_basic_tb/dut/lines/write
add wave -noupdate -radix unsigned /task3_basic_tb/dut/lines/ctrl/ps
add wave -noupdate -radix unsigned /task3_basic_tb/dut/lines/done
add wave -noupdate -radix unsigned /task3_basic_tb/dut/lines/x
add wave -noupdate -radix unsigned /task3_basic_tb/dut/lines/y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {61717950 ps} 0}
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
WaveRestoreZoom {61717291 ps} {61718609 ps}
