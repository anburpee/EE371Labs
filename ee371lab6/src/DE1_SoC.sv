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

	localparam int FLASH_CYCLES = 63; // set to 2**n - 1

	logic reset;
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	
	// INSTANTIATING VIDEO_DRIVER -- MODIFY THE PORTS BELOW TO THE RGB OF THE BOARD
	video_driver #(.WIDTH(640), .HEIGHT(480)) // setting width to 640 and height to 480 means the output x,y changes every clock cycle
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
	


	// logic signals for ram_update
	logic clk;  // input (reset already declared above)
	logic [3:0] key;
    logic [5:0] sw;
	logic invalid_move, reds_turn, game_over; // outputs
	assign clk = CLOCK_50;
	assign reset = SW[9];
	assign key = ~KEY; // KEYs are active low
	assign sw = SW[5:0];


	////////////////v3//////////////////
	// even_iter & having 2 RAMs is to make sure RAMs are not written to by ram_update and read from display_update at the same time @ load_skip
	logic even_iter; // toggles every iteration
	// should instead be write_in_progress that goes high @ load_skip, load_adj, and check_done
	logic [5:0] encodings_addr1_even;
	logic [5:0] encodings_addr2_even;
	logic [2:0] encodings_data1_even;
	logic [2:0] encodings_data2_even;
	// logic encodings_wren1_even;
	// logic encodings_wren2_even;
	logic [5:0] encodings_addr1_odd;
	logic [5:0] encodings_addr2_odd;
	logic [2:0] encodings_data1_odd;
	logic [2:0] encodings_data2_odd;
	// logic encodings_wren1_odd;
	// logic encodings_wren2_odd;
	////////////////v3//////////////////


	// instantiate ram_update module
	ram_update_v3 game_logic_module (.*);

	assign LEDR[9] = game_over ? 1'b0 : ~reds_turn;
	assign LEDR[0] = game_over ? 1'b0 : reds_turn;
	assign LEDR[7:2] = {6{game_over}};

	// flash all HEX displays at an invalid move
	logic [$clog2(FLASH_CYCLES)-1:0] flash_count; // down counter
	logic flashing;
	always_ff @(posedge clk) begin
		if (reset) begin
			flash_count <= 0;
			flashing <= 1'b0;
		end
		else begin
			if (invalid_move) begin
				flash_count <= FLASH_CYCLES;
				flashing <= 1'b1;
			end 
			else if (flash_count != 0) begin
				flash_count <= flash_count - 1;

				if (flash_count == 1) begin
					flashing <= 1'b0;
				end
			end
		end
	end // always_ff

	assign HEX0 = {7{flashing ? 1'b0 : 1'b1}};	// HEX displays are active low
	assign HEX1 = {7{flashing ? 1'b0 : 1'b1}};
	assign HEX2 = {7{flashing ? 1'b0 : 1'b1}};
	assign HEX3 = {7{flashing ? 1'b0 : 1'b1}};
	assign HEX4 = {7{flashing ? 1'b0 : 1'b1}};
	assign HEX5 = {7{flashing ? 1'b0 : 1'b1}};


	// instantiate 64x3 RAMs storing the encodings for the type of spot each square is on the board
	logic [5:0] read_addr; // 0 ~ 63
	logic [2:0] q_even, q_odd, q_unused_even, q_unused_odd;
	// only need to MUX the sencond address/wren since we're only reading from port 2
	spot_encodings64x3 spot_encodings_even (
		.address_a(encodings_addr1_even),
		.address_b(even_iter ? encodings_addr2_even : read_addr),
		.clock(CLOCK_50),
		.data_a(encodings_data1_even),
		.data_b(encodings_data2_even),
		.wren_a(1'b1),	// never needs to be 0 since we never read from port1
		.wren_b(even_iter ? 1'b1 : 1'b0), // on even iterations, wren for spot_encodings_even is always high
		// .wren_a(1'b1),
		// .wren_b(even_iter ? encogings_wren1_even : 1'b0),
		.q_a(q_unused_even),	// connects to display_update
		.q_b(q_even)
	);

	spot_encodings64x3 spot_encodings_odd (
		.address_a(encodings_addr1_odd),
		.address_b(even_iter ? read_addr : encodings_addr2_odd),
		.clock(CLOCK_50),
		.data_a(encodings_data1_odd),
		.data_b(encodings_data2_odd),
		.wren_a(1'b1),	// never needs to be 0 since we never read from port1
		.wren_b(even_iter ? 1'b0 : 1'b1), // on odd iterations, wren for spot_encodings_odd is always high
		// .wren_a(1'b1),
		// .wren_b(even_iter ? 1'b0 : encodings_wren2_odd),
		.q_a(q_unused_odd),	// connects to display_update
		.q_b(q_odd)
	);

	
	// delete/comment out when done testing:
	// assign read_addr = 6'd0;

	// instantiate display_update
	display_update rgb_vals (
		// inputs
		.clk,
		.reset, 
		.x_vga(x), 
		.y_vga(y), 
		.encoding(even_iter ? q_odd : q_even),
		// outputs  
		.read_addr,
        .r,
        .g,
        .b
    );



	
endmodule  // DE1_SoC