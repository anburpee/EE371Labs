onerror {resume}
quietly virtual function -install /binary_search_tb/dut/ctrl -env /binary_search_tb/dut/ctrl { &{/binary_search_tb/dut/ctrl/reset, /binary_search_tb/dut/ctrl/start, /binary_search_tb/dut/ctrl/found, /binary_search_tb/dut/ctrl/m_gt_a, /binary_search_tb/dut/ctrl/initialize, /binary_search_tb/dut/ctrl/incr_addr, /binary_search_tb/dut/ctrl/decr_addr, /binary_search_tb/dut/ctrl/done, /binary_search_tb/dut/ctrl/ps, /binary_search_tb/dut/ctrl/ns }} ctrl
quietly WaveActivateNextPane {} 0
add wave -noupdate /binary_search_tb/clk
add wave -noupdate -radix unsigned /binary_search_tb/a
add wave -noupdate -radix unsigned /binary_search_tb/dut/ctrl/reset
add wave -noupdate -radix unsigned /binary_search_tb/dut/ctrl/start
add wave -noupdate -radix unsigned /binary_search_tb/dut/ctrl/m_gt_a
add wave -noupdate -radix unsigned /binary_search_tb/dut/ctrl/initialize
add wave -noupdate -radix unsigned /binary_search_tb/dut/ctrl/incr_addr
add wave -noupdate -radix unsigned /binary_search_tb/dut/ctrl/decr_addr
add wave -noupdate -radix unsigned /binary_search_tb/dut/ctrl/ps
add wave -noupdate -radix unsigned /binary_search_tb/done
add wave -noupdate -radix unsigned /binary_search_tb/found
add wave -noupdate -radix unsigned /binary_search_tb/dut/datapath/loc
add wave -noupdate -radix unsigned /binary_search_tb/dut/datapath/r_ptr
add wave -noupdate -radix unsigned /binary_search_tb/dut/datapath/l_ptr
add wave -noupdate -radix unsigned /binary_search_tb/dut/datapath/data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {646 ps} 0}
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
WaveRestoreZoom {1866 ps} {3599 ps}
