`timescale 1 ps / 1 ps
module DE1_SoC_tb ();
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
		SW[9] <= 1'b1;
        KEY[0] <= 1'b0;
        KEY[1] <= 1'b0;
        KEY[2] <= 1'b0;
        KEY[3] <= 1'b0;
        @(posedge CLOCK_50);
        SW[9] <= 1'b0;

        // ----- blk's turn -----

        // check invalid spot (where token is not present) -- check that NOT valid_xy
        SW[5:3] <= 3'b110;
        SW[2:0] <= 3'b010;
        KEY[1] <= 1'b1; // no token exists here -- NOT valid
        repeat(3) @(posedge CLOCK_50);
        KEY[1] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // could test left down for blocked

        SW[5:3] <= 3'b111;
        SW[2:0] <= 3'b010;
        KEY[1] <= 1'b1; // down left (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[1] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- red's turn -----

        SW[5:3] <= 3'b100;
        SW[2:0] <= 3'b101;
        KEY[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[3] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- blk's turn -----

        SW[5:3] <= 3'b111; // invalid_xy
        SW[2:0] <= 3'b010;
        KEY[1] <= 1'b1; // down left (should NOT move -- NO TOKEN HERE ANYMORE)
        repeat(3) @(posedge CLOCK_50);
        KEY[1] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        SW[5:3] <= 3'b110; // illegal_dir
        SW[2:0] <= 3'b011;
        KEY[2] <= 1'b1; // up right (should NOT move -- invalid direction)
        repeat(3) @(posedge CLOCK_50);
        KEY[2] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        SW[5:3] <= 3'b110;
        SW[2:0] <= 3'b011;
        KEY[0] <= 1'b1; // down right (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[0] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- red's turn -----

        SW[5:3] <= 3'b110; // opp_adj
        SW[2:0] <= 3'b101;
        KEY[2] <= 1'b1; // up right (should NOT move -- blocked by blk)
        repeat(3) @(posedge CLOCK_50);
        KEY[2] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        SW[5:3] <= 3'b011; // 
        SW[2:0] <= 3'b100;
        KEY[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[2] <= 1'b0;
        repeat(100) @(posedge CLOCK_50); 

        // timestamp 82450 ps
        // ----- blk's turn -----

        SW[5:3] <= 3'b111; // illegal_dir
        SW[2:0] <= 3'b100;
        KEY[3] <= 1'b1; // up left (should NOT move -- not KING token)
        repeat(3) @(posedge CLOCK_50);
        KEY[3] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        SW[5:3] <= 3'b111; // edge_blocked0
        SW[2:0] <= 3'b100;
        KEY[0] <= 1'b1; // down right (should NOT move -- edge of board)
        repeat(3) @(posedge CLOCK_50);
        KEY[0] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        SW[5:3] <= 3'b111; // opp_adj
        SW[2:0] <= 3'b100;
        KEY[1] <= 1'b1; // down left (should NOT move -- blocked by red) 
        repeat(3) @(posedge CLOCK_50);
        KEY[1] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        SW[5:3] <= 3'b001;
        SW[2:0] <= 3'b010;
        KEY[1] <= 1'b1; // down left (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[1] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // timestamp 123650 ps
        // ----- red's turn -----

        SW[5:3] <= 3'b000; // invalid_xy
        SW[2:0] <= 3'b011;
        KEY[0] <= 1'b1; // down right (should NOT move -- wrong color token)
        repeat(3) @(posedge CLOCK_50);
        KEY[0] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        SW[5:3] <= 3'b000; 
        SW[2:0] <= 3'b101;
        KEY[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[2] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // timestamp 144250 ps
        // ----- blk's turn -----

        SW[5:3] <= 3'b011;
        SW[2:0] <= 3'b010;
        KEY[1] <= 1'b1; // down left (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[1] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- red's turn -----

        SW[5:3] <= 3'b001;
        SW[2:0] <= 3'b110;
        KEY[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[3] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // timestamp 164850 ps
        // ----- blk's turn -----

        SW[5:3] <= 3'b101;
        SW[2:0] <= 3'b010;
        KEY[1] <= 1'b1; // down left (should move -- MULT_ITER IS HIGH so capture logic)
        // also red token at (4,3) should be deleted now bc captured
        repeat(3) @(posedge CLOCK_50);
        KEY[1] <= 1'b0;
        repeat(100) @(posedge CLOCK_50); 

        // can make another move
        // timestamp 175150 ps

        SW[5:3] <= 3'b011;
        SW[2:0] <= 3'b100;
        KEY[1] <= 1'b1; // down left (should move -- MULT_ITER IS HIGH so capture logic)
        repeat(3) @(posedge CLOCK_50);
        KEY[1] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // can't make another move  

        // timestamp 185450 ps
        // ----- red's turn -----

        SW[5:3] <= 3'b011;
        SW[2:0] <= 3'b110;
        KEY[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[3] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- blk's turn -----

        SW[5:3] <= 3'b010;
        SW[2:0] <= 3'b011;
        KEY[0] <= 1'b1; // down right (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[0] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // timestamp 206050 ps
        // ----- red's turn -----

        SW[5:3] <= 3'b010;
        SW[2:0] <= 3'b111;
        KEY[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[2] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- blk's turn -----

        SW[5:3] <= 3'b001;
        SW[2:0] <= 3'b110;
        KEY[0] <= 1'b1; // down right (should move -- BECOMES KING)
        repeat(3) @(posedge CLOCK_50);
        KEY[0] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // timestamp 226650 ps
        // ----- red's turn -----

        SW[5:3] <= 3'b101;
        SW[2:0] <= 3'b110;
        KEY[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[3] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // timestamp: 236950 ps
        // ----- blk's turn -----

        SW[5:3] <= 3'b010; // edge blocked
        SW[2:0] <= 3'b111;
        KEY[1] <= 1'b1; // down left (should NOT move -- bottom wall)
        repeat(3) @(posedge CLOCK_50);
        KEY[1] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        SW[5:3] <= 3'b010; // two_over
        SW[2:0] <= 3'b111;
        KEY[2] <= 1'b1; // up right (should NOT move -- token in landing spot)
        repeat(3) @(posedge CLOCK_50);
        KEY[2] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        SW[5:3] <= 3'b010;
        SW[2:0] <= 3'b111;
        KEY[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[3] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // timestamp 267850 ps
        // ----- red's turn -----

        SW[5:3] <= 3'b100; 
        SW[2:0] <= 3'b101;
        KEY[3] <= 1'b1; // up left (should move --  capture)
        repeat(3) @(posedge CLOCK_50);
        KEY[3] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- blk's turn -----

        SW[5:3] <= 3'b001;
        SW[2:0] <= 3'b110;
        KEY[0] <= 1'b1; // down right (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[0] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // timestamp 288450 ps
        // ----- red's turn -----

        SW[5:3] <= 3'b110;
        SW[2:0] <= 3'b111;
        KEY[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[3] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- blk's turn -----

        SW[5:3] <= 3'b010;
        SW[2:0] <= 3'b111;
        KEY[2] <= 1'b1; // up right (should move -- CAPTURE)
        repeat(3) @(posedge CLOCK_50);
        KEY[2] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // another turn

        SW[5:3] <= 3'b111; // x_curr and y_curr already stored so KEY inputs shouldn't matter here
        SW[2:0] <= 3'b111;
        KEY[0] <= 1'b1; // down right (should move -- CAPTURE)
        repeat(3) @(posedge CLOCK_50);
        KEY[0] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- red's turn -----

        SW[5:3] <= 3'b010;
        SW[2:0] <= 3'b011;
        KEY[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[2] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- blk's turn -----

        SW[5:3] <= 3'b100;
        SW[2:0] <= 3'b001;
        KEY[1] <= 1'b1; // down right (should move -- CAPTURE)
        repeat(3) @(posedge CLOCK_50);
        KEY[1] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- red's turn -----

        SW[5:3] <= 3'b001;
        SW[2:0] <= 3'b100;
        KEY[2] <= 1'b1; // up right (should move -- CAPTURE)
        repeat(3) @(posedge CLOCK_50);
        KEY[2] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- blk's turn -----

        SW[5:3] <= 3'b111;
        SW[2:0] <= 3'b100;
        KEY[1] <= 1'b1; // down left (should move -- CAPTURE)
        repeat(3) @(posedge CLOCK_50);
        KEY[1] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- red's turn -----

        SW[5:3] <= 3'b010;
        SW[2:0] <= 3'b101;
        KEY[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[3] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

         // ----- blk's turn -----

        SW[5:3] <= 3'b010;
        SW[2:0] <= 3'b001;
        KEY[0] <= 1'b1; // down right (should move -- CAPTURE)
        repeat(3) @(posedge CLOCK_50);
        KEY[0] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- red's turn -----

        SW[5:3] <= 3'b000;
        SW[2:0] <= 3'b111;
        KEY[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[2] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- blk's turn -----

        SW[5:3] <= 3'b000;
        SW[2:0] <= 3'b011;
        KEY[0] <= 1'b1; // down right (should move -- CAPTURE)
        repeat(3) @(posedge CLOCK_50);
        KEY[0] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // can move again

        SW[5:3] <= 3'b010;
        SW[2:0] <= 3'b101;
        KEY[1] <= 1'b1; // down left (should move -- CAPTURE). ALSO BECOMES KING
        repeat(3) @(posedge CLOCK_50);
        KEY[1] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- red's turn -----

        SW[5:3] <= 3'b100;
        SW[2:0] <= 3'b111;
        KEY[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[3] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- blk's turn -----

        SW[5:3] <= 3'b101;
        SW[2:0] <= 3'b110;
        KEY[1] <= 1'b1; // down left (should move -- BECOMES KING)
        repeat(3) @(posedge CLOCK_50);
        KEY[1] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- red's turn -----

        SW[5:3] <= 3'b000;
        SW[2:0] <= 3'b101;
        KEY[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[2] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- blk's turn -----

        SW[5:3] <= 3'b100;
        SW[2:0] <= 3'b111;
        KEY[3] <= 1'b1; // up left (should move -- CAPTURE)
        repeat(3) @(posedge CLOCK_50);
        KEY[3] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // can go again

        SW[5:3] <= 3'b010;
        SW[2:0] <= 3'b101;
        KEY[3] <= 1'b1; // up right (should move -- CAPTURE)
        repeat(3) @(posedge CLOCK_50);
        KEY[3] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- red's turn -----

        SW[5:3] <= 3'b111;
        SW[2:0] <= 3'b110;
        KEY[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[3] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- blk's turn -----

        SW[5:3] <= 3'b110;
        SW[2:0] <= 3'b001;
        KEY[1] <= 1'b1; // down left (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[1] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- red's turn -----

        SW[5:3] <= 3'b110;
        SW[2:0] <= 3'b101;
        KEY[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge CLOCK_50);
        KEY[3] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // ----- blk's turn -----

        SW[5:3] <= 3'b100;
        SW[2:0] <= 3'b011;
        KEY[0] <= 1'b1; // down right (should move -- CAPTURE)
        repeat(3) @(posedge CLOCK_50);
        KEY[0] <= 1'b0;
        repeat(100) @(posedge CLOCK_50);

        // WIN LOGIC SHOULD NOW BE HAPPENING
		$stop;
	end  // inputs initial
	
endmodule  // DE1_SoC_testbench