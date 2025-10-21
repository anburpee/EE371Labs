// testbench for circuit2.sv
`timescale 1 ps / 1 ps
module circuit2_tb();
    logic clk, reset, read_ready;
    logic [23:0] d_out;

    circuit2 dut (.*);

	// set up clock
	parameter period = 100;
	initial begin
		clk <= 0;
		forever #(period/2) clk <= ~clk;
	end // initial clock

	// test the device
	initial begin
        reset <= 1'b1;                                  @(posedge clk);
        reset <= 1'b0;  read_ready <= 1'b0;   repeat(5) @(posedge clk);

        read_ready <= 1'b1;                   repeat(10) @(posedge clk);


        $stop; // stop simulation
    end // initial

endmodule // circuit2_tb