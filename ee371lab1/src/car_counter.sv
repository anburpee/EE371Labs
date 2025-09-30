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
        if (ps > zero && decr)
            ns = states'(ps - 1);
        else if (ps < sixteen && incr)
            ns = states'(ps + 1);
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
    assign count = ps;



endmodule // car_counter


// testbench for car_counter
module car_counter_testbench();
    logic [4:0] count;
    logic clk, reset, incr, decr;

    car_counter dut (.*);

    // set up a simulated clock 
    parameter clk_period = 100;
    initial begin
        clk <= 0;
        forever #(clk_period/2) clk <= ~clk; // forever togle the clock
    end // initial clock

    // test the design
    integer i;
    initial begin
                                                    @(posedge clk);
        reset <= 1; incr <= 0; decr <= 0; repeat(4) @(posedge clk);
        reset <= 0; 
        
        // currently at state 0

        // test all transitions
        for (i = 0; i < (2**4 + 1); i++) begin // increment 17 times
            incr <= 1; @(posedge clk); 
        end // for loop

        // currently at state 16

        for (i = 0; i < (2**4 + 1); i++) begin // decrement 17 times
            decr <= 1; @(posedge clk); 
        end // for loop
    
        $stop; // end simulation
    end // initial signals

endmodule // car_counter_testbench