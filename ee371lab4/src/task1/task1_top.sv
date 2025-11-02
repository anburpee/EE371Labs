// top level for task 1
// include seg7 module
module task1_top (CLOCK_50, SW, KEY, HEX0, LEDR);
    input logic CLOCK_50;
    input logic [9:0] SW;
    input logic [3:0] KEY;
    output logic [6:0] HEX0;
    output logic [9:0] LEDR;

    logic [3:0] result;

    logic clk;
    assign clk = CLOCK_50;

    anti_metastability anti1 (.clk(clk), .in(KEY[0]), .out(key0));
    anti_metastability anti2 (.clk(clk), .in(KEY[3]), .out(key3));
    anti_metastability anti3 (.clk(clk), .in(SW[0]), .out(sw0));
    anti_metastability anti4 (.clk(clk), .in(SW[1]), .out(sw1));
    anti_metastability anti5 (.clk(clk), .in(SW[2]), .out(sw2));
    anti_metastability anti6 (.clk(clk), .in(SW[3]), .out(sw3));
    anti_metastability anti7 (.clk(clk), .in(SW[4]), .out(sw4));
    anti_metastability anti8 (.clk(clk), .in(SW[5]), .out(sw5));
    anti_metastability anti9 (.clk(clk), .in(SW[6]), .out(sw6));
    anti_metastability anti0 (.clk(clk), .in(SW[7]), .out(sw7));



    logic reset, s, done;
    assign reset = ~key0;
    assign s = ~key3;
    assign LEDR[9] = done;

    logic [7:0] a_input;
    assign a_input = {sw7, sw6, sw5, sw4, sw3, sw2, sw1, sw0};

    bit_counter #(.N(8)) counter (.*);


    seg7 hex0 (.hex(result), .done(done), .leds(HEX0));


endmodule // task1_top