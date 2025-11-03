// 32x8 RAM testbench to check that the timings match the lab spec
`timescale 1 ps / 1 ps
module ram_tb();
    logic [4:0] address;
	logic clock;
	logic[7:0] data;
	logic wren;
	logic [7:0] q;

    ram32x8 dut (.*);

    // clock
    parameter period = 100;
    initial begin
        clock <= 0;
        forever #(period/2) clock <= ~clock;
    end //initial clk

    // test the design
    integer i;
    initial begin
        // write in values
        @(posedge clock);

       
        wren <= 1'b1;     @(posedge clock);
         
        for (i=0; i<32; i++) begin
            address <= i;  data <= i; @(posedge clock);
        end

        @(posedge clock);

        $stop; // stop simulation
    end // initial


endmodule // ram_tb