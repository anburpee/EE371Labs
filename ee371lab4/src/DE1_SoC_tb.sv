// testbench for DE1_SoC.sv
`timescale 1 ps / 1 ps
module DE1_SoC_tb ();
    logic CLOCK_50;
    logic [9:0] SW;
    logic [3:0] KEY;
    logic [6:0] HEX0, HEX1;
    logic [9:0] LEDR;

    // instantiate DUT
    DE1_SoC dut (.*);

    // set up clock
    parameter period = 100;
    initial begin
        CLOCK_50 <= 0;
        forever #(period/2) CLOCK_50 <= ~CLOCK_50;
    end // initial clock

    // test the design
    initial begin
        // reset
        KEY[0] <= 1'b0;                                             @(posedge CLOCK_50);
        KEY[0] <= 1'b1; 
        SW[9] <= 1'b1; // task2
        
        // start is FALSE
        KEY[3] <= 1'b1;      SW[7:0] <= 8'd173;          repeat(3)  @(posedge CLOCK_50);

        // start is TRUE
        KEY[3] <= 1'b0;                                  
        repeat(5) @(posedge CLOCK_50); // at this point task 1 hasn't been completed yet
                            // because the 8'd173 is stored at the middle value of 
                            // the RAM (first address to be read)

        SW[9] <= 1'b0; // switch to task1           
        repeat(10) @(posedge CLOCK_50);


        $stop; //stop simultaion
    end // initial 

endmodule // DE1_SoC_tb