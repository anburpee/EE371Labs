module line_drawer_tb ();
    logic clk, reset;
	logic [10:0]	x0, y0, x1, y1;
	logic write, done; // added write
	logic [10:0]	x, y;

    line_drawer dut (.*);

    // simulation clock
    parameter period = 100;
    initial begin
        clk <= 0;
        forever #(period/2) clk <= ~clk;
    end

    // test the design
    initial begin
        reset <= 1'b1;          @(posedge clk);
        reset <= 1'b0;         

        // not steep, left down
        x0 <= 10'd0;    y0 <=  10'd0;   x1 <= 10'd4;    y1 <= 10'd3;    @(posedge done);

        // not steep, left up
        x0 <= 10'd0;    y0 <=  10'd3;   x1 <= 10'd4;    y1 <= 10'd0;    @(posedge done);

        // not steep, right down
        x0 <= 10'd4;    y0 <=  10'd0;   x1 <= 10'd0;    y1 <= 10'd3;    @(posedge done);

        // not steep, right up
        x0 <= 10'd4;    y0 <=  10'd3;   x1 <= 10'd0;    y1 <= 10'd0;    @(posedge done);


        // steep, left down
        x0 <= 10'd0;    y0 <=  10'd0;   x1 <= 10'd2;    y1 <= 10'd4;    @(posedge done);

        // steep, left up
        x0 <= 10'd0;    y0 <=  10'd4;   x1 <= 10'd2;    y1 <= 10'd0;    @(posedge done);

        // steep, right down
        x0 <= 10'd2;    y0 <=  10'd0;   x1 <= 10'd0;    y1 <= 10'd4;    @(posedge done);

        // steep, right up
        x0 <= 10'd2;    y0 <=  10'd4;   x1 <= 10'd0;    y1 <= 10'd0;    @(posedge done);

        $stop; // stop simulation
    end // initial

endmodule // line_drawer_tb