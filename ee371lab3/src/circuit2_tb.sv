// testbench for circuit2.sv
// primarily for testing our logic for incrementing the ROM address in circuit2

`timescale 1 ps / 1 ps
module circuit2_tb();
    logic clk, reset, read_ready, write_ready, enable;
    logic [23:0] d_out;

    circuit2 dut (.*);

	// set up clock
	parameter period = 100;
	initial begin
		clk <= 0;
		forever #(period/2) clk <= ~clk;
	end // initial clock

	// test the device
    integer i;
	initial begin
        reset <= 1'b1;                                                        @(posedge clk);
        reset <= 1'b0;  read_ready <= 1'b0;  write_ready <= 1'b0;   repeat(5) @(posedge clk);

        // address doesn't increment
        read_ready <= 1'b0;  write_ready <= 1'b1;                   repeat(5) @(posedge clk);

        // address doesn't increment
        read_ready <= 1'b0;  write_ready <= 1'b0;                   repeat(5) @(posedge clk);

        // address doesn't increment
        read_ready <= 1'b1;  write_ready <= 1'b0;                   repeat(5) @(posedge clk);

        // address doesn't increment
        read_ready <= 1'b0;  write_ready <= 1'b0;                   repeat(5) @(posedge clk);

        // address INCREMENTS
        read_ready <= 1'b1;  write_ready <= 1'b1;                   repeat(5) @(posedge clk);

        // address doesn't increment
        read_ready <= 1'b0;  write_ready <= 1'b1;                   repeat(5) @(posedge clk);

        // address INCREMENTS
        read_ready <= 1'b1;  write_ready <= 1'b1;                   repeat(5) @(posedge clk);

        // address doesn't increment
        read_ready <= 1'b1;  write_ready <= 1'b0;                   repeat(5) @(posedge clk);

        // address INCREMENTS
        read_ready <= 1'b1;  write_ready <= 1'b1;                   repeat(5) @(posedge clk);


        for (i=0; i<47795; i++) begin
            read_ready <= 1'b1;  write_ready <= 1'b0;                             @(posedge clk);

            read_ready <= 1'b1;  write_ready <= 1'b1;                             @(posedge clk);
        end

        $stop; // stop simulation
    end // initial

endmodule // circuit2_tb