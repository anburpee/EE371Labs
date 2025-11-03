// testbench for task2_top.sv
`timescale 1 ps / 1 ps
module task2_top_tb();
    logic CLOCK_50;
    logic [9:0] SW;
    logic [3:0] KEY;
    logic [6:0] HEX0, HEX1;
    logic [9:0] LEDR;

    // instantiate DUT
    task2_top dut (.*);

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
        
        // stays in s_idle
        KEY[3] <= 1'b1;      SW[7:0] <= 8'd171;     repeat(3)  @(posedge CLOCK_50);

        // initializes pointers + loc
        KEY[3] <= 1'b0;     
        @(posedge LEDR[9]);

        // back to s1
        KEY[3] <= 1'b1;                                  repeat(5) @(posedge CLOCK_50);




        // reset
        KEY[0] <= 1'b0;                                                   @(posedge CLOCK_50);
        // A value stored at a lower index than the middle
        KEY[0] <= 1'b1;   KEY[3] <= 1'b1;   SW[7:0] <= 8'd170;   repeat(3) @(posedge CLOCK_50);

        KEY[3] <= 1'b0;                                   @(posedge LEDR[9]);
                                                repeat(2) @(posedge CLOCK_50);

        // reset
        KEY[0] <= 1'b0;                         repeat(3) @(posedge CLOCK_50);

        // value of A stored at middle index
        KEY[0] <= 1'b1;  SW[7:0] <= 8'd173;               @(posedge LEDR[9]);
                                                repeat(2) @(posedge CLOCK_50);

        // reset
        KEY[0] <= 1'b0;                         repeat(3) @(posedge CLOCK_50);

        // try a value of A that doesn't exist
        KEY[0] <= 1'b1;  SW[7:0] <= 8'd10;                @(posedge LEDR[9]);
                                                repeat(2) @(posedge CLOCK_50);

        // reset
        KEY[0] <= 1'b0;                         repeat(3) @(posedge CLOCK_50);

        // try another value of A
        KEY[0] <= 1'b1;  SW[7:0] <= 8'd228;               @(posedge LEDR[9]);
                                                repeat(2) @(posedge CLOCK_50);

        $stop; //stop simultaion
    end // initial 
endmodule // task2_top_tb