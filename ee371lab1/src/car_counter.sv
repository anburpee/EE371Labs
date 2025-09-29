// car_counter.sv will keep track of how many cars are in the lot
// its inputs are from car_detection (whether a car has entered/exited)
// its outputs will be to parking_lot_occupancy.sv (current car count)


module car_counter (clk, reset, incr, decr, count);
    output logic count;
    input logic clk, reset, incr, decr;

    // states representing the parking lot occupancy at a given time
    typedef enum logic [4:0] {zero, one, two, three, four, five,
                              six, seven, eight, nine, ten, eleven,
                              twelve, thirteen, fourteen, fifteen, sixteen} states;

    states ns, ps;

    // next state logic
    always_comb begin
        ns = ps; //default
        if (ps > 0 && decr)
            ns = ps - 1;
        else if (ps < sixteen && incr)
            ns = ps + 1;
        // else: ns = ps;
    end


    // sequential logic
    always_ff @(posedge clk) begin
        if (reset)
            ps <= zero;
        else
            ps <= ns;
    end


    // output logic
    always_comb begin
        assign count = ps;
    end

endmodule

