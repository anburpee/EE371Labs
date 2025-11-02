module DE1_SoC (CLOCK_50, SW, KEY, HEX0, HEX1, LEDR);
    input logic CLOCK_50;
    input logic [9:0] SW;
    input logic [3:0] KEY;
    output logic [6:0] HEX0, HEX1;
    output logic [9:0] LEDR;

    logic clk;
    assign clk = CLOCK_50;

    logic key0, key3, sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw7, sw9;

    anti_metastability anti1 (.clk(clk), .in(KEY[0]), .out(key0));
    anti_metastability anti2 (.clk(clk), .in(KEY[3]), .out(key3));
    anti_metastability anti3 (.clk(clk), .in(SW[0]), .out(sw0));
    anti_metastability anti4 (.clk(clk), .in(SW[1]), .out(sw1));
    anti_metastability anti5 (.clk(clk), .in(SW[2]), .out(sw2));
    anti_metastability anti6 (.clk(clk), .in(SW[3]), .out(sw3));
    anti_metastability anti7 (.clk(clk), .in(SW[4]), .out(sw4));
    anti_metastability anti8 (.clk(clk), .in(SW[5]), .out(sw5));
    anti_metastability anti9 (.clk(clk), .in(SW[6]), .out(sw6));
    anti_metastability anti10 (.clk(clk), .in(SW[7]), .out(sw7));
    anti_metastability anti11 (.clk(clk), .in(SW[9]), .out(sw9));

    logic reset, start, task1_done, task2_done;
    assign reset = ~key0;
    assign start = ~key3;
    logic [7:0] a;

    assign a = {sw7, sw6, sw5, sw4, sw3, sw2, sw1, sw0};


    // task1
    logic [3:0] result;

    bit_counter #(.N(8)) counter (.clk(clk), .reset(reset), .s(start), .a_input(a), .result(result), .done(task1_done));

    logic [6:0] task1_hex0;

    seg7 hex0 (.hex(result), .done(task1_done), .leds(task1_hex0));


    // task2
    logic [4:0] loc;
    logic found;

    binary_search search (.clk(clk), .reset(reset), .start(start),
                          .a(a), .loc(loc), .done(task2_done), .found(found));

    logic [6:0] task2_hex0, task2_hex1;
    
    seg7_two_outputs hex_1_0 (.hex(loc), .found(found), .leds1(task2_hex1), .leds0(task2_hex0));


    // switch between tasks
    // switch 9 ON -> task2
    // swithch 9 OFF -> task1
    assign LEDR[9] = sw9 ? task2_done : task1_done;

    assign LEDR[0] = sw9 ? found : 1'b0;

    assign HEX1 = sw9 ? task2_hex1 : 7'b1111111;
    assign HEX0 = sw9 ? task2_hex0 : task1_hex0;

    
endmodule // DE1_SoC