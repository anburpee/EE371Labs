onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /parking_lot_occupancy_testbench/clk
add wave -noupdate /parking_lot_occupancy_testbench/HEX0
add wave -noupdate /parking_lot_occupancy_testbench/HEX1
add wave -noupdate /parking_lot_occupancy_testbench/HEX2
add wave -noupdate /parking_lot_occupancy_testbench/HEX3
add wave -noupdate /parking_lot_occupancy_testbench/HEX4
add wave -noupdate /parking_lot_occupancy_testbench/HEX5
add wave -noupdate -radix decimal /parking_lot_occupancy_testbench/num_cars
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {17840 ps} 0}
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
WaveRestoreZoom {42 ps} {17840 ps}
