// testbench for fir.sv
// kept the default parameters for the data width (24) and N (4), the fifo size
`timescale 1 ps / 1 ps
module fir_tb();
    // use default parameters: D_WIDTH = 24 bits, N(fifo size) = 4
    logic clk, reset, enable;
    logic [23:0] data_in; 
    logic [23:0] data_out;

    fir dut (.*);

	// set up clock
	parameter period = 100;
	initial begin
		clk <= 0;
		forever #(period/2) clk <= ~clk;
	end // initial clock

	// test the device
	initial begin
        reset <= 1'b1;            @(posedge clk);
        reset <= 1'b0;            
        
        enable <= 1'b0;    data_in <= 24'd2;                 repeat(5) @(posedge clk);

        // read & write simultaneously into fifo buffer
        enable <= 1'b1;                                                @(posedge clk);
                                       data_in <= 24'd4;               @(posedge clk);
                                       data_in <= 24'd8;               @(posedge clk);
                                       data_in <= 24'd16;              @(posedge clk);
                                       data_in <= 24'd32;              @(posedge clk);
                                       data_in <= 24'd64;              @(posedge clk);
                                       data_in <= 24'd128;             @(posedge clk);
                                       data_in <= 24'd256;             @(posedge clk);
                                       data_in <= 24'd512;             @(posedge clk);
                                       data_in <= 24'd1024;            @(posedge clk);
                                       data_in <= 24'd2048;            @(posedge clk);
                                       data_in <= 24'd2048;            @(posedge clk);
                                       data_in <= 24'd2048;            @(posedge clk);
                                       data_in <= 24'd2048;            @(posedge clk);
                                       data_in <= 24'd2048;            @(posedge clk); // data_out should be 2048


        enable <= 1'b0;                                      repeat(3) @(posedge clk);

        $stop; // stop simulation
    end // initial

endmodule // fir_tb