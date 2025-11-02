`timescale 1 ps / 1 ps
module binary_search_tb ();
    logic clk, reset, start;
    logic [7:0] a;
    logic [4:0] loc;
    logic done, found;

    binary_search dut (.*);

    // set up clock
    parameter period = 100;
    initial begin
        clk <= 0;
        forever #(period/2) clk <= ~clk;
    end // initial clock

    // test the design
    initial begin
        // reset
        reset <= 1'b1;                                               @(posedge clk);
        // A value stored at a lower index than the middle
        reset <= 1'b0;   start <= 1'b0;   a <= 8'd170;     repeat(3) @(posedge clk);

        start <= 1'b1;                                @(posedge done);
                                            repeat(2) @(posedge clk);

        // reset
        reset <= 1'b1;                      repeat(4) @(posedge clk);

        // value of A stored at middle index
        reset <= 1'b0;  a <= 8'd173;                  @(posedge done);
                                            repeat(2) @(posedge clk);

        // reset
        reset <= 1'b1;                      repeat(4) @(posedge clk);

        // try a value of A that doesn't exist
        reset <= 1'b0;  a <= 8'd10;       repeat (30) @(posedge clk);

        // reset
        reset <= 1'b1;                      repeat(4) @(posedge clk);

        // try another value of A
        reset <= 1'b0;  a <= 8'd228;                  @(posedge done);
                                            repeat(2) @(posedge clk);

        $stop; // stop simulation
    end // initial

endmodule // binary_search_tb
