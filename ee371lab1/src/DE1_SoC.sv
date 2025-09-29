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

//     // Turn off all 7-seg displays (active low: 1 = off, 0 = on)
//         assign HEX0 = 7'b1111111;
//         assign HEX1 = 7'b1111111;
//         assign HEX2 = 7'b1111111;
//         assign HEX3 = 7'b1111111;
//         assign HEX4 = 7'b1111111;
//         assign HEX5 = 7'b1111111;


        // set up reset signal and clock
        logic reset, clk;
        assign reset = V_GPIO[30]
        assign clk = CLOCK_50;

        // set up sensors to be represented by switch inputs on breadboard
        logic inner_sensor, outer_sensor;
        assign inner_sensor = V_GPIO[24]; // switch 1 (inner)
        assign outer_sensor = V_GPIO[28]; // switch 2 (outer)

        // have 2 leds on breadboard to light up when the inner and outer sensors
        // are activited respectively
        logic inner_led, outer_led;
        assign inner_led = inner_sensor;
        assign outer_led = outer_sensor;


        // instantiate car_detection module
        car_detection cd (.clk(clk), .reset(reset),
                          .inner_sw(inner_sensor), .outer_sw(outer_sensor),
                          .inner_led, .outer_led, .enter, .exit);
 

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