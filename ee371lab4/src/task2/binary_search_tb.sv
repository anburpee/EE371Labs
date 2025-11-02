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

        reset <= 1'b1;                                                 @(posedge clk);
        reset <= 1'b0;   start <= 1'b0;   a <= 8'b10101010;     repeat(3) @(posedge clk);

        start <= 1'b1;
        //@(posedge done);

        repeat(35) @(posedge clk);

        $stop; // stop simulation
    end // initial

endmodule // binary_search_tb