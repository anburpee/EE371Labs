module DE1_SoC_tb ();
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;

    DE1_SoC dut (.*);

    // simulation clock
    parameter period = 100;
    initial begin
        clk <= 0;
        forever #(period/2) clk <= ~clk;
    end

    // test the design
    initial begin
        KEY[3] <= 1'b0;     @(posedge clk);
        KEY[3] <= 1'b1;         

        repeat(9) @(posedge done);
        
        $stop;
    end // initial
endmodule // DE1_SoC_tb