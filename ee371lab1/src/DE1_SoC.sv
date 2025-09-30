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
        logic reset;
		  assign reset = V_GPIO[30];
		  logic [31:0] div_clock;
        // comment out one clock based on whether using simulation or pushing to board
        // assign clk = div_clock[25]; // change clock speed by changing which clock to use on board
		  assign clk = CLOCK_50; // for simulation

		  
		  
		  // set up clock divider
		  clock_divider divider (.clock(CLOCK_50), .divided_clocks(div_clock));
		  

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
        parking_lot_occupancy plo (.HEX0(HEX0), .HEX1(HEX1),
                               .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), 
                               .num_cars(num_cars));

endmodule  // DE1_SoC




module DE1_SoC_testbench();

        // define signals
        logic   CLOCK_50;
        logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
        logic [9:0] LEDR;
        wire  [35:0] V_GPIO; // inout pins must be connected to a wire type

        // additional logic required to simulate inout pins
        logic [35:0] V_GPIO_in;
        logic [35:0] V_GPIO_dir; // 1 = input, 0 = output

        // set up tristate buffers for inout pins
        genvar i;
        generate
                for (i = 0; i < 36; i++) begin : gpio
                        assign V_GPIO[i] = V_GPIO_dir[i] ? V_GPIO_in[i] : 1'bZ;
                end
        endgenerate

        // set pin directions
        assign V_GPIO_dir[24] = 1; // input -- inner switch
        assign V_GPIO_dir[28] = 1; // input -- outer switch
        assign V_GPIO_dir[30] = 1; // input -- reset
        assign V_GPIO_dir[26] = 0; // output -- inner sensor activation signal
        assign V_GPIO_dir[34] = 0; // output -- outer sensor activation signal

        // define parameters
        parameter T = 20;

        // instantiate module
        DE1_SoC dut (.*);

        // define simulated clock
        initial begin
                CLOCK_50 <= 0;
                forever #(T/2)  CLOCK_50 <= ~CLOCK_50;
        end  // initial clock

		  
		  // test the design
		  integer j;
        initial begin
                                                                        @(posedge CLOCK_50);
                V_GPIO_in[30] <= 1;                                        @(posedge CLOCK_50); // reset

                V_GPIO_in[30] <= 0; 

                // enter 17 times
                for (j = 0; j <= 17; j++) begin 
                        //outer sw       inner sw
                        V_GPIO_in[28] <= 0; V_GPIO_in[24] <= 0;      @(posedge CLOCK_50); // 00
                        V_GPIO_in[28] <= 1; V_GPIO_in[24] <= 0;      @(posedge CLOCK_50); // 10
                        V_GPIO_in[28] <= 1; V_GPIO_in[24] <= 1;      @(posedge CLOCK_50); // 11
                        V_GPIO_in[28] <= 0; V_GPIO_in[24] <= 1;      @(posedge CLOCK_50); // 01
                        V_GPIO_in[28] <= 0; V_GPIO_in[24] <= 0;      @(posedge CLOCK_50); // 00 --> enter
                end // for loop

                // exit 17 times
                for (j = 0; j <= 17; j++) begin 
                        //outer sw       inner sw
                        V_GPIO_in[28] <= 0; V_GPIO_in[24] <= 0;      @(posedge CLOCK_50); // 00
                        V_GPIO_in[28] <= 0; V_GPIO_in[24] <= 1;      @(posedge CLOCK_50); // 01
                        V_GPIO_in[28] <= 1; V_GPIO_in[24] <= 1;      @(posedge CLOCK_50); // 11
                        V_GPIO_in[28] <= 1; V_GPIO_in[24] <= 0;      @(posedge CLOCK_50); // 10
                        V_GPIO_in[28] <= 0; V_GPIO_in[24] <= 0;      @(posedge CLOCK_50); // 00 --> exit
                end // for loop

                $stop; // stop simulation
        end // initial signals




endmodule  // DE1_SoC_tb