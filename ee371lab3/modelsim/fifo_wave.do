onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fifo_tb/clk
add wave -noupdate /fifo_tb/reset
add wave -noupdate /fifo_tb/rd
add wave -noupdate /fifo_tb/wr
add wave -noupdate /fifo_tb/empty
add wave -noupdate /fifo_tb/full
add wave -noupdate /fifo_tb/w_data
add wave -noupdate /fifo_tb/r_data
add wave -noupdate -expand /fifo_tb/dut/r_unit/array_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4745 ps} 0}
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
WaveRestoreZoom {0 ps} {801 ps}
