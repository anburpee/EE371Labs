onerror {resume}
quietly virtual signal -install /DE1_SoC_testbench { (context /DE1_SoC_testbench )&{V_GPIO[28] , V_GPIO[24] }} outer_inner_sw
quietly virtual signal -install /DE1_SoC_testbench { (context /DE1_SoC_testbench )&{V_GPIO[34] , V_GPIO[26] }} outer_inner_LED
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_testbench/CLOCK_50
add wave -noupdate -label reset {/DE1_SoC_testbench/V_GPIO[30]}
add wave -noupdate -radix decimal /DE1_SoC_testbench/HEX0
add wave -noupdate -radix decimal /DE1_SoC_testbench/HEX1
add wave -noupdate -radix decimal /DE1_SoC_testbench/HEX2
add wave -noupdate -radix decimal /DE1_SoC_testbench/HEX3
add wave -noupdate -radix decimal /DE1_SoC_testbench/HEX4
add wave -noupdate -radix decimal /DE1_SoC_testbench/HEX5
add wave -noupdate /DE1_SoC_testbench/outer_inner_sw
add wave -noupdate /DE1_SoC_testbench/outer_inner_LED
add wave -noupdate /DE1_SoC_testbench/dut/cd/ps
add wave -noupdate /DE1_SoC_testbench/dut/plo/num_cars
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3570 ps} 0}
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
WaveRestoreZoom {3582 ps} {3906 ps}
