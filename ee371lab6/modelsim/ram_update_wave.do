onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ram_update_tb/clk
add wave -noupdate /ram_update_tb/reset
add wave -noupdate /ram_update_tb/key
add wave -noupdate /ram_update_tb/sw
add wave -noupdate /ram_update_tb/dut/ram_ctrl/ps
add wave -noupdate /ram_update_tb/dut/ram_ctrl/ns
add wave -noupdate /ram_update_tb/dut/ram_datapath/q_red
add wave -noupdate /ram_update_tb/dut/ram_datapath/q_blk
add wave -noupdate /ram_update_tb/dut/ram_datapath/data_red
add wave -noupdate /ram_update_tb/dut/ram_datapath/data_blk
add wave -noupdate /ram_update_tb/dut/ram_datapath/red_count
add wave -noupdate /ram_update_tb/dut/ram_datapath/blk_count
add wave -noupdate /ram_update_tb/dut/ram_datapath/reds_turn
add wave -noupdate /ram_update_tb/iter_done
add wave -noupdate /ram_update_tb/invalid_move
add wave -noupdate /ram_update_tb/dut/ram_ctrl/count_eq_11
add wave -noupdate /ram_update_tb/dut/ram_datapath/check0
add wave -noupdate /ram_update_tb/dut/ram_datapath/x_curr
add wave -noupdate /ram_update_tb/dut/ram_datapath/y_curr
add wave -noupdate /ram_update_tb/dut/ram_ctrl/valid_xy
add wave -noupdate /ram_update_tb/dut/ram_ctrl/legal_dir
add wave -noupdate /ram_update_tb/dut/ram_ctrl/edge_blocked0
add wave -noupdate /ram_update_tb/dut/ram_ctrl/own_adj
add wave -noupdate /ram_update_tb/dut/ram_ctrl/opp_adj
add wave -noupdate /ram_update_tb/dut/ram_ctrl/edge_blocked1
add wave -noupdate /ram_update_tb/dut/ram_ctrl/two_over
add wave -noupdate /ram_update_tb/dut/ram_ctrl/cont_turn
add wave -noupdate /ram_update_tb/dut/ram_ctrl/mult_iter
add wave -noupdate /ram_update_tb/dut/ram_ctrl/load_iter
add wave -noupdate /ram_update_tb/dut/ram_ctrl/initialize
add wave -noupdate /ram_update_tb/dut/ram_ctrl/read
add wave -noupdate /ram_update_tb/dut/ram_ctrl/check0
add wave -noupdate /ram_update_tb/dut/ram_ctrl/check_done
add wave -noupdate /ram_update_tb/dut/ram_ctrl/incr_count
add wave -noupdate /ram_update_tb/dut/ram_ctrl/reset_count
add wave -noupdate /ram_update_tb/dut/ram_ctrl/invalid_xy
add wave -noupdate /ram_update_tb/dut/ram_ctrl/illegal_dir
add wave -noupdate /ram_update_tb/dut/ram_ctrl/board_in_way
add wave -noupdate /ram_update_tb/dut/ram_ctrl/token_in_way
add wave -noupdate /ram_update_tb/dut/ram_ctrl/load_adj
add wave -noupdate /ram_update_tb/dut/ram_ctrl/load_skip
add wave -noupdate /ram_update_tb/dut/ram_ctrl/mult_true
add wave -noupdate /ram_update_tb/dut/ram_ctrl/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {677 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 140
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2179 ps}
