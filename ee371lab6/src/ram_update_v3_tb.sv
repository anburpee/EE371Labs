`timescale 1 ps / 1 ps
module ram_update_tb ();

    logic clk;
	logic reset;
	logic [3:0] key;
	logic [5:0] sw;
    logic invalid_move;
    logic reds_turn;
    logic game_over;
    ////////////////v3//////////////////
    logic even_iter, // toggles every iteration
    logic [5:0] encodings_addr1_even;
    logic [5:0] encodings_addr2_even;
    logic [2:0] encodings_data1_even;
    logic [2:0] encodings_data2_even;
    logic [5:0] encodings_addr1_odd;
    logic [5:0] encodings_addr2_odd;
    logic [2:0] encodings_data1_odd;
    logic [2:0] encodings_data2_odd;

    ram_update_v3 dut (.*);

    // simulation clock
    parameter period = 100;
    initial begin
        clk <= 0;
        forever #(period/2) clk <= ~clk;
    end

    // test the design
    initial begin
        reset <= 1'b1;
        key[0] <= 1'b0;
        key[1] <= 1'b0;
        key[2] <= 1'b0;
        key[3] <= 1'b0;
        @(posedge clk);
        reset <= 1'b0;

        // ----- blk's turn -----

        // check invalid spot (where token is not present) -- check that NOT valid_xy
        sw[5:3] <= 3'b110;
        sw[2:0] <= 3'b010;
        key[1] <= 1'b1; // no token exists here -- NOT valid
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(100) @(posedge clk);

        // could test left down for blocked

        sw[5:3] <= 3'b111;
        sw[2:0] <= 3'b010;
        key[1] <= 1'b1; // down left (should move)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b100;
        sw[2:0] <= 3'b101;
        key[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b111; // invalid_xy
        sw[2:0] <= 3'b010;
        key[1] <= 1'b1; // down left (should NOT move -- NO TOKEN HERE ANYMORE)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(100) @(posedge clk);

        sw[5:3] <= 3'b110; // illegal_dir
        sw[2:0] <= 3'b011;
        key[2] <= 1'b1; // up right (should NOT move -- invalid direction)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(100) @(posedge clk);

        sw[5:3] <= 3'b110;
        sw[2:0] <= 3'b011;
        key[0] <= 1'b1; // down right (should move)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b110; // opp_adj
        sw[2:0] <= 3'b101;
        key[2] <= 1'b1; // up right (should NOT move -- blocked by blk)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(100) @(posedge clk);

        sw[5:3] <= 3'b011; // 
        sw[2:0] <= 3'b100;
        key[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(100) @(posedge clk); 

        // timestamp 82450 ps
        // ----- blk's turn -----

        sw[5:3] <= 3'b111; // illegal_dir
        sw[2:0] <= 3'b100;
        key[3] <= 1'b1; // up left (should NOT move -- not KING token)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(100) @(posedge clk);

        sw[5:3] <= 3'b111; // edge_blocked0
        sw[2:0] <= 3'b100;
        key[0] <= 1'b1; // down right (should NOT move -- edge of board)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(100) @(posedge clk);

        sw[5:3] <= 3'b111; // opp_adj
        sw[2:0] <= 3'b100;
        key[1] <= 1'b1; // down left (should NOT move -- blocked by red) 
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(100) @(posedge clk);

        sw[5:3] <= 3'b001;
        sw[2:0] <= 3'b010;
        key[1] <= 1'b1; // down left (should move)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(100) @(posedge clk);

        // timestamp 123650 ps
        // ----- red's turn -----

        sw[5:3] <= 3'b000; // invalid_xy
        sw[2:0] <= 3'b011;
        key[0] <= 1'b1; // down right (should NOT move -- wrong color token)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(100) @(posedge clk);

        sw[5:3] <= 3'b000; 
        sw[2:0] <= 3'b101;
        key[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(100) @(posedge clk);

        // timestamp 144250 ps
        // ----- blk's turn -----

        sw[5:3] <= 3'b011;
        sw[2:0] <= 3'b010;
        key[1] <= 1'b1; // down left (should move)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b001;
        sw[2:0] <= 3'b110;
        key[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(100) @(posedge clk);

        // timestamp 164850 ps
        // ----- blk's turn -----

        sw[5:3] <= 3'b101;
        sw[2:0] <= 3'b010;
        key[1] <= 1'b1; // down left (should move -- MULT_ITER IS HIGH so capture logic)
        // also red token at (4,3) should be deleted now bc captured
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(100) @(posedge clk); 

        // can make another move
        // timestamp 175150 ps

        sw[5:3] <= 3'b011;
        sw[2:0] <= 3'b100;
        key[1] <= 1'b1; // down left (should move -- MULT_ITER IS HIGH so capture logic)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(100) @(posedge clk);

        // can't make another move  

        // timestamp 185450 ps
        // ----- red's turn -----

        sw[5:3] <= 3'b011;
        sw[2:0] <= 3'b110;
        key[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b010;
        sw[2:0] <= 3'b011;
        key[0] <= 1'b1; // down right (should move)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(100) @(posedge clk);

        // timestamp 206050 ps
        // ----- red's turn -----

        sw[5:3] <= 3'b010;
        sw[2:0] <= 3'b111;
        key[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b001;
        sw[2:0] <= 3'b110;
        key[0] <= 1'b1; // down right (should move -- BECOMES KING)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(100) @(posedge clk);

        // timestamp 226650 ps
        // ----- red's turn -----

        sw[5:3] <= 3'b101;
        sw[2:0] <= 3'b110;
        key[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(100) @(posedge clk);

        // timestamp: 236950 ps
        // ----- blk's turn -----

        sw[5:3] <= 3'b010; // edge blocked
        sw[2:0] <= 3'b111;
        key[1] <= 1'b1; // down left (should NOT move -- bottom wall)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(100) @(posedge clk);

        sw[5:3] <= 3'b010; // two_over
        sw[2:0] <= 3'b111;
        key[2] <= 1'b1; // up right (should NOT move -- token in landing spot)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(100) @(posedge clk);

        sw[5:3] <= 3'b010;
        sw[2:0] <= 3'b111;
        key[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(100) @(posedge clk);

        // timestamp 267850 ps
        // ----- red's turn -----

        sw[5:3] <= 3'b100; 
        sw[2:0] <= 3'b101;
        key[3] <= 1'b1; // up left (should move --  capture)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b001;
        sw[2:0] <= 3'b110;
        key[0] <= 1'b1; // down right (should move)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(100) @(posedge clk);

        // timestamp 288450 ps
        // ----- red's turn -----

        sw[5:3] <= 3'b110;
        sw[2:0] <= 3'b111;
        key[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b010;
        sw[2:0] <= 3'b111;
        key[2] <= 1'b1; // up right (should move -- CAPTURE)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(100) @(posedge clk);

        // another turn

        sw[5:3] <= 3'b111; // x_curr and y_curr already stored so key inputs shouldn't matter here
        sw[2:0] <= 3'b111;
        key[0] <= 1'b1; // down right (should move -- CAPTURE)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b010;
        sw[2:0] <= 3'b011;
        key[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b100;
        sw[2:0] <= 3'b001;
        key[1] <= 1'b1; // down right (should move -- CAPTURE)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b001;
        sw[2:0] <= 3'b100;
        key[2] <= 1'b1; // up right (should move -- CAPTURE)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b111;
        sw[2:0] <= 3'b100;
        key[1] <= 1'b1; // down left (should move -- CAPTURE)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b010;
        sw[2:0] <= 3'b101;
        key[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(100) @(posedge clk);

         // ----- blk's turn -----

        sw[5:3] <= 3'b010;
        sw[2:0] <= 3'b001;
        key[0] <= 1'b1; // down right (should move -- CAPTURE)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b000;
        sw[2:0] <= 3'b111;
        key[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b000;
        sw[2:0] <= 3'b011;
        key[0] <= 1'b1; // down right (should move -- CAPTURE)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(100) @(posedge clk);

        // can move again

        sw[5:3] <= 3'b010;
        sw[2:0] <= 3'b101;
        key[1] <= 1'b1; // down left (should move -- CAPTURE). ALSO BECOMES KING
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b100;
        sw[2:0] <= 3'b111;
        key[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b101;
        sw[2:0] <= 3'b110;
        key[1] <= 1'b1; // down left (should move -- BECOMES KING)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b000;
        sw[2:0] <= 3'b101;
        key[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b100;
        sw[2:0] <= 3'b111;
        key[3] <= 1'b1; // up left (should move -- CAPTURE)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(100) @(posedge clk);

        // can go again

        sw[5:3] <= 3'b010;
        sw[2:0] <= 3'b101;
        key[3] <= 1'b1; // up right (should move -- CAPTURE)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b111;
        sw[2:0] <= 3'b110;
        key[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b110;
        sw[2:0] <= 3'b001;
        key[1] <= 1'b1; // down left (should move)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b110;
        sw[2:0] <= 3'b101;
        key[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(100) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b100;
        sw[2:0] <= 3'b011;
        key[0] <= 1'b1; // down right (should move -- CAPTURE)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(100) @(posedge clk);

        // WIN LOGIC SHOULD NOW BE HAPPENING

        $stop;
    end // initial

endmodule