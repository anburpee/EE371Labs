onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /task1_top_tb/CLOCK_50
add wave -noupdate {/task1_top_tb/KEY[0]}
add wave -noupdate /task1_top_tb/dut/reset
add wave -noupdate {/task1_top_tb/KEY[3]}
add wave -noupdate /task1_top_tb/dut/s
add wave -noupdate /task1_top_tb/dut/a_input
add wave -noupdate /task1_top_tb/dut/counter/reg_file/a
add wave -noupdate /task1_top_tb/dut/done
add wave -noupdate {/task1_top_tb/LEDR[9]}
add wave -noupdate -radix unsigned /task1_top_tb/dut/result
add wave -noupdate /task1_top_tb/HEX0
add wave -noupdate /task1_top_tb/dut/counter/ctrl/ps
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {3500 ps} {4500 ps}
