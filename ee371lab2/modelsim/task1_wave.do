onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /task1_testbench/clk
add wave -noupdate /task1_testbench/wren
add wave -noupdate /task1_testbench/address
add wave -noupdate /task1_testbench/data_in
add wave -noupdate /task1_testbench/data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9711 ps} 0}
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
WaveRestoreZoom {9172 ps} {9782 ps}
