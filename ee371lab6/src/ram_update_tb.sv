`timescale 1 ps / 1 ps
module ram_update_tb ();

    logic clk;
	logic reset;
	logic [3:0] key;
	logic [5:0] sw;
	logic iter_done;
    logic invalid_move;

    ram_update dut (.*);

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
        repeat(55) @(posedge clk);

        // could test left down for blocked

        sw[5:3] <= 3'b111;
        sw[2:0] <= 3'b010;
        key[1] <= 1'b1; // down left (should move)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(55) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b100;
        sw[2:0] <= 3'b101;
        key[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(55) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b111;
        sw[2:0] <= 3'b010;
        key[1] <= 1'b1; // down left (should NOT move -- NO TOKEN HERE ANYMORE)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(55) @(posedge clk);

        sw[5:3] <= 3'b110;
        sw[2:0] <= 3'b011;
        key[2] <= 1'b1; // up right (should NOT move -- invalid direction)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(55) @(posedge clk);

        sw[5:3] <= 3'b110;
        sw[2:0] <= 3'b011;
        key[0] <= 1'b1; // down right (should move)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(55) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b110;
        sw[2:0] <= 3'b101;
        key[2] <= 1'b1; // up right (should NOT move -- blocked by blk)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(55) @(posedge clk);

        sw[5:3] <= 3'b011;
        sw[2:0] <= 3'b100;
        key[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(55) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b111;
        sw[2:0] <= 3'b100;
        key[3] <= 1'b1; // up left (should NOT move -- not KING token)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(55) @(posedge clk);

        sw[5:3] <= 3'b111;
        sw[2:0] <= 3'b100;
        key[0] <= 1'b1; // down right (should NOT move -- edge of board)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(55) @(posedge clk);

        sw[5:3] <= 3'b111;
        sw[2:0] <= 3'b100;
        key[1] <= 1'b1; // down left (should NOT move -- blocked by red)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(55) @(posedge clk);

        sw[5:3] <= 3'b001;
        sw[2:0] <= 3'b010;
        key[1] <= 1'b1; // down left (should move)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(55) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b000;
        sw[2:0] <= 3'b011;
        key[0] <= 1'b1; // down right (should NOT move -- wrong color token)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(55) @(posedge clk);

        sw[5:3] <= 3'b000;
        sw[2:0] <= 3'b101;
        key[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(55) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b011;
        sw[2:0] <= 3'b010;
        key[1] <= 1'b1; // down left (should move)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(55) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b001;
        sw[2:0] <= 3'b110;
        key[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(55) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b101;
        sw[2:0] <= 3'b010;
        key[1] <= 1'b1; // down left (should move -- MULT_ITER IS HIGH so capture logic)
        // also red token at (4,3) should be deleted now bc captured
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(55) @(posedge clk);

        // can make another move

        sw[5:3] <= 3'b011;
        sw[2:0] <= 3'b100;
        key[1] <= 1'b1; // down left (should move -- MULT_ITER IS HIGH so capture logic)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(55) @(posedge clk);

        // can't make another move

        // ----- red's turn -----

        sw[5:3] <= 3'b011;
        sw[2:0] <= 3'b110;
        key[3] <= 1'b1; // up left (should move)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(55) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b010;
        sw[2:0] <= 3'b011;
        key[0] <= 1'b1; // down right (should move)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(55) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b010;
        sw[2:0] <= 3'b111;
        key[2] <= 1'b1; // up right (should move)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(55) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b001;
        sw[2:0] <= 3'b110;
        key[0] <= 1'b1; // down right (should move -- BECOMES KING)
        repeat(3) @(posedge clk);
        key[0] <= 1'b0;
        repeat(55) @(posedge clk);

        // ----- red's turn -----

        sw[5:3] <= 3'b101;
        sw[2:0] <= 3'b101;
        key[3] <= 1'b1; // up left (should NOT move -- blocked by red)
        repeat(3) @(posedge clk);
        key[3] <= 1'b0;
        repeat(55) @(posedge clk);

        // ----- blk's turn -----

        sw[5:3] <= 3'b010;
        sw[2:0] <= 3'b111;
        key[2] <= 1'b1; // up right (should move -- CAPTURE)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(55) @(posedge clk);

        // can go again

        sw[5:3] <= 3'b100;
        sw[2:0] <= 3'b101;
        key[2] <= 1'b1; // up right (should move -- CAPTURE)
        repeat(3) @(posedge clk);
        key[2] <= 1'b0;
        repeat(55) @(posedge clk);

        // can go again

        sw[5:3] <= 3'b110;
        sw[2:0] <= 3'b011;
        key[1] <= 1'b1; // down left (should move)
        repeat(3) @(posedge clk);
        key[1] <= 1'b0;
        repeat(55) @(posedge clk);

        $stop;
    end // initial

endmodule