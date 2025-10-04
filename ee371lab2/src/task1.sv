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
            data_in <= 3'b010;
            $display("Value of i: %d. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                     i, data_in, data_in, data_out, data_out);
            @(posedge clk);
        end // for loop
        wren <= 1'b0; 

        
        $stop;
    end //initial signals 
endmodule // task1_testbench