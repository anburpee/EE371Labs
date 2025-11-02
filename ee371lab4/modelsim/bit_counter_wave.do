onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bit_counter_tb/clk
add wave -noupdate /bit_counter_tb/reset
add wave -noupdate /bit_counter_tb/s
add wave -noupdate /bit_counter_tb/dut/ctrl/ps
add wave -noupdate -radix binary /bit_counter_tb/a_input
add wave -noupdate -radix binary -childformat {{{/bit_counter_tb/dut/reg_file/a[7]} -radix unsigned} {{/bit_counter_tb/dut/reg_file/a[6]} -radix unsigned} {{/bit_counter_tb/dut/reg_file/a[5]} -radix unsigned} {{/bit_counter_tb/dut/reg_file/a[4]} -radix unsigned} {{/bit_counter_tb/dut/reg_file/a[3]} -radix unsigned} {{/bit_counter_tb/dut/reg_file/a[2]} -radix unsigned} {{/bit_counter_tb/dut/reg_file/a[1]} -radix unsigned} {{/bit_counter_tb/dut/reg_file/a[0]} -radix unsigned}} -subitemconfig {{/bit_counter_tb/dut/reg_file/a[7]} {-height 15 -radix unsigned} {/bit_counter_tb/dut/reg_file/a[6]} {-height 15 -radix unsigned} {/bit_counter_tb/dut/reg_file/a[5]} {-height 15 -radix unsigned} {/bit_counter_tb/dut/reg_file/a[4]} {-height 15 -radix unsigned} {/bit_counter_tb/dut/reg_file/a[3]} {-height 15 -radix unsigned} {/bit_counter_tb/dut/reg_file/a[2]} {-height 15 -radix unsigned} {/bit_counter_tb/dut/reg_file/a[1]} {-height 15 -radix unsigned} {/bit_counter_tb/dut/reg_file/a[0]} {-height 15 -radix unsigned}} /bit_counter_tb/dut/reg_file/a
add wave -noupdate /bit_counter_tb/dut/ctrl/a_eq_zero
add wave -noupdate /bit_counter_tb/dut/ctrl/a0
add wave -noupdate /bit_counter_tb/dut/ctrl/clear_result
add wave -noupdate /bit_counter_tb/dut/ctrl/load_a
add wave -noupdate /bit_counter_tb/dut/ctrl/right_shift_a
add wave -noupdate /bit_counter_tb/dut/ctrl/incr_result
add wave -noupdate -radix unsigned /bit_counter_tb/result
add wave -noupdate /bit_counter_tb/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3410 ps} 0}
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
WaveRestoreZoom {2296 ps} {3721 ps}
