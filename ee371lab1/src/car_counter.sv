// car_counter.sv will keep track of how many cars are in the lot
// its inputs are from car_detection (whether a car has entered/exited)
// its outputs will be to parking_lot_occupancy.sv (current car count)


module car_counter (clk, reset, incr, decr, count);
    output logic [4:0] count;
    input logic clk, reset, incr, decr;

    // states representing the parking lot occupancy at a given time
    typedef enum logic [4:0] {zero, one, two, three, four, five,
                              six, seven, eight, nine, ten, eleven,
                              twelve, thirteen, fourteen, fifteen, sixteen} states;

    states ns, ps;

    // next state logic
    always_comb begin
        if (ps > 5'b0 && decr)
            ns = ps - 1;
        else if (ps < 5'b16 && incr)
            ns = ps + 1;
        else
            ns = ps;
    end // always_comb


    // state update logic
    always_ff @(posedge clk) begin
        if (reset)
            ps <= zero;
        else
            ps <= ns;
    end // always_ff


    // output logic
    always_comb begin
        assign count = ps;
    end // always_comb


endmodule // car_counter


module car_counter_testbench();
    logic [4:0] count;
    logic clk, reset, incr, decr;

    car_counter_testbench dut (.*);

    // simulated clock 
    parameter clk_period = 100;
    initial begin
        clk <= 0;
        forever #(period/2) // forever togle the clock
            clk <= ~clk;
    end // simulated clock


endmodule // car_counter_testbench