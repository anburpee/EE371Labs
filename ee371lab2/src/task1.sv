// this module implements a 32x3 RAM block using a Quartus library module

module task1 (clk, reset, address, data_in, wren, data_out)
    input logic clk, reset, address, wren;
    input logic [2:0] data_in;
    output logic [2:0] data_out;

    ram32x3 ram (.address(address) .clock(clk), .data(data_in),
                 .wren(wren), .q(data_out));

endmodule // task1

// we can enable/disable writing to the memory address - so to test, we want to enable write and disable it
// and see what the value of the mem block is when we try inputting data
// it should update if wren = 1
// it should not if wren = 0
// also it should read the data out and maybe $display it or just use waveforms
module task1_testbech
    // this module
endmodule // task1_testbench