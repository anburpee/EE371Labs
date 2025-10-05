// DE1_SoC code given in Lab1 specs
// DE1_SoC testbench also given in Lab1 specs
// left name as is (_tb) in case it's referred to in runlab files or something idk

// DE1_SoC.sv is only for calling modules and connecting fw to board
// all actual logic should be in other modules/files

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, SW, LEDR);
        input logic CLOCK_50;
        input logic [9:0] SW;
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
        task2 dut2 (.clk(clk), .address_in(SW[8:4]), .address_out1(HEX5), .data_in(SW[3:1]), .wren(SW[0]), .data_out())  

endmodule  // DE1_SoC




module DE1_SoC_testbench();
        // define signals
        logic   CLOCK_50;
        logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
        logic [9:0] LEDR;

endmodule  // DE1_SoC_testbench