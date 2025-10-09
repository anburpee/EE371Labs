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


        // system clock
        logic clk;
        assign clk = CLOCK_50;

        // put inputs through anti-metastability modules
        anti_metastability stable_reset (.clk(clk), .in(KEY[3]), .out(key3));
        anti_metastability stable_clk2 (.clk(clk), .in(KEY[0]), .out(key0));
        anti_metastability stable_sw0 (.clk(clk), .in(SW[0]), .out(sw0));
        anti_metastability stable_sw1 (.clk(clk), .in(SW[1]), .out(sw1));
        anti_metastability stable_sw2 (.clk(clk), .in(SW[2]), .out(sw2));
        anti_metastability stable_sw3 (.clk(clk), .in(SW[3]), .out(sw3));
        anti_metastability stable_sw4 (.clk(clk), .in(SW[4]), .out(sw4));
        anti_metastability stable_sw5 (.clk(clk), .in(SW[5]), .out(sw5));
        anti_metastability stable_sw6 (.clk(clk), .in(SW[6]), .out(sw6));
        anti_metastability stable_sw7 (.clk(clk), .in(SW[7]), .out(sw7));
        anti_metastability stable_sw8 (.clk(clk), .in(SW[8]), .out(sw8));
        anti_metastability stable_sw9 (.clk(clk), .in(SW[9]), .out(sw9));

//     // Set up reset signal and clock
//     // ***commented out clock divider since not needed for Lab1***
        logic reset;
 	assign reset = ~key3;

        // task 2 clock
        logic clk_tsk2;
        assign clk_tsk2 = ~key0; 


        // logic [31:0] div_clock;
        // // comment out one clock based on whether using simulation or pushing to board
        // // assign clk = div_clock[25]; // change clock speed by changing which clock to use on board
	//assign clk = CLOCK_50; // for simulation or if using clock_50 in design
  
	// set up clock divider
	// clock_divider divider (.clock(CLOCK_50), .divided_clocks(div_clock));


        logic [4:0] w_address;
        assign w_address = {sw8, sw7, sw6, sw5, sw4};

        logic [2:0] data_in;
        assign data_in = {sw3, sw2, sw1};

        logic wren_tsk2, wren_tsk3;


        // wren is specified for task2 only when SW[9] == 0
        // wren is specified for task3 only when SW[9] == 1
        always_comb begin
                if (sw9) begin
                        wren_tsk2 = 1'b0;
                        wren_tsk3 = sw0;
                end
                else begin
                        wren_tsk2 = sw0;
                        wren_tsk3 = 1'b0;
                end
        end // always_comb


        // instantiate module that cycles through read addresses
        enabled_counter r_addresses (.clk(clk), .reset(reset), .count(r_address));

        // instantiate task2 and task3 modules
        logic [2:0] data_out, data_out_tsk2, data_out_tsk3;


        task2 task_2 (.clk(clk_tsk2), .address(w_address), .data_in(data_in),
                      .wren(wren_tsk2), .data_out(data_out_tsk2));

        task3 task_3 (.clk(clk), .wren(wren_tsk3), .w_address(w_address),
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
                CLOCK_50 <= 0;
                forever #(period/2) CLOCK_50 <= ~CLOCK_50;
        end

        initial begin
                KEY[0] <= 1;
                forever #(period/2) KEY[0] <= ~KEY[0];
        end

        // test the design
        integer i;
        initial begin
                // don't need task1 testbench since we don't instantiate task2 in top level
                $display ("----------------- WE STILL NEED TO DISPLAY TESTBENCH STUFF FOR TASK 1 !!!! -------------------");



                KEY[3] <= 1'b0;
                @(posedge CLOCK_50);
                KEY[3] <= 1'b1;
                @(posedge CLOCK_50);


                $display ("----------------- TESTBENCH TASK 2 -------------------");
                $display ("----------------- turn write enable ON -------------------");


                SW[0] <= 1'b1; @(posedge ~KEY[0]); // write-enabled
                SW[9] <= 1'b0; // write to task2
                for (i = 0; i < 2**5; i++) begin
                        SW[8:4] <= i;
                        SW[3:1] <= 3'b000; // repeats values 0-7 since values are truncated to 3 bits
                        @(posedge ~KEY[0]);
                        $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                                  i, SW[8:4], SW[8:4], dut.data_in, dut.data_in, dut.data_out, dut.data_out);
                end // for loop
                
                // write in data (cycles through 0-7)
                for (i = 0; i < 2**5; i++) begin
                        SW[8:4] <= i;
                        SW[3:1] <= i; // repeats values 0-7 since values are truncated to 3 bits
                        @(posedge ~KEY[0]);
                        $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                                  i, SW[8:4], SW[8:4], dut.data_in, dut.data_in, dut.data_out, dut.data_out);
                end // for loop

                $display ("----------------- turn write enable OFF -------------------");

                // so writing anything to the addresses shouldn't do anything
                SW[0] <= 1'b0; // write enable off
                for (i = 0; i < 2**5; i++) begin
                        SW[8:4] <= i;
                        SW[3:1] <= 3'b000;
                        @(posedge ~KEY[0]);
                        $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                                 i, SW[8:4], SW[8:4], dut.data_in, dut.data_in, dut.data_out, dut.data_out);
                end // for loop


                $display ("----------------- NOW TESTBENCH TASK 3 -------------------");
                $display ("----------------- turn write enable ON -------------------");

                KEY[3] <= 1'b0;
                @(posedge CLOCK_50);
                KEY[3] <= 1'b1;
                @(posedge CLOCK_50);

                SW[0] <= 1'b1; @(posedge CLOCK_50); // write-enabled
                SW[9] <= 1'b1; // write to task3
                for (i = 0; i < 2**5; i++) begin
                        SW[8:4] <= i;
                        SW[3:1] <= 3'b000; // repeats values 0-7 since values are truncated to 3 bits
                        @(posedge CLOCK_50);
                        $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                                  i, SW[8:4], SW[8:4], dut.data_in, dut.data_in, dut.data_out, dut.data_out);
                end // for loop
                
                // write in data (cycles through 0-7)
                for (i = 0; i < 2**5; i++) begin
                        SW[8:4] <= i;
                        SW[3:1] <= i; // repeats values 0-7 since values are truncated to 3 bits
                        @(posedge CLOCK_50);
                        $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                                  i, SW[8:4], SW[8:4], dut.data_in, dut.data_in, dut.data_out, dut.data_out);
                end // for loop

                $display ("----------------- turn write enable OFF -------------------");

                // so writing anything to the addresses shouldn't do anything
                SW[0] <= 1'b0; // write enable off
                for (i = 0; i < 2**5; i++) begin
                        SW[8:4] <= i;
                        SW[3:1] <= 3'b000;
                        @(posedge CLOCK_50);
                        $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                                 i, SW[8:4], SW[8:4], dut.data_in, dut.data_in, dut.data_out, dut.data_out);
                end // for loop


                $stop; // end simulation
        end // initial signals


endmodule  // DE1_SoC_testbench