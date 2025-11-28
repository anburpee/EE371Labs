module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW,
					 CLOCK_50, VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
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

	logic reset;
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	
	// INSTANTIATING VIDEO_DRIVER -- MODIFY THE PORTS BELOW TO THE RGB OF THE BOARD
	video_driver #(.WIDTH(640), .HEIGHT(480))
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
	
	always_ff @(posedge CLOCK_50) begin
		r <= SW[7:0];
		g <= x[7:0];
		b <= y[7:0];
	end

	// 1. on KEY press, check the selected location (SW 5:0)
	// is the spot valid? 

	// 2. is the KEY press a valid direction for that token?
	// either the next diag spot is empty OR (it has opponent color AND next-next diag is empty)

	// 3. updating RAMs (after key press)
	black_ram16x7 black_ram_inst (.address(), .clock(CLOCK_50), .data(), .wren(), .q());
	red_ram16x7 red_ram_inst (.address(), .clock(CLOCK_50), .data(), .wren(), .q());	
	
	// 4. updating VGA display after updating RAMs

	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign reset = 0;
	
endmodule  // DE1_SoC


`timescale 1 ps / 1 ps
module DE1_SoC_testbench ();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR, SW;
	logic [3:0] KEY;
	logic CLOCK_50;
	logic [7:0] VGA_R, VGA_G, VGA_B;
	logic VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS;
	
	// instantiate module
	DE1_SoC dut (.*);
	
	// create simulated clock
	parameter T = 20;
	initial begin
		CLOCK_50 <= 0;
		forever #(T/2) CLOCK_50 <= ~CLOCK_50;
	end  // clock initial
	
	// simulated inputs
	initial begin
		
		$stop();
	end  // inputs initial
	
endmodule  // DE1_SoC_testbench