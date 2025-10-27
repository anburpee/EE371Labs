onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /circuit2_tb/clk
add wave -noupdate /circuit2_tb/reset
add wave -noupdate /circuit2_tb/read_ready
add wave -noupdate /circuit2_tb/write_ready
add wave -noupdate /circuit2_tb/enable
add wave -noupdate -radix unsigned /circuit2_tb/dut/addr
add wave -noupdate -radix unsigned /circuit2_tb/d_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9604831 ps} 0}
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
WaveRestoreZoom {9562610 ps} {9563421 ps}
