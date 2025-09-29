// DE1_SoC code given in Lab1 specs
// DE1_SoC testbench also given in Lab1 specs
// left name as is (_tb) in case it's referred to in runlab files or something idk

// DE1_SoC.sv is only for calling modules and connecting fw to board
// all actual logic should be in other modules/files

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO);

        input  logic             CLOCK_50;      // 50MHz clock
        output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;  // active low
        output logic [9:0] LEDR;
        inout  logic [35:0] V_GPIO;     // expansion header 0 (LabsLand board)


        // Set up reset signal and clock
        logic reset, clk;
        assign reset = V_GPIO[30]
        assign clk = CLOCK_50;

        // Set up sensors to be represented by switch inputs on breadboard
        logic inner_sensor, outer_sensor;
        assign inner_sensor = V_GPIO[24]; // switch 1 (inner)
        assign outer_sensor = V_GPIO[28]; // switch 2 (outer)

        // Have 2 leds on breadboard to light up when the inner and outer sensors
        // are activited respectively
        // Pin V_GPIO[26] connects to the inner LED
        // Pin V_GPIO[34] connects to the outer LED
        assign V_GPIO[26] = inner_sensor;
        assign V_GPIO[34] = outer_sensor;

        // Signals for when a car enters\exits 
        logic entered, exited;

        // Instantiate car_detection module
        car_detection cd (.clk(clk), .reset(reset), .inner_sw(inner_sensor),
                          .outer_sw(outer_sensor), .enter(entered), .exit(exited));

        // Signal representing parking lot occupancy
        logic num_cars;

        // Instantiate car_counter module
        car_counter cc (.clk(clk), .reset(reset),
                        .incr(entered), .decr(exited), .count(num_cars));

        // Instantiate parking_lot_occupancy module
        parking_lot_occupancy (.clk(clk), .reset(reset), .HEX0(HEX0), .HEX1(HEX1),
                               .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), 
                               .num_cars(num_cars));

endmodule  // DE1_SoC




module DE1_SoC_tb();

        // define signals
        logic   CLOCK_50;
        logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
        logic [9:0] LEDR;
        logic [35:0] V_GPIO;

        // define parameters
        parameter T = 20;

        // instantiate module
        DE1_SoC dut (.*);

        // define simulated clock
        initial begin
                CLOCK_50 <= 0;
                forever #(T/2)  CLOCK_50 <= ~CLOCK_50;
        end  // initial clock

endmodule  // DE1_SoC_tb