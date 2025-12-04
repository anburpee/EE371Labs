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
        sw[2:0] <= 3'b111;
        sw[5:3] <= 3'b010;
        repeat(15) @(posedge clk);
        key[1] <= 1'b1;

        // ----- red's turn -----

        // check invalid spot (where token is not present) -- check that NOT valid_xy
        sw[2:0] <= 3'b111;
        sw[5:3] <= 3'b100;
        repeat(15) @(posedge clk);
        // $display("red's turn should be HIGH: %d\n", ram_update_datapath.reds_turn);
        // $display("valid_xy should be LOW: %d\n", ram_update_ctrl.valid_xy);

        // check all four diagonals if empty all around
        sw[2:0] <= 3'b111;
        sw[5:3] <= 3'b101;
        repeat(3) @(posedge clk);
        key[3] <= 1'b1; // up left (should move)
        repeat(15) @(posedge clk);
        key[3] <= 1'b0;
        // $display("red's turn should be HIGH: %d\n", ram_update_datapath.reds_turn);
        // $display("valid_xy should be HIGH: %d\n", ram_update_ctrl.valid_xy);

        // ----- blk's turn -----
        sw[2:0] <= 3'b110;
        sw[5:3] <= 3'b100;
        repeat(3) @(posedge clk);
        key[1] <= 1'b1; // down left (should NOT move because there's a red token here)
        repeat(15) @(posedge clk);
        key[1] <= 1'b0;
        // $display("red's turn should be LOW: %d\n", ram_update_datapath.reds_turn);
        // $display("valid_xy should be LOW: %d\n", ram_update_ctrl.valid_xy);

        sw[2:0] <= 3'b110;
        sw[5:3] <= 3'b010;
        repeat(3) @(posedge clk);
        key[0] <= 1'b1; // down right (should move)
        repeat(15) @(posedge clk);
        key[0] <= 1'b0;
        // $display("red's turn should be LOW: %d\n", ram_update_datapath.reds_turn);
        // $display("valid_xy should be HIGH: %d\n", ram_update_ctrl.valid_xy);

        // ----- red's turn -----
        sw[2:0] <= 3'b110;
        sw[5:3] <= 3'b100;
        repeat(3) @(posedge clk);
        key[2] <= 1'b1; // up right (should NOT move bc prev. blk move blocks this)
        repeat(15) @(posedge clk);
        key[2] <= 1'b0;
        // $display("red's turn should be HIGH: %d\n", ram_update_datapath.reds_turn);
        // $display("valid_xy should be LOW: %d\n", ram_update_ctrl.valid_xy);

        sw[2:0] <= 3'b110;
        sw[5:3] <= 3'b100;
        repeat(3) @(posedge clk);
        key[0] <= 1'b1; // down right (should NOT move bc not a KING token)
        repeat(15) @(posedge clk);
        key[0] <= 1'b0;
        // $display("red's turn should be HIGH: %d\n", ram_update_datapath.reds_turn);
        // $display("valid_xy should be LOW: %d\n", ram_update_ctrl.valid_xy);

        sw[2:0] <= 3'b110;
        sw[5:3] <= 3'b100;
        repeat(3) @(posedge clk);
        key[3] <= 1'b1; // up left (should move)
        repeat(15) @(posedge clk);
        key[3] <= 1'b0;
        // $display("red's turn should be HIGH: %d\n", ram_update_datapath.reds_turn);
        // $display("valid_xy should be HIGH: %d\n", ram_update_ctrl.valid_xy);

        // ----- blk's turn -----
        sw[2:0] <= 3'b111;
        sw[5:3] <= 3'b011;
        repeat(3) @(posedge clk);
        key[0] <= 1'b1; // down right (should NOT move bc edge piece)
        repeat(15) @(posedge clk);
        key[0] <= 1'b0;
        // $display("red's turn should be LOW: %d\n", ram_update_datapath.reds_turn);
        // $display("valid_xy should be LOW: %d\n", ram_update_ctrl.valid_xy);

        sw[2:0] <= 3'b100;
        sw[5:3] <= 3'b010;
        repeat(3) @(posedge clk);
        key[0] <= 1'b1; // down right (should move by TWO -- capture logic)
        // also red token at (5,3) should be deleted now (red_count = 11)
        repeat(15) @(posedge clk);
        key[0] <= 1'b0;
        // $display("red's turn should be LOW: %d\n", ram_update_datapath.reds_turn);
        // // $display("mult_iter should be LOW: %d\n", mult_iter);
        // $display("valid_xy should be HIGH: %d\n", ram_update_ctrl.valid_xy);

        // can make another move

        sw[2:0] <= 3'b110;
        sw[5:3] <= 3'b100;
        repeat(3) @(posedge clk);
        key[1] <= 1'b1; // down left (should NOT move bc blocked by red)
        repeat(15) @(posedge clk);
        key[1] <= 1'b0;
        // $display("red's turn should be LOW: %d\n", ram_update_datapath.reds_turn);
        // // $display("mult_iter should be HIGH: %d\n", mult_iter);
        // $display("valid_xy should be LOW: %d\n", ram_update_ctrl.valid_xy);

        sw[2:0] <= 3'b110;
        sw[5:3] <= 3'b100;
        repeat(3) @(posedge clk);
        key[0] <= 1'b1; // down right (should move)
        repeat(15) @(posedge clk);
        key[0] <= 1'b0;
        // $display("red's turn should be LOW: %d\n", ram_update_datapath.reds_turn);
        // $display("mult_iter should be LOW: %d\n", mult_iter);
        // $display("valid_xy should be HIGH: %d\n", ram_update_ctrl.valid_xy);

        $stop;
    end // initial

endmodule