// top level for task 1
// include seg7 module
module task1_top (CLOCK_50, SW, KEY, HEX0, LEDR);
    input logic CLOCK_50;
    input logic [9:0] SW;
    input logic [3:0] KEY;
    output logic [6:0] HEX0;
    output logic [9:0] LEDR;

    parameter int N = 8;

    logic [$clog2(N):0] result;

    logic clk, reset, s, done;
    assign clk = CLOCK_50;
    assign reset = ~KEY[0];
    assign s = ~KEY[3];
    assign LEDR[9] = done;

    logic [N-1:0] a_input;
    assign a_input = SW[7:0];

    bit_counter #(.N(N)) counter (.*);


    seg7 hex0 (.hex(result), .leds(HEX0));


endmodule // task1_top