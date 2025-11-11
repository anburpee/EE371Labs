/* Top level module of the FPGA for task2 that takes the onboard resources as 
 * input and outputs the lines drawn from the VGA port.
 *
 * Inputs:
 *   KEY 			- On board keys of the FPGA
 *   SW 			- On board switches of the FPGA
 *   CLOCK_50 		- On board 50 MHz clock of the FPGA
 *
 * Outputs:
 *   HEX 			- On board 7 segment displays of the FPGA
 *   LEDR 			- On board LEDs of the FPGA
 *   VGA_R 			- Red data of the VGA connection
 *   VGA_G 			- Green data of the VGA connection
 *   VGA_B 			- Blue data of the VGA connection
 *   VGA_BLANK_N 	- Blanking interval of the VGA connection
 *   VGA_CLK 		- VGA's clock signal
 *   VGA_HS 		- Horizontal Sync of the VGA connection
 *   VGA_SYNC_N 	- Enable signal for the sync of the VGA connection
 *   VGA_VS 		- Vertical Sync of the VGA connection
 */
module task2_top (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
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
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR[8:0] = SW[8:0];


	// handle metastability for reset button
	logic reset, key3;
	anti_metastability anti (.clk(CLOCK_50), .in(KEY[3]), .out(key3));

	assign reset = ~key3;

	logic [10:0] x0, y0, x1, y1, x, y;
	logic write;

	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset, 
		.x, 
		.y,
		.pixel_color	(1'b1), 
		.pixel_write	(write), // changed from 1'b1
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N));


	// divided clock for line_drawer
	logic [31:0] div_clks;
	clock_divider clock_div (.clock(CLOCK_50), .reset, .divided_clocks(div_clks));
	logic clk;
	assign clk = div_clks[19]; // for board
	// assign clk = CLOCK_50; // for simulation

	// instantiate line_drawer
	logic done;
	line_drawer lines (.clk, .reset, .x0, .y0, .x1, .y1, .x, .y, .write, .done); // added write
	
	assign LEDR[9] = done;


	// counter and logic for updating input coordinates
	logic [3:0] count;
	always_ff @(posedge clk) begin // for board
		if (reset) begin
			count <= 0;
			x0 <= 0;
		    y0 <= 0;
			x1 <= 100;
			y1 <= 50;
		end
		else begin
			if (done) begin
				count <= count + 1;
				// diagonals -- not steep
				// count hasn't updated from previous count yet at this point
				if (count == 4'd0) begin // left up
					x0 <= 100;
					y0 <= 50;
					x1 <= 200;
					y1 <= 0;
				end
				else if (count == 4'd1) begin // right down
					x0 <= 300;
					y0 <= 0;
					x1 <= 200;
					y1 <= 50;
				end
				else if (count == 4'd2) begin // right up
					x0 <= 400;
					y0 <= 50;
					x1 <= 300;
					y1 <= 0;
				end
				// steep
				else if (count == 4'd3) begin // left down
					x0 <= 0;
					y0 <= 50;
					x1 <= 50;
					y1 <= 200;
				end
				else if (count == 4'd4) begin // left up
					x0 <= 50;
					y0 <= 200;
					x1 <= 100;
					y1 <= 50;
				end
				else if (count == 4'd5) begin // right down
					x0 <= 150;
					y0 <= 50;
					x1 <= 100;
					y1 <= 200;
				end
				else if (count == 4'd6) begin // right up
					x0 <= 200;
					y0 <= 200;
					x1 <= 150;
					y1 <= 50;
				end
				// vertical
				else if (count == 4'd7) begin // right up
					x0 <= 250;
					y0 <= 200;
					x1 <= 250;
					y1 <= 50;
				end
				// horizontal
				else if (count == 4'd8) begin // right up
					x0 <= 250;
					y0 <= 200;
					x1 <= 300;
					y1 <= 200;
				end
			end
		end
	end // always_ff	

	// always_ff @(posedge clk) begin	// for simulation
	// 	if (reset) begin
	// 		count <= 0;
	// 		x0 <= 0;
	// 	    y0 <= 0;
	// 		x1 <= 10;
	// 		y1 <= 5;
	// 	end
	// 	else begin
	// 		if (done) begin
	// 			count <= count + 1;
	// 			// diagonals -- not steep
	// 			// count hasn't updated yet
	// 			if (count == 4'd0) begin // left up
	// 				x0 <= 10;
	// 				y0 <= 5;
	// 				x1 <= 20;
	// 				y1 <= 0;
	// 			end
	// 			else if (count == 4'd1) begin // right down
	// 				x0 <= 30;
	// 				y0 <= 0;
	// 				x1 <= 20;
	// 				y1 <= 5;
	// 			end
	// 			else if (count == 4'd2) begin // right up
	// 				x0 <= 40;
	// 				y0 <= 5;
	// 				x1 <= 30;
	// 				y1 <= 0;
	// 			end
	// 			// steep
	// 			else if (count == 4'd3) begin // left down
	// 				x0 <= 0;
	// 				y0 <= 5;
	// 				x1 <= 5;
	// 				y1 <= 20;
	// 			end
	// 			else if (count == 4'd4) begin // left up
	// 				x0 <= 5;
	// 				y0 <= 20;
	// 				x1 <= 10;
	// 				y1 <= 5;
	// 			end
	// 			else if (count == 4'd5) begin // right down
	// 				x0 <= 15;
	// 				y0 <= 5;
	// 				x1 <= 10;
	// 				y1 <= 20;
	// 			end
	// 			else if (count == 4'd6) begin // right up
	// 				x0 <= 20;
	// 				y0 <= 20;
	// 				x1 <= 15;
	// 				y1 <= 5;
	// 			end
	// 			// vertical
	// 			else if (count == 4'd7) begin // right up
	// 				x0 <= 25;
	// 				y0 <= 20;
	// 				x1 <= 25;
	// 				y1 <= 5;
	// 			end
	// 			// horizontal
	// 			else if (count == 4'd8) begin // right up
	// 				x0 <= 25;
	// 				y0 <= 20;
	// 				x1 <= 30;
	// 				y1 <= 20;
	// 			end
	// 		end
	// 	end
	// end // always_ff

endmodule  // task2_top