onerror {resume}
quietly virtual function -install /DE1_SoC_tb -env /DE1_SoC_tb { &{/DE1_SoC_tb/SW[7], /DE1_SoC_tb/SW[6], /DE1_SoC_tb/SW[5], /DE1_SoC_tb/SW[4], /DE1_SoC_tb/SW[3], /DE1_SoC_tb/SW[2], /DE1_SoC_tb/SW[1], /DE1_SoC_tb/SW[0] }} SWs_A
quietly virtual function -install /DE1_SoC_tb -env /DE1_SoC_tb { &{/DE1_SoC_tb/SW[7], /DE1_SoC_tb/SW[6], /DE1_SoC_tb/SW[5], /DE1_SoC_tb/SW[4], /DE1_SoC_tb/SW[3], /DE1_SoC_tb/SW[2], /DE1_SoC_tb/SW[1], /DE1_SoC_tb/SW[0] }} SW7_0
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_tb/CLOCK_50
add wave -noupdate /DE1_SoC_tb/dut/counter/reset
add wave -noupdate {/DE1_SoC_tb/SW[9]}
add wave -noupdate /DE1_SoC_tb/SW7_0
add wave -noupdate {/DE1_SoC_tb/HEX0[1]}
add wave -noupdate {/DE1_SoC_tb/HEX0[0]}
add wave -noupdate -label a_input_task1 /DE1_SoC_tb/dut/counter/a_input
add wave -noupdate -label a_task2 /DE1_SoC_tb/dut/search/datapath/a
add wave -noupdate -label s_task1 /DE1_SoC_tb/dut/counter/ctrl/s
add wave -noupdate -label start_task2 /DE1_SoC_tb/dut/search/ctrl/start
add wave -noupdate -label found_task2 /DE1_SoC_tb/dut/search/datapath/found
add wave -noupdate {/DE1_SoC_tb/LEDR[0]}
add wave -noupdate -label done_task1 /DE1_SoC_tb/dut/counter/done
add wave -noupdate -label done_task2 /DE1_SoC_tb/dut/search/ctrl/done
add wave -noupdate {/DE1_SoC_tb/LEDR[9]}
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
WaveRestoreZoom {0 ps} {1 ns}
