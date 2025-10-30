// top level for task 1
// include seg7 module
module task1_top (CLOCK_50, SW, KEY, HEX0, LEDR);
    input logic CLOCK_50;
    input logic [9:0] SW;
    input logic [3:0] KEY;
    input logic [6:0] HEX0;
    input logic [9:0] LEDR;

    const int N = 8;

    logic [$clog2(N)] result;

    bit_counter #(.N(N)) counter (.clk(CLOCK_50), .reset(~KEY[0]), .s(~KEY[3]),
                                  .a_input(SW[7:0]), .result(result), .done(LEDR[9]));

    seg7 hex0 (.hex(result), .leds(HEX0));


endmodule // task1_top