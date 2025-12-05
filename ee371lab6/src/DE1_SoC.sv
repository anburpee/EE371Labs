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
	video_driver #(.WIDTH(640), .HEIGHT(480)) // setting width to 640 and height to 480 means the output x,y changes every clock cycle
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
	
	always_ff @(posedge CLOCK_50) begin
		r <= SW[7:0];
		g <= x[7:0];
		b <= y[7:0];
	end


	////////////////v3//////////////////
	// even_iter & having 2 RAMs is to make sure RAMs are not written to by ram_update and read from display_update at the same time @ load_skip
	// logic even_iter, // toggles every iteration
	// should instead be write_in_progress that goes high @ load_skip, load_adj, and check_done
	// logic [5:0] encodings_addr1_even, 
	// logic [5:0] encodings_addr2_even, 
	// logic [2:0] encodings_data1_even,
	// logic [2:0] encodings_data2_even,
	// logic encodings_wren1_even,
	// logic encodings_wren2_even,
	// logic [5:0] encodings_addr1_odd, 
	// logic [5:0] encodings_addr2_odd, 
	// logic [2:0] encodings_data1_odd,
	// logic [2:0] encodings_data2_odd,
	// logic encodings_wren1_odd,
	// logic encodings_wren2_odd
	////////////////v3//////////////////

		// only need to MUX the sencod address/wren since we're only reading from port 2
	spot_encodings64x3 spot_encodings_even (
		.address_a(encodings_addr1_even),
		.address_b(encodings_addr2_even),
		.clock,
		.data_a(encodings_data1_even),
		.data_b(encodings_data2_even),
		.wren_a(1'b1),	// never needs to be 0 since we never read from port1
		.wren_b(even_iter ? 1'b1 : 1'b0), // on even iterations, wren for spot_encodings_even is always high
		// .wren_a(1'b1),
		// .wren_b(even_iter ? encogings_wren1_even : 1'b0),
		.q_a(q_even),	// connects to display_update
		.q_b(q_unused_even)
	);

	spot_encodings64x3 spot_encodings_odd (
		.address_a(encodings_addr1_odd),
		.address_b(encodings_addr2_odd),
		.clock,
		.data_a(encodings_data1_odd),
		.data_b(encodings_data2_odd),
		.wren_a(1'b1),	// never needs to be 0 since we never read from port1
		.wren_b(even_iter ? 1'b0 : 1'b1), // on odd iterations, wren for spot_encodings_odd is always high
		// .wren_a(1'b1),
		// .wren_b(even_iter ? 1'b0 : encodings_wren2_odd),
		.q_a(q_odd),	// connects to display_update
		.q_b(q_unused_odd)
	);

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