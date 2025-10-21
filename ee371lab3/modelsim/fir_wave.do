onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fir_tb/clk
add wave -noupdate /fir_tb/reset
add wave -noupdate /fir_tb/rd
add wave -noupdate /fir_tb/wr
add wave -noupdate -radix unsigned /fir_tb/data_in
add wave -noupdate -radix unsigned /fir_tb/dut/divided
add wave -noupdate -radix unsigned /fir_tb/dut/fifo_out
add wave -noupdate -radix unsigned /fir_tb/dut/subtracted
add wave -noupdate -radix unsigned /fir_tb/data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {95 ps} 0}
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
WaveRestoreZoom {0 ps} {2236 ps}
