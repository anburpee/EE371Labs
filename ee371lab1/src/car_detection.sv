// car_detection.sv is for detecting whether the enter/exit sequence has been completed (FSM)
// its inputs include SW (inner/outer sensor activation)
// its outputs include 1 bit signals for whether a car has entered/exited and LEDs

module car_detection (clk, reset, inner_sw, outer_sw, enter, exit);
    output logic enter, exit; // output to car_counter module !!
    input logic clk, reset; // inputted from DE1_SoC top level module
    input logic inner_sw, outer_sw; // inputted from DE1_SoC top level module

    typedef enum logic [1:0] {s0, s1, s2, s3} states;
    states ps, ns;

    always_comb begin
        // implementing mealy machine: outputs depend on ps and inputs

        //default outputs
        enter = 0;
        exit = 0;

        case (ps)
            s0: begin
                if (outer_sw && ~inner_sw) begin
                    ns = s2;
                end
                else if (~outer_sw && inner_sw) begin
                    ns = s1;
                end
                else begin
                    ns = s0;
                end
            end // s0

            s1: begin
                if (~outer_sw && ~inner_sw) begin
                    ns = s0;
                    enter = 1;
                end
                else if (outer_sw && inner_sw) begin
                    ns = s3;
                end
                else begin
                    ns = s0;
                end
            end // s1

            s2: begin
                if (~outer_sw && ~inner_sw) begin
                    ns = s0;
                    exit = 1;
                end
                else if (outer_sw && inner_sw) begin
                    ns = s3;
                end
                else begin
                    ns = s0;
                end
            end // s2

            s3: begin
                if (outer_sw && ~inner_sw) begin
                    ns = s2;
                end
                else if (~outer_sw && inner_sw) begin
                    ns = s1;
                end
                else begin
                    ns = s0;
                end
            end // s3

        endcase // case(ps)
    end // always_comb

    always_ff @(posedge clk) begin
        if (reset) begin
            ps <= s0;
        end
        else begin
            ps <= ns;
        end
    end // always_ff



endmodule // car_detection


module car_detection_testbech();
    logic enter, exit; // output to car_counter module
    logic clk, reset; // inputted from DE1_SoC top level module
    logic inner_sw, outer_sw; // inputted from DE1_SoC top level module

    car_detection dut (.*);

    parameter clk_period = 100;

endmodule // car_detection_testbench