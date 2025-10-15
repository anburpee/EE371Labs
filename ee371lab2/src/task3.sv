// 32x3 RAM implementation using dual read/write addresses

module task3 (clk, wren, w_address, r_address, data_in, data_out);
    input logic clk, wren;
    input logic [4:0] w_address, r_address;
    input logic [2:0] data_in;
    output logic [2:0] data_out;


    // instantiate ram32x3port2
    ram32x3port2 ram (.clock(clk), .data(data_in), .rdaddress(r_address),
                      .wraddress(w_address), .wren(wren), .q(data_out));

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
    // test task3 module
    initial begin
        wren <= 1'b1; @(posedge clk); // write-enabled
        // write to and read from the same address
        // should display 0s since mif file contains all 0s
        for (i = 0; i < 2**5; i++) begin
            w_address <= i;
            r_address <= i;
            data_in <= i; // repeats values 0-7 since values are truncated to 3 bits
            @(posedge clk);
            $display("Value of i: %d. Value of address (w & r): %b, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                     i, w_address, r_address, data_in, data_in, data_out, data_out);
        end // for loop

        $display ("----------------- wren off -------------------");
        
        wren <= 1'b0; @(posedge clk); // write-enabled
        for (i = 0; i < 2**5; i++) begin
            w_address <= i;
            r_address <= i;
            data_in <= i; // repeats values 0-7 since values are truncated to 3 bits
            @(posedge clk);
            $display("Value of i: %d. Value of address (w & r): %b, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                     i, w_address, r_address, data_in, data_in, data_out, data_out);
        end // for loop

        $display ("----------------- read from 1 address before the write address (reads the value that was just written in) -------------------");
        wren <= 1'b1; @(posedge clk); // write-enabled
        // write to and read from different addresses
        for (i = 0; i < 2**5; i++) begin
            w_address <= i + 1;
            r_address <= i; 
            data_in <= 3'b000; 
            @(posedge clk);
            $display("Value of i: %d. Value of address (w & r): %b, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                     i, w_address, r_address, data_in, data_in, data_out, data_out);
        end // for loop

        $display ("----------------- wren off, same write and read address -------------------");
        // write enable is off
        // so writing anything to the addresses shouldn't do anything
        // data_out should read all zeros
        wren <= 1'b0; 
        for (i = 0; i < 2**5; i++) begin
            w_address <= i;
            r_address <= i;
            data_in <= i;
            @(posedge clk);
            $display("Value of i: %d. Value of address (w & r): %b, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                     i, w_address, r_address, data_in, data_in, data_out, data_out);
        end // for loop
        
        $display ("----------------- wren off, check that nothing from previous loop got written in -------------------");
        // one for for-loop to check that no data was written in from previous for-loop
        for (i = 0; i < 2**5; i++) begin
            w_address <= i;
            r_address <= i;
            data_in <= i;
            @(posedge clk);
            $display("Value of i: %d. Value of address (w & r): %b, %b. Value of data_in: %d, %b. Value of data_out: %d, %b.",
                     i, w_address, r_address, data_in, data_in, data_out, data_out);
        end // for loop

        $stop; // stop simulation
    end //initial signals 
endmodule // task3_testbench