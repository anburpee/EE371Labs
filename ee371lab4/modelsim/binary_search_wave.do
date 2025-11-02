onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /binary_search_tb/clk
add wave -noupdate /binary_search_tb/reset
add wave -noupdate /binary_search_tb/start
add wave -noupdate -radix unsigned /binary_search_tb/a
add wave -noupdate /binary_search_tb/dut/m_gt_a
add wave -noupdate /binary_search_tb/dut/idle
add wave -noupdate /binary_search_tb/dut/initialize
add wave -noupdate /binary_search_tb/dut/incr_addr
add wave -noupdate /binary_search_tb/dut/decr_addr
add wave -noupdate /binary_search_tb/dut/ctrl/ps
add wave -noupdate /binary_search_tb/done
add wave -noupdate /binary_search_tb/found
add wave -noupdate -radix unsigned /binary_search_tb/loc
add wave -noupdate -radix unsigned /binary_search_tb/dut/datapath/r_ptr
add wave -noupdate -radix unsigned /binary_search_tb/dut/datapath/l_ptr
add wave -noupdate -radix unsigned /binary_search_tb/dut/datapath/data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2812 ps} 0}
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
WaveRestoreZoom {5868 ps} {7744 ps}
