// top level module for task2 that performs the binary search functionality
// LEDR[9] is driven high when computation is complete
// LEDR[0] is driven if the 8 bit target value, specified by SW[7:0]
// is found in the 32x8 RAM instantiated in the binary_search datapath
// input KEY[3] is the start signal for the computation
// input KEY[0] is the reset signal
// if the target value is found, the RAM address at which it was found
// is displayed on HEX1-HEX0
module task2_top (CLOCK_50, SW, KEY, HEX0, HEX1, LEDR);
    input logic CLOCK_50;
    input logic [9:0] SW;
    input logic [3:0] KEY;
    output logic [6:0] HEX0, HEX1;
    output logic [9:0] LEDR;

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

    logic reset, start, found, done;
    assign reset = ~key0;
    assign start = ~key3;
    assign LEDR[9] = done;
    assign LEDR[0] = found;
    logic [7:0] a;
    logic [4:0] loc;

    assign a = {sw7, sw6, sw5, sw4, sw3, sw2, sw1, sw0};

    binary_search search (.clk(clk), .reset(reset), .start(start),
                          .a(a), .loc(loc), .done(done), .found(found));
    
    
    seg7_two_outputs hex_1_0 (.hex(loc), .found(found), .leds1(HEX1), .leds0(HEX0));


endmodule