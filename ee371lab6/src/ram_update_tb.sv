module ram_update_tb ();

    logic clk;
	logic reset;
	logic [3:0] keys;
	logic [5:0] sw;
	logic iter_done;

    task3_basic dut (.*);

    // simulation clock
    parameter period = 100;
    initial begin
        CLOCK_50 <= 0;
        forever #(period/2) CLOCK_50 <= ~CLOCK_50;
    end

    // test the design
    initial begin
        reset <= 1'b0;
        keys[0] <= 1'b0;
        keys[1] <= 1'b0;
        keys[2] <= 1'b0;
        keys[3] <= 1'b0;
        @(posedge CLOCK_50);

        // check invalid spot (where token is not present) -- check that NOT valid_xy
        sw[2:0] <= 3'b111;
        sw[5:3] <= 3'b100;
        repeat(5) @(posedge CLOCK_50);

        // check all four diagonals if empty all around
        sw[2:0] <= 3'b111;
        sw[5:3] <= 3'b101;

        // check one diagonal if opposite token (jump & capture)

        // check one diagonal if at edge

        $stop;
    end // initial

endmodule