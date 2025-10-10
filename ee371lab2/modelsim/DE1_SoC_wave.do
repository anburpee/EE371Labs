onerror {resume}
quietly virtual function -install /DE1_SoC_testbench -env /DE1_SoC_testbench { &{/DE1_SoC_testbench/SW[8], /DE1_SoC_testbench/SW[7], /DE1_SoC_testbench/SW[6], /DE1_SoC_testbench/SW[5], /DE1_SoC_testbench/SW[4] }} address
quietly virtual function -install /DE1_SoC_testbench -env /DE1_SoC_testbench { &{/DE1_SoC_testbench/SW[3], /DE1_SoC_testbench/SW[2], /DE1_SoC_testbench/SW[1] }} data_in
quietly virtual function -install /DE1_SoC_testbench -env /DE1_SoC_testbench { &{/DE1_SoC_testbench/HEX4, /DE1_SoC_testbench/HEX5 }} address_display
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_testbench/CLOCK_50
add wave -noupdate {/DE1_SoC_testbench/KEY[0]}
add wave -noupdate /DE1_SoC_testbench/dut/clk_tsk2
add wave -noupdate {/DE1_SoC_testbench/KEY[3]}
add wave -noupdate /DE1_SoC_testbench/dut/reset
add wave -noupdate -label w_address -radix unsigned -childformat {{(4) -radix unsigned} {(3) -radix unsigned} {(2) -radix unsigned} {(1) -radix unsigned} {(0) -radix unsigned}} -subitemconfig {{/DE1_SoC_testbench/SW[8]} {-radix unsigned} {/DE1_SoC_testbench/SW[7]} {-radix unsigned} {/DE1_SoC_testbench/SW[6]} {-radix unsigned} {/DE1_SoC_testbench/SW[5]} {-radix unsigned} {/DE1_SoC_testbench/SW[4]} {-radix unsigned}} /DE1_SoC_testbench/address
add wave -noupdate /DE1_SoC_testbench/data_in
add wave -noupdate /DE1_SoC_testbench/dut/data_out_tsk2
add wave -noupdate /DE1_SoC_testbench/dut/data_out_tsk3
add wave -noupdate /DE1_SoC_testbench/dut/data_out
add wave -noupdate /DE1_SoC_testbench/dut/wren_tsk2
add wave -noupdate /DE1_SoC_testbench/dut/wren_tsk3
add wave -noupdate -label {data_in HEX} -radix unsigned /DE1_SoC_testbench/HEX1
add wave -noupdate -label {data_out HEX} -radix unsigned -childformat {{{/DE1_SoC_testbench/HEX0[6]} -radix unsigned} {{/DE1_SoC_testbench/HEX0[5]} -radix unsigned} {{/DE1_SoC_testbench/HEX0[4]} -radix unsigned} {{/DE1_SoC_testbench/HEX0[3]} -radix unsigned} {{/DE1_SoC_testbench/HEX0[2]} -radix unsigned} {{/DE1_SoC_testbench/HEX0[1]} -radix unsigned} {{/DE1_SoC_testbench/HEX0[0]} -radix unsigned}} -subitemconfig {{/DE1_SoC_testbench/HEX0[6]} {-radix unsigned} {/DE1_SoC_testbench/HEX0[5]} {-radix unsigned} {/DE1_SoC_testbench/HEX0[4]} {-radix unsigned} {/DE1_SoC_testbench/HEX0[3]} {-radix unsigned} {/DE1_SoC_testbench/HEX0[2]} {-radix unsigned} {/DE1_SoC_testbench/HEX0[1]} {-radix unsigned} {/DE1_SoC_testbench/HEX0[0]} {-radix unsigned}} /DE1_SoC_testbench/HEX0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3766 ps} 0}
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
WaveRestoreZoom {13659 ps} {15403 ps}
