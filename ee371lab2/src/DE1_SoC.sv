// DE1_SoC code given in Lab1 specs
// DE1_SoC testbench also given in Lab1 specs
// left name as is (_tb) in case it's referred to in runlab files or something idk

// DE1_SoC.sv is only for calling modules and connecting fw to board
// all actual logic should be in other modules/files

module DE1_SoC (CLOCK_50, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, SW, LEDR);
        input logic CLOCK_50;
        input logic [9:0] SW;
        input logic [3:0] KEY;
        output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
        output logic [9:0] LEDR;

    // Set up reset signal and clock
    // ***commented out clock divider since not needed for Lab1***
        logic reset;
	assign reset = V_GPIO[30];
	// logic [31:0] div_clock;
        // // comment out one clock based on whether using simulation or pushing to board
        // // assign clk = div_clock[25]; // change clock speed by changing which clock to use on board
	assign clk = CLOCK_50; // for simulation or if using clock_50 in design
  
	// set up clock divider
	// clock_divider divider (.clock(CLOCK_50), .divided_clocks(div_clock));

        // call task2 module
        // need HEX[5:4] to follow address, HEX[1] to follow data_in, HEX0 to follow data_out
        logic data_out;
        task2 dut2 (.clk(KEY[0]), .address(SW[8:4]), .data_in(SW[3:1]), .wren(SW[0]), .data_out(data_out));

endmodule  // DE1_SoC




module DE1_SoC_testbench();
        // define signals
        logic   CLOCK_50;
        logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
        logic [9:0] LEDR;

endmodule  // DE1_SoC_testbench