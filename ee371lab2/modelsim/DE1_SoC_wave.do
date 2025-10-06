onerror {resume}
quietly virtual function -install /DE1_SoC_testbench -env /DE1_SoC_testbench { &{/DE1_SoC_testbench/SW[8], /DE1_SoC_testbench/SW[7], /DE1_SoC_testbench/SW[6], /DE1_SoC_testbench/SW[5], /DE1_SoC_testbench/SW[4] }} address
quietly virtual function -install /DE1_SoC_testbench -env /DE1_SoC_testbench { &{/DE1_SoC_testbench/SW[3], /DE1_SoC_testbench/SW[2], /DE1_SoC_testbench/SW[1] }} data_in
quietly virtual function -install /DE1_SoC_testbench -env /DE1_SoC_testbench { &{/DE1_SoC_testbench/HEX4, /DE1_SoC_testbench/HEX5 }} address_display
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk {/DE1_SoC_testbench/KEY[0]}
add wave -noupdate /DE1_SoC_testbench/address
add wave -noupdate /DE1_SoC_testbench/data_in
add wave -noupdate -label wren {/DE1_SoC_testbench/SW[0]}
add wave -noupdate -label data_out_display /DE1_SoC_testbench/HEX0
add wave -noupdate -label data_in_display /DE1_SoC_testbench/HEX1
add wave -noupdate /DE1_SoC_testbench/HEX2
add wave -noupdate /DE1_SoC_testbench/HEX3
add wave -noupdate /DE1_SoC_testbench/address_display
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {7750 ps}
