// testbench for task2_top.sv
module task2_top_tb ();
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic CLOCK_50;
	logic [7:0] VGA_R;
    logic [7:0] VGA_G;
	logic [7:0] VGA_B;
	logic VGA_BLANK_N;
	logic VGA_CLK;
	logic VGA_HS;
	logic VGA_SYNC_N;
	logic VGA_VS;

    task2_top dut (.*);

    // simulation clock
    parameter period = 100;
    initial begin
        CLOCK_50 <= 0;
        forever #(period/2) CLOCK_50 <= ~CLOCK_50;
    end

    // test the design
    initial begin
        KEY[3] <= 1'b0;     repeat(5) @(posedge CLOCK_50);
        KEY[3] <= 1'b1;    

        // repeat(100) @(posedge CLOCK_50);
        repeat(9) @(posedge LEDR[9]);
        @(posedge CLOCK_50);
        
        KEY[3] <= 1'b0;     repeat(5) @(posedge CLOCK_50);
        KEY[3] <= 1'b1;

        repeat(3) @(posedge LEDR[9]);
        @(posedge CLOCK_50);


        $stop; // stop simulation
    end // initial
endmodule // task2_top_tb