module ram_update_tb ();

    logic clk;
	logic reset;
	logic [3:0] keys;
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
        keys[0] <= 1'b0;
        keys[1] <= 1'b0;
        keys[2] <= 1'b0;
        keys[3] <= 1'b0;
        @(posedge clk);
        reset <= 1'b0;
        
        // ----- red's turn -----

        // check invalid spot (where token is not present) -- check that NOT valid_xy
        sw[2:0] <= 3'b111;
        sw[5:3] <= 3'b100;
        repeat(5) @(posedge clk);

        // check all four diagonals if empty all around
        sw[2:0] <= 3'b111;
        sw[5:3] <= 3'b101;
        repeat(2) @(posedge clk);
        keys[3] <= 1'b1; // up left (should move)
        repeat(2) @(posedge clk);
        keys[3] <= 1'b0;

        // ----- blk's turn -----
        sw[2:0] <= 3'b110;
        sw[5:3] <= 3'b100;
        repeat(2) @(posedge clk);
        keys[1] <= 1'b1; // down left (should NOT move because there's a red token here)
        repeat(2) @(posedge clk);
        keys[1] <= 1'b0;

        sw[2:0] <= 3'b110;
        sw[5:3] <= 3'b010;
        repeat(2) @(posedge clk);
        keys[0] <= 1'b1; // down right (should move)
        repeat(2) @(posedge clk);
        keys[0] <= 1'b0;

        // ----- red's turn -----
        sw[2:0] <= 3'b110;
        sw[5:3] <= 3'b100;
        repeat(2) @(posedge clk);
        keys[2] <= 1'b1; // up right (should NOT move bc prev. blk move blocks this)
        repeat(2) @(posedge clk);
        keys[2] <= 1'b0;

        sw[2:0] <= 3'b110;
        sw[5:3] <= 3'b100;
        repeat(2) @(posedge clk);
        keys[0] <= 1'b1; // down right (should NOT move bc not a KING token)
        repeat(2) @(posedge clk);
        keys[0] <= 1'b0;

        sw[2:0] <= 3'b110;
        sw[5:3] <= 3'b100;
        repeat(2) @(posedge clk);
        keys[3] <= 1'b1; // up left (should move)
        repeat(2) @(posedge clk);
        keys[3] <= 1'b0;

        // ----- blk's turn -----
        sw[2:0] <= 3'b111;
        sw[5:3] <= 3'b011;
        repeat(2) @(posedge clk);
        keys[0] <= 1'b1; // down right (should NOT move bc edge piece)
        repeat(2) @(posedge clk);
        keys[0] <= 1'b0;

        sw[2:0] <= 3'b100;
        sw[5:3] <= 3'b010;
        repeat(2) @(posedge clk);
        keys[0] <= 1'b1; // down right (should move by TWO -- capture logic)
        // also red token at (5,3) should be deleted now (red_count = 11)
        repeat(2) @(posedge clk);
        keys[0] <= 1'b0;

        // can make another move

        sw[2:0] <= 3'b110;
        sw[5:3] <= 3'b100;
        repeat(2) @(posedge clk);
        keys[1] <= 1'b1; // down left (should NOT move bc blocked by red)
        repeat(2) @(posedge clk);
        keys[1] <= 1'b0;

        sw[2:0] <= 3'b110;
        sw[5:3] <= 3'b100;
        repeat(2) @(posedge clk);
        keys[0] <= 1'b1; // down right (should move)
        repeat(2) @(posedge clk);
        keys[0] <= 1'b0;

        $stop;
    end // initial

endmodule