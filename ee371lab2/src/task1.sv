// this module implements a 32x3 RAM block using a Quartus library module

module task1 (clk, address, data_in, wren, data_out);
    input logic clk, wren;
    input logic [4:0] address;
    input logic [2:0] data_in;
    output logic [2:0] data_out;

    ram32x3 ram (.address(address), .clock(clk), .data(data_in),
                 .wren(wren), .q(data_out));

endmodule // task1

// we can enable/disable writing to the memory address - so to test, we want to enable write and disable it
// and see what the value of the mem block is when we try inputting data
// it should update if wren = 1
// it should not if wren = 0
// also it should read the data out and maybe $display it or just use waveforms
`timescale 1 ps / 1 ps
module task1_testbench(); 
    logic clk, wren;
    logic [4:0] address;
    logic [2:0] data_in;
    logic [2:0] data_out;

    task1 dut (.*);

    parameter period = 100;

    // simulation clock
    initial begin
        clk <= 0;
        forever #(period/2) clk <= ~clk;
    end // initial clock

    integer i;
    // test task1 module
    initial begin
        wren <= 1'b1; @(posedge clk); // write-enabled
        // write in all zeros
        for (i = 0; i < 2**5; i++) begin
            address <= i;
            data_in <= 3'b000;
            @(posedge clk);
            $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                     i, address, address, data_in, data_in, data_out, data_out);
            // @(posedge clk);
        end // for loop

        // now write something different in a few of the addresses
        // just to see something interesting lol
        for (i = 0; i < 2**5; i++) begin
            address <= i;
            data_in <= i; // repeats values 0-7 since values are truncated to 3 bits
            @(posedge clk);
            $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                     i, address, address, data_in, data_in, data_out, data_out);
            // @(posedge clk);
        end // for loop

        // write enable is off
        // so writing anything to the addresses shouldn't do anything
        wren <= 1'b0; 
        for (i = 0; i < 2**5; i++) begin
            address <= i;
            data_in <= 3'b000;
            @(posedge clk);
            $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                     i, address, address, data_in, data_in, data_out, data_out);
            // @(posedge clk);
        end // for loop
        // one additional clock edge to see the read of the 31st word line because 
        // the read happens one clock cycle after the write
        @(posedge clk);
        $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                 i, address, address, data_in, data_in, data_out, data_out);

        $stop; // stop simulation
    end //initial signals 
endmodule // task1_testbench