onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /line_drawer_tb/clk
add wave -noupdate /line_drawer_tb/reset
add wave -noupdate -radix unsigned /line_drawer_tb/x0
add wave -noupdate -radix unsigned /line_drawer_tb/y0
add wave -noupdate -radix unsigned /line_drawer_tb/x1
add wave -noupdate -radix unsigned /line_drawer_tb/y1
add wave -noupdate -radix unsigned /line_drawer_tb/write
add wave -noupdate -radix unsigned /line_drawer_tb/done
add wave -noupdate /line_drawer_tb/dut/ctrl/ps
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/init_load
add wave -noupdate /line_drawer_tb/dut/second_load
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/swap_axes
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/draw_yx
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/draw_xy
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/update_err
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/update_err_y
add wave -noupdate /line_drawer_tb/dut/update_x
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/is_steep
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/err_gte_zero
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/x_eq_x1
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/x0_t
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/x1_t
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/y0_t
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/y1_t
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/deltax
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/deltay
add wave -noupdate -label x(internal) -radix unsigned /line_drawer_tb/dut/reg_file/x
add wave -noupdate -label y(internal) -radix unsigned /line_drawer_tb/dut/reg_file/y
add wave -noupdate -radix decimal /line_drawer_tb/dut/reg_file/xstep
add wave -noupdate -radix decimal /line_drawer_tb/dut/reg_file/ystep
add wave -noupdate -radix decimal /line_drawer_tb/dut/reg_file/err
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/x_out
add wave -noupdate -radix unsigned /line_drawer_tb/dut/reg_file/y_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {541 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 122
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
WaveRestoreZoom {0 ps} {1473 ps}
