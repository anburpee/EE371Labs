/* Top level module of the FPGA that takes the onboard resources 
 * as input and outputs the lines drawn from the VGA port.
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
module task3_tung_tung_tung_sahur (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
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

	//////////////////////////////////////////////////////////////////////////////////
	// logic to cycle through all coordinates of the display when reset is pressed
	// using the clearing signal instead of just reset makes sure that even if 
	// reset is deasserted before the screen is done clearing, the screen will still
	// be wiped
	logic [10:0] xcounter, ycounter;
	logic clearing;
	always_ff @(posedge CLOCK_50) begin
		if (reset) begin
			clearing <= 1'b1;
			xcounter <= 0;
			ycounter <= 0;
		end
		else if (clearing) begin
			if (xcounter == 639) begin	// last column
				xcounter <= 0;
				if (ycounter == 479) begin // last column, last row
					clearing <= 1'b0;
				end 
				else begin	// last column, not last row
					ycounter <= ycounter + 1;
				end
			end
			else begin	// not last column
				xcounter <= xcounter + 1;
			end
		end
	end // always_ff
	/////////////////////////////////////////////////////////////////////////////////

	logic [10:0] x0, y0, x1, y1, x, y;
	logic write;

	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset, 		
		.x  			(clearing ? xcounter : x),
		.y  			(clearing ? ycounter : y),
		.pixel_color	(clearing ? 1'b0 : 1'b1),
		.pixel_write	(clearing ? 1'b1 : write),
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N));
				

	// clock divider for line drawer
	logic [31:0] div_clks;
	clock_divider clock_div (.clock(CLOCK_50), .reset(reset), .divided_clocks(div_clks));
	logic line_drawer_clk;
	assign line_drawer_clk = div_clks[16];
	// assign line_drawer_clk = CLOCK_50; 


	logic done;
	line_drawer lines (.clk(line_drawer_clk), .reset(reset || clearing), .x0, .y0, .x1, .y1, .x, .y, .write, .done);
	
	assign LEDR[9] = done;


	// counter for updating input coordinates
	logic [7:0] count;
	always_ff @(posedge line_drawer_clk) begin
		if (reset || clearing) begin
			count <= 0;
			x0 <= 95;
			y0 <= 55;
			x1 <= 100;
			y1 <= 55;
		end
		else begin
			if (done) begin
				count <= count + 1;
				// left eye
				if (count == 8'd0) begin 
					x0 <= 100;
					y0 <= 55;
					x1 <= 105;
					y1 <= 58;
				end
				else if (count == 8'd1) begin 
					x0 <= 105;
					y0 <= 58;
					x1 <= 105;
					y1 <= 63;
				end
				else if (count == 8'd2) begin 
					x0 <= 105;
					y0 <= 63;
					x1 <= 100;
					y1 <= 66;
				end
				else if (count == 8'd3) begin 
					x0 <= 100;
					y0 <= 66;
					x1 <= 95;
					y1 <= 66;
				end
				else if (count == 8'd4) begin 
					x0 <= 95;
					y0 <= 66;
					x1 <= 90;
					y1 <= 63;
				end
				else if (count == 8'd5) begin 
					x0 <= 90;
					y0 <= 63;
					x1 <= 90;
					y1 <= 58;
				end
				else if (count == 8'd6) begin 
					x0 <= 90;
					y0 <= 58;
					x1 <= 95;
					y1 <= 55;
				end
				// left eyelid
				else if (count == 8'd7) begin 
					x0 <= 83;
					y0 <= 60;
					x1 <= 95;
					y1 <= 50;
				end
				else if (count == 8'd8) begin 
					x0 <= 95;
					y0 <= 50;
					x1 <= 105;
					y1 <= 50;
				end
				else if (count == 8'd9) begin 
					x0 <= 105;
					y0 <= 50;
					x1 <= 113;
					y1 <= 63;
				end
				else if (count == 8'd10) begin 
					x0 <= 113;
					y0 <= 63;
					x1 <= 105;
					y1 <= 70;
				end
				else if (count == 8'd11) begin 
					x0 <= 105;
					y0 <= 70;
					x1 <= 95;
					y1 <= 70;
				end
				else if (count == 8'd12) begin 
					x0 <= 95;
					y0 <= 70;
					x1 <= 83;
					y1 <= 60;
				end
				// outer eyelid
				else if (count == 8'd13) begin 
					x0 <= 83;
					y0 <= 60;
					x1 <= 95;
					y1 <= 45;
				end
				else if (count == 8'd14) begin 
					x0 <= 95;
					y0 <= 45;
					x1 <= 105;
					y1 <= 45;
				end
				else if (count == 8'd15) begin 
					x0 <= 105;
					y0 <= 45;
					x1 <= 113;
					y1 <= 63;
				end
				else if (count == 8'd16) begin 
					x0 <= 113;
					y0 <= 63;
					x1 <= 105;
					y1 <= 75;
				end
				else if (count == 8'd17) begin 
					x0 <= 105;
					y0 <= 75;
					x1 <= 95;
					y1 <= 75;
				end
				else if (count == 8'd18) begin 
					x0 <= 95;
					y0 <= 75;
					x1 <= 85;
					y1 <= 70;
				end
				else if (count == 8'd19) begin 
					x0 <= 85;
					y0 <= 70;
					x1 <= 83;
					y1 <= 60;
				end 
				// left upper face
				else if (count == 8'd20) begin 
					x0 <= 83;
					y0 <= 60;
					x1 <= 85;
					y1 <= 40;
				end
				else if (count == 8'd21) begin 
					x0 <= 85;
					y0 <= 40;
					x1 <= 92;
					y1 <= 33;
				end
				else if (count == 8'd22) begin 
					x0 <= 92;
					y0 <= 33;
					x1 <= 112;
					y1 <= 33;
				end
				else if (count == 8'd23) begin 
					x0 <= 112;
					y0 <= 33;
					x1 <= 112;
					y1 <= 40;
				end
				else if (count == 8'd24) begin 
					x0 <= 112;
					y0 <= 40;
					x1 <= 100;
					y1 <= 36;
				end
				else if (count == 8'd25) begin 
					x0 <= 100;
					y0 <= 36;
					x1 <= 85;
					y1 <= 40;
				end // done with left brow
				// right eyeball
				else if (count == 8'd26) begin 
					x0 <= 135;
					y0 <= 55;
					x1 <= 139;
					y1 <= 50;
				end
				else if (count == 8'd27) begin 
					x0 <= 139;
					y0 <= 50;
					x1 <= 146;
					y1 <= 50;
				end
				else if (count == 8'd28) begin 
					x0 <= 146;
					y0 <= 50;
					x1 <= 150;
					y1 <= 55;
				end
				else if (count == 8'd29) begin 
					x0 <= 150;
					y0 <= 55;
					x1 <= 150;
					y1 <= 61;
				end
				else if (count == 8'd30) begin 
					x0 <= 150;
					y0 <= 61;
					x1 <= 146;
					y1 <= 65;
				end
				else if (count == 8'd31) begin 
					x0 <= 146;
					y0 <= 65;
					x1 <= 139;
					y1 <= 65;
				end
				else if (count == 8'd32) begin 
					x0 <= 139;
					y0 <= 65;
					x1 <= 135;
					y1 <= 61;
				end
				else if (count == 8'd33) begin 
					x0 <= 135;
					y0 <= 61;
					x1 <= 135;
					y1 <= 55;
				end
				// right eyelid (inner)
				else if (count == 8'd34) begin 
					x0 <= 127;
					y0 <= 60;
					x1 <= 135;
					y1 <= 50;
				end
				else if (count == 8'd35) begin 
					x0 <= 135;
					y0 <= 50;
					x1 <= 140;
					y1 <= 47;
				end
				else if (count == 8'd36) begin 
					x0 <= 140;
					y0 <= 47;
					x1 <= 150;
					y1 <= 50;
				end
				else if (count == 8'd37) begin 
					x0 <= 150;
					y0 <= 50;
					x1 <= 160;
					y1 <= 60;
				end
				else if (count == 8'd38) begin 
					x0 <= 160;
					y0 <= 60;
					x1 <= 146;
					y1 <= 68;
				end
				else if (count == 8'd39) begin 
					x0 <= 146;
					y0 <= 68;
					x1 <= 135;
					y1 <= 68;
				end
				else if (count == 8'd40) begin 
					x0 <= 135;
					y0 <= 68;
					x1 <= 127;
					y1 <= 60;
				end
				// right outer eyelid
				else if (count == 8'd41) begin 
					x0 <= 127;
					y0 <= 60;
					x1 <= 135;
					y1 <= 45;
				end
				else if (count == 8'd42) begin 
					x0 <= 135;
					y0 <= 45;
					x1 <= 140;
					y1 <= 40;
				end
				else if (count == 8'd43) begin 
					x0 <= 140;
					y0 <= 40;
					x1 <= 150;
					y1 <= 42;
				end
				else if (count == 8'd44) begin 
					x0 <= 150;
					y0 <= 42;
					x1 <= 160;
					y1 <= 60;
				end
				else if (count == 8'd45) begin 
					x0 <= 160;
					y0 <= 60;
					x1 <= 150;
					y1 <= 70;
				end
				else if (count == 8'd46) begin 
					x0 <= 150;
					y0 <= 70;
					x1 <= 140;
					y1 <= 73;
				end
				else if (count == 8'd47) begin 
					x0 <= 140;
					y0 <= 73;
					x1 <= 130;
					y1 <= 70;
				end
				else if (count == 8'd48) begin 
					x0 <= 130;
					y0 <= 70;
					x1 <= 127;
					y1 <= 60;
				end
				// right eyebrow
				else if (count == 8'd49) begin 
					x0 <= 125;
					y0 <= 33;
					x1 <= 140;
					y1 <= 30;
				end
				else if (count == 8'd50) begin 
					x0 <= 140;
					y0 <= 30;
					x1 <= 150;
					y1 <= 30;
				end
				else if (count == 8'd51) begin 
					x0 <= 150;
					y0 <= 30;
					x1 <= 170;
					y1 <= 40;
				end
				else if (count == 8'd52) begin 
					x0 <= 170;
					y0 <= 40;
					x1 <= 150;
					y1 <= 35;
				end
				else if (count == 8'd53) begin 
					x0 <= 150;
					y0 <= 35;
					x1 <= 140;
					y1 <= 35;
				end
				else if (count == 8'd54) begin 
					x0 <= 140;
					y0 <= 35;
					x1 <= 125;
					y1 <= 40;
				end
				else if (count == 8'd55) begin 
					x0 <= 125;
					y0 <= 40;
					x1 <= 125;
					y1 <= 33;
				end
				// nose //////////////////
				else if (count == 8'd56) begin 
					x0 <= 120;
					y0 <= 46;
					x1 <= 110;
					y1 <= 85;
				end
				else if (count == 8'd57) begin 
					x0 <= 110;
					y0 <= 85;
					x1 <= 114;
					y1 <= 93;
				end
				else if (count == 8'd58) begin 
					x0 <= 114;
					y0 <= 93;
					x1 <= 120;
					y1 <= 95;
				end
				else if (count == 8'd59) begin  // left nostril
					x0 <= 110;
					y0 <= 82;
					x1 <= 106;
					y1 <= 85;
				end
				else if (count == 8'd60) begin 
					x0 <= 106;
					y0 <= 85;
					x1 <= 108;
					y1 <= 90;
				end
				else if (count == 8'd61) begin 
					x0 <= 108;
					y0 <= 90;
					x1 <= 114;
					y1 <= 93;
				end
				else if (count == 8'd62) begin // right nostril
					x0 <= 125;
					y0 <= 82;
					x1 <= 132;
					y1 <= 80;
				end
				else if (count == 8'd63) begin 
					x0 <= 132;
					y0 <= 80;
					x1 <= 136;
					y1 <= 85;
				end
				else if (count == 8'd64) begin 
					x0 <= 136;
					y0 <= 85;
					x1 <= 132;
					y1 <= 92;
				end
				else if (count == 8'd65) begin 
					x0 <= 132;
					y0 <= 92;
					x1 <= 125;
					y1 <= 92;
				end
				// cheeks ////////////
				else if (count == 8'd66) begin // left cheek
					x0 <= 108;
					y0 <= 90;
					x1 <= 100;
					y1 <= 94;
				end
				else if (count == 8'd67) begin 
					x0 <= 100;
					y0 <= 94;
					x1 <= 90;
					y1 <= 94;
				end
				else if (count == 8'd68) begin // right cheek
					x0 <= 136;
					y0 <= 85;
					x1 <= 150;
					y1 <= 91;
				end
				else if (count == 8'd69) begin 
					x0 <= 150;
					y0 <= 91;
					x1 <= 160;
					y1 <= 91;
				end
				else if (count == 8'd70) begin 
					x0 <= 160;
					y0 <= 91;
					x1 <= 173;
					y1 <= 82;
				end
				// mouth //////////////
				else if (count == 8'd71) begin 
					x0 <= 97;
					y0 <= 97;
					x1 <= 123;
					y1 <= 100;
				end
				else if (count == 8'd72) begin 
					x0 <= 123;
					y0 <= 100;
					x1 <= 152;
					y1 <= 96;
				end
				else if (count == 8'd73) begin 
					x0 <= 152;
					y0 <= 96;
					x1 <= 132;
					y1 <= 105;
				end
				else if (count == 8'd74) begin 
					x0 <= 132;
					y0 <= 105;
					x1 <= 116;
					y1 <= 105;
				end
				else if (count == 8'd75) begin 
					x0 <= 116;
					y0 <= 105;
					x1 <= 97;
					y1 <= 97;
				end
				else if (count == 8'd76) begin 
					x0 <= 97;
					y0 <= 97;
					x1 <= 116;
					y1 <= 113;
				end
				else if (count == 8'd77) begin 
					x0 <= 116;
					y0 <= 113;
					x1 <= 132;
					y1 <= 113;
				end
				else if (count == 8'd78) begin 
					x0 <= 132;
					y0 <= 113;
					x1 <= 152;
					y1 <= 96;
				end
				// chin ///////////
				else if (count == 8'd79) begin 
					x0 <= 100;
					y0 <= 113;
					x1 <= 114;
					y1 <= 133;
				end
				else if (count == 8'd80) begin 
					x0 <= 114;
					y0 <= 133;
					x1 <= 132;
					y1 <= 133;
				end
				else if (count == 8'd81) begin 
					x0 <= 132;
					y0 <= 133;
					x1 <= 163;
					y1 <= 110;
				end
				// left cheek to hip
				else if (count == 8'd82) begin 
					x0 <= 85;
					y0 <= 70;
					x1 <= 80;
					y1 <= 80;
				end
				else if (count == 8'd83) begin 
					x0 <= 80;
					y0 <= 80;
					x1 <= 80;
					y1 <= 90;
				end
				else if (count == 8'd84) begin 
					x0 <= 80;
					y0 <= 90;
					x1 <= 97;
					y1 <= 105;
				end
				else if (count == 8'd85) begin 
					x0 <= 97;
					y0 <= 105;
					x1 <= 110;
					y1 <= 230;
				end
				else if (count == 8'd86) begin 
					x0 <= 110;
					y0 <= 230;
					x1 <= 160;
					y1 <= 230;
				end
				// right arm /////////////
				else if (count == 8'd87) begin 
					x0 <= 165;
					y0 <= 140;
					x1 <= 175;
					y1 <= 170;
				end
				else if (count == 8'd88) begin 
					x0 <= 175;
					y0 <= 170;
					x1 <= 170;
					y1 <= 202;
				end
				else if (count == 8'd89) begin 
					x0 <= 170;
					y0 <= 202;
					x1 <= 155;
					y1 <= 220;
				end
				else if (count == 8'd90) begin 
					x0 <= 155;
					y0 <= 220;
					x1 <= 160;
					y1 <= 220;
				end
				else if (count == 8'd91) begin 
					x0 <= 160;
					y0 <= 220;
					x1 <= 165;
					y1 <= 213;
				end
				else if (count == 8'd92) begin 
					x0 <= 165;
					y0 <= 213;
					x1 <= 165;
					y1 <= 220;
				end
				else if (count == 8'd93) begin 
					x0 <= 165;
					y0 <= 220;
					x1 <= 157;
					y1 <= 225;
				end
				else if (count == 8'd94) begin 
					x0 <= 157;
					y0 <= 225;
					x1 <= 160;
					y1 <= 230;
				end
				else if (count == 8'd95) begin 
					x0 <= 160;
					y0 <= 230;
					x1 <= 170;
					y1 <= 227;
				end
				else if (count == 8'd96) begin 
					x0 <= 170;
					y0 <= 227;
					x1 <= 176;
					y1 <= 217;
				end
				else if (count == 8'd97) begin 
					x0 <= 176;
					y0 <= 217;
					x1 <= 176;
					y1 <= 204;
				end
				else if (count == 8'd98) begin 
					x0 <= 176;
					y0 <= 204;
					x1 <= 188;
					y1 <= 172;
				end
				else if (count == 8'd99) begin 
					x0 <= 188;
					y0 <= 172;
					x1 <= 180;
					y1 <= 140;
				end
				// head ////////////////
				else if (count == 8'd100) begin 
					x0 <= 180;
					y0 <= 140;
					x1 <= 180;
					y1 <= 20;
				end
				else if (count == 8'd101) begin 
					x0 <= 180;
					y0 <= 20;
					x1 <= 160;
					y1 <= 5;
				end
				else if (count == 8'd102) begin 
					x0 <= 160;
					y0 <= 5;
					x1 <= 120;
					y1 <= 5;
				end
				else if (count == 8'd103) begin 
					x0 <= 120;
					y0 <= 5;
					x1 <= 92;
					y1 <= 15;
				end
				else if (count == 8'd104) begin 
					x0 <= 92;
					y0 <= 15;
					x1 <= 92;
					y1 <= 33;
				end
				// left arm //////////////
				else if (count == 8'd105) begin 
					x0 <= 100;
					y0 <= 140;
					x1 <= 90;
					y1 <= 220;
				end
				else if (count == 8'd106) begin 
					x0 <= 90;
					y0 <= 220;
					x1 <= 95;
					y1 <= 225;
				end
				else if (count == 8'd107) begin 
					x0 <= 95;
					y0 <= 210;
					x1 <= 105;
					y1 <= 222;
				end
				else if (count == 8'd108) begin 
					x0 <= 105;
					y0 <= 222;
					x1 <= 103;
					y1 <= 210;
				end
				else if (count == 8'd109) begin 
					x0 <= 105;
					y0 <= 193;
					x1 <= 100;
					y1 <= 203;
				end
				else if (count == 8'd110) begin 
					x0 <= 100;
					y0 <= 203;
					x1 <= 107;
					y1 <= 207;
				end
				// baseball bat ///////////
				else if (count == 8'd111) begin 
					x0 <= 100;
					y0 <= 220;
					x1 <= 1;
					y1 <= 350;
				end
				else if (count == 8'd112) begin 
					x0 <= 1;
					y0 <= 350;
					x1 <= 5;
					y1 <= 360;
				end
				else if (count == 8'd113) begin 
					x0 <= 5;
					y0 <= 360;
					x1 <= 15;
					y1 <= 365;
				end
				else if (count == 8'd114) begin 
					x0 <= 15;
					y0 <= 365;
					x1 <= 30;
					y1 <= 360;
				end
				else if (count == 8'd115) begin 
					x0 <= 30;
					y0 <= 360;
					x1 <= 108;
					y1 <= 223;
				end
				// left leg //////////////
				else if (count == 8'd116) begin 
					x0 <= 110;
					y0 <= 230;
					x1 <= 115;
					y1 <= 330;
				end
				else if (count == 8'd117) begin 
					x0 <= 115;
					y0 <= 330;
					x1 <= 70;
					y1 <= 350;
				end
				else if (count == 8'd118) begin 
					x0 <= 70;
					y0 <= 350;
					x1 <= 75;
					y1 <= 365;
				end
				else if (count == 8'd119) begin 
					x0 <= 75;
					y0 <= 365;
					x1 <= 110;
					y1 <= 360;
				end
				else if (count == 8'd120) begin 
					x0 <= 110;
					y0 <= 360;
					x1 <= 115;
					y1 <= 354;
				end
				else if (count == 8'd121) begin 
					x0 <= 115;
					y0 <= 354;
					x1 <= 138;
					y1 <= 350;
				end
				else if (count == 8'd122) begin 
					x0 <= 138;
					y0 <= 350;
					x1 <= 132;
					y1 <= 330;
				end
				else if (count == 8'd123) begin 
					x0 <= 132;
					y0 <= 330;
					x1 <= 130;
					y1 <= 275;
				end
				else if (count == 8'd124) begin 
					x0 <= 130;
					y0 <= 275;
					x1 <= 133;
					y1 <= 230;
				end
				// right leg /////////////
				else if (count == 8'd125) begin 
					x0 <= 143;
					y0 <= 230;
					x1 <= 143;
					y1 <= 267;
				end
				else if (count == 8'd126) begin 
					x0 <= 143;
					y0 <= 267;
					x1 <= 150;
					y1 <= 338;
				end
				else if (count == 8'd127) begin 
					x0 <= 150;
					y0 <= 338;
					x1 <= 135;
					y1 <= 363;
				end
				else if (count == 8'd128) begin 
					x0 <= 135;
					y0 <= 363;
					x1 <= 137;
					y1 <= 370;
				end
				else if (count == 8'd129) begin 
					x0 <= 137;
					y0 <= 370;
					x1 <= 167;
					y1 <= 370;
				end
				else if (count == 8'd130) begin 
					x0 <= 167;
					y0 <= 370;
					x1 <= 170;
					y1 <= 363;
				end
				else if (count == 8'd131) begin 
					x0 <= 170;
					y0 <= 363;
					x1 <= 163;
					y1 <= 336;
				end
				else if (count == 8'd132) begin 
					x0 <= 163;
					y0 <= 336;
					x1 <= 170;
					y1 <= 280;
				end
				else if (count == 8'd133) begin 
					x0 <= 170;
					y0 <= 280;
					x1 <= 163;
					y1 <= 267;
				end
				else if (count == 8'd134) begin 
					x0 <= 163;
					y0 <= 267;
					x1 <= 170;
					y1 <= 227;
				end
			end // if (done)
		end
	end // always_ff


endmodule  // task3_tung_tung_tung_sahur