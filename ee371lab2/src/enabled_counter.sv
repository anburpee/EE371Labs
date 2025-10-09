// this is a counter module that cycles through 0 to 31
// counter increments every 50,000,000 clock cycles
// (if 50MHZ clk is passed in, count increments every second)
// outputs the count, which is put in as the signal for the read address
// in the task3 module

module enabled_counter (clk, reset, count);
    input logic clk, reset;
    output logic [4:0] count;

    logic count_enable = 1'b0;
    logic [26:0] clk_cycles = 26'd0; // need 26 bits to make 50 million

    logic [26:0] num_cycles_threshold;
    // assign num_cycles_threshold = 50000000; // for board
    assign num_cycles_threshold = 5; // for simulation

    // logic for driving cout_enable
    always_ff @(posedge clk or posedge reset) begin // asynchronous reset
        if (reset) begin
            count_enable <= 1'b0;
            clk_cycles <= 26'b0;
        end // if
        else begin
            if (clk_cycles >= num_cycles_threshold) begin 
                count_enable <= 1'b1;
                clk_cycles <= 26'b0;
            end
            else begin
                count_enable <= 1'b0;
                clk_cycles <= clk_cycles + 1;
            end 
        end // else
    end // always_ff


    // logic for incrementing the count
    always_ff @(posedge clk or posedge reset) begin // asynchronous reset
        if (reset)
            count <= 5'b0;
        else if (count_enable) 
            count <= count + 1;
    end // always_ff

endmodule



// testbench
`timescale 1 ps / 1 ps
module enabled_counter_testbench(); 
    logic clk, reset;
    logic [4:0] count;

    enabled_counter dut (.*);

    parameter period = 100;

    // simulation clock
    initial begin
        clk <= 0;
        forever #(period/2) clk <= ~clk;
    end // initial clock

    integer i;
    // test module
    initial begin
        reset <= 1'b1;             @(posedge clk);
        reset <= 1'b0;             @(posedge clk);
                        repeat(20) @(posedge clk);

        $stop; // end simulation
    end // initial signals
endmodule