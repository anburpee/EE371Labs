// this module implements a 32x3 RAM block using a multidimentional array
module task2 (clk, address, data_in, data_out, wren);
    input logic clk, wren;
    input logic [4:0] address;
    input logic [2:0] data_in;
    output logic [2:0] data_out;

    logic [2:0] memory_array [31:0];

    always_ff @(posedge clk) begin
        if (wren) 
            memory_array[address] <= data_in;
        data_out <= data_in;
    end //always_ff

endmodule // task2


// testbench
`timescale 1 ps / 1 ps
module task2_testbench(); 
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
endmodule // task2_testbench