onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/datapath/clk
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/ctrl/reset
add wave -noupdate -radix unsigned {/task2_top_tb/KEY[0]}
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/ctrl/start
add wave -noupdate -radix unsigned {/task2_top_tb/KEY[3]}
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/datapath/a
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/ctrl/ps
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/datapath/initialize
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/datapath/idle
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/datapath/incr_addr
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/datapath/decr_addr
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/datapath/m_gt_a
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/datapath/found
add wave -noupdate -radix unsigned {/task2_top_tb/LEDR[0]}
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/datapath/loc
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/datapath/r_ptr
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/datapath/l_ptr
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/datapath/data_out
add wave -noupdate -radix unsigned /task2_top_tb/dut/search/ctrl/done
add wave -noupdate -radix unsigned {/task2_top_tb/LEDR[9]}
add wave -noupdate /task2_top_tb/dut/hex_1_0/hex
add wave -noupdate /task2_top_tb/dut/hex_1_0/leds1
add wave -noupdate /task2_top_tb/dut/hex_1_0/leds0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3601 ps} 0}
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
WaveRestoreZoom {1678 ps} {2788 ps}
