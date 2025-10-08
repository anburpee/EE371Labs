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


//     // Set up reset signal and clock
//     // ***commented out clock divider since not needed for Lab1***
        logic reset;
 	assign reset = KEY[3];
        logic clk;
        assign clk = CLOCK_50; // changed from ~KEY[0] from Part 2

        // logic [31:0] div_clock;
        // // comment out one clock based on whether using simulation or pushing to board
        // // assign clk = div_clock[25]; // change clock speed by changing which clock to use on board
	//assign clk = CLOCK_50; // for simulation or if using clock_50 in design
  
	// set up clock divider
	// clock_divider divider (.clock(CLOCK_50), .divided_clocks(div_clock));


        logic w_address;
        assign w_address = SW[8:4];

        logic data_in;
        assign data_in = SW[3:1];

        logic wren, wren_tsk2, wren_tsk3;
        assign wren_tsk2 = SW[0];
        assign wren_tsk3 = SW[0];
        // wren is specified for task2 only when SW[9] == 0
        // wren is specified for task3 only when SW[9] == 1
        assign wren = SW[9] ? wren_tsk3 : wren_tsk2;

        // instantiate module that cycles through read addresses
        enabled_counter r_addresses #(.num_bits(5)) (.clk(clk), .reset(reset), .count(r_address));

        // instantiate task2 and task3 modules
        logic [2:0] data_out, data_out_tsk2, data_out_tsk3;


        task2 task_2 (.clk(clk), .address(w_address), .data_in(data_in),
                      .wren(wren), .data_out(data_out_tsk2));

        task3 task_3 (.clk(clk), .wren(wren), .w_address(w_address),
                      .r_address(r_address), .data_in(data_in), .data_out(data_out_tsk3));

        // if SW[9] == 1, output data is from task3 memory
        // if SW[9] == 0, output data is from task2 memory
        assign data_out = SW[9] ? data_out_tsk3 : data_out_tsk2;


        // set up displays on 7 segment displays
        // HEX[5:4] displays write address, HEX[3:2] displays read address
        // HEX[1] displays data_in, HEX0 displays data_out
        seg7_two_outputs w_addr_display (.hex(w_address), .leds1(HEX5), .leds0(HEX4));
        seg7_two_outputs r_addr_display (.hex(r_address), .leds1(HEX3), .leds0(HEX2)); 
        seg7_one_output data_in_display (.hex({1'b0, data_in}), .leds(HEX1));
        seg7_one_output data_out_display (.hex({1'b0, data_out}), .leds(HEX0));


endmodule  // DE1_SoC



`timescale 1 ps / 1 ps
module DE1_SoC_testbench();
        // define signals
        logic   CLOCK_50;
        logic [9:0] SW;
        logic [3:0] KEY;
        logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
        logic [9:0] LEDR;

        // instantiate the dut
        DE1_SoC dut (.*);

        // set up simulation clock
        //assign CLOCK_50 = ~KEY[0];
        parameter period = 100;

        initial begin
                CLOCK_50 <= 1;
                forever #(period/2) CLOCK_50 <= ~CLOCK_50;
        end

        // test the design
        integer i;
        initial begin
                SW[0] <= 1'b1; @(posedge CLOCK_50); // write-enabled
                
                for (i = 0; i < 2**5; i++) begin
                        SW[8:4] <= i;
                        SW[3:1] <= 3'b000; // repeats values 0-7 since values are truncated to 3 bits
                        @(posedge CLOCK_50);
                        $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                                  i, SW[8:4], SW[8:4], SW[3:1], SW[3:1], dut.data_out, dut.data_out);
                end // for loop
                
                // write in data (cycles through 0-7)
                for (i = 0; i < 2**5; i++) begin
                        SW[8:4] <= i;
                        SW[3:1] <= i; // repeats values 0-7 since values are truncated to 3 bits
                        @(posedge CLOCK_50);
                        $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                                  i, SW[8:4], SW[8:4], SW[3:1], SW[3:1], dut.data_out, dut.data_out);
                end // for loop

                $display ("----------------- turn write enable OFF -------------------");

                // write enable is off
                // so writing anything to the addresses shouldn't do anything
                SW[0] <= 1'b0; 
                for (i = 0; i < 2**5; i++) begin
                        SW[8:4] <= i;
                        SW[3:1] <= 3'b000;
                        @(posedge CLOCK_50);
                        $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                                 i, SW[8:4], SW[8:4], SW[3:1], SW[3:1], dut.data_out, dut.data_out);
                end // for loop
                // one additional clock edge to see the read of the 31st word line because 
                // the read happens one clock cycle after the write
                @(posedge CLOCK_50);
                $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                         i, SW[8:4], SW[8:4], SW[3:1], SW[3:1], dut.data_out, dut.data_out);

                $stop; // end simulation
        end // initial signals


endmodule  // DE1_SoC_testbench