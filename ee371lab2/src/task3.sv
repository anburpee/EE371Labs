// 32x3 RAM implementation using dual read/write addresses

module task3 (clk, wren, w_address, r_address, data_in, data_out);
    input logic clk, wren;
    input logic [4:0] w_address, r_address;
    input logic [2:0] data_in;
    output logic [2:0] data_out;

    logic [2:0] memory_array [0:31];

    always_ff @(posedge clk) begin
        if (wren) begin
            memory_array[w_address] <= data_in;
            data_out <= data_in; // reads the new value
        end
        else begin
        data_out <= memory_array[r_address]; // reads the old value
        end
    end //always_ff

endmodule // task3

// testbench
`timescale 1 ps / 1 ps
module task3_testbench(); 
    logic clk, wren;
    logic [4:0] w_address, r_address;
    logic [2:0] data_in;
    logic [2:0] data_out;

    task3 dut (.*);

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
        // write to and read from the same address
        for (i = 0; i < 2**5; i++) begin
            w_address <= i;
            r_address <= i;
            data_in <= i; // repeats values 0-7 since values are truncated to 3 bits
            @(posedge clk);
            $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                     i, address, address, data_in, data_in, data_out, data_out);
        end // for loop

        // write to and read from different addresses
        for (i = 0; i < 2**5; i++) begin
            w_address <= i;
            r_address <= i + 1; // since r_address is t 1+w_address, data_out 
                                // will start at 1 and cycle through 0-7 until
                                // last iteration (even thoug data_in = 0)
            data_in <= 3'b000; 
            @(posedge clk);
            $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                     i, address, address, data_in, data_in, data_out, data_out);
        end // for loop

        // write enable is off
        // so writing anything to the addresses shouldn't do anything
        // data_out should read all zeros
        wren <= 1'b0; 
        for (i = 0; i < 2**5; i++) begin
            w_address <= i;
            r_address <= i;
            data_in <= i;
            @(posedge clk);
            $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                     i, address, address, data_in, data_in, data_out, data_out);
        end // for loop
        // one additional clock edge to see the read of the 31st word line because 
        // the read happens one clock cycle after the write
        @(posedge clk);
        $display("Value of i: %d. Value of address: %d, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                 i, address, address, data_in, data_in, data_out, data_out);

        $stop; // stop simulation
    end //initial signals 
endmodule // task3_testbench