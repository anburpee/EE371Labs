// car_detection.sv is for detecting whether the enter/exit sequence has been completed (FSM)
// its inputs include SW (inner/outer sensor activation)
// its outputs include 1 bit signals for whether a car has entered/exited and LEDs

module car_detection (clk, reset, inner_sw, outer_sw, enter, exit);
    output logic enter, exit; // output to car_counter module !!
    input logic clk, reset; // inputted from DE1_SoC top level module
    input logic inner_sw, outer_sw; // inputted from DE1_SoC top level module

    enum logic [1:0] {s0, s1, s2, s3} states;
    states ps, ns;

    always_comb begin
        // implementing mealy machine: outputs depend on ps and inputs
        case (ps)
            s0: begin
                if (outer_sw && ~inner_sw) begin
                    ns = s2;
                    enter = 0;
                    exit = 0;
                end
                else if (~outer_sw && inner_sw) begin
                    ns = s1;
                    enter = 0;
                    exit = 0;
                end
                else begin
                    ns = s0;
                    enter = 0;
                    exit = 0;
                end
            end

            s1: begin
                if (~outer_sw && ~inner_sw) begin
                    ns = s0;
                    enter = 1;
                    exit = 0;
                end
                else if (outer_sw && inner_sw) begin
                    ns = s3;
                    enter = 0;
                    exit = 0;
                end
                else begin
                    ns = s0;
                    enter = 0;
                    exit = 0;
                end
            end

            s2: begin
                if (~outer_sw && ~inner_sw) begin
                    ns = s0;
                    enter = 0;
                    exit = 1;
                end
                else if (outer_sw && inner_sw) begin
                    ns = s3;
                    enter = 0;
                    exit = 0;
                end
                else begin
                    ns = s0;
                    enter = 0;
                    exit = 0;
                end
            end

            s3: begin
                if (outer_sw && ~inner_sw) begin
                    ns = s2;
                    enter = 0;
                    exit = 0;
                end
                else if (~outer_sw && inner_sw) begin
                    ns = s1;
                    enter = 0;
                    exit = 0;
                end
                else begin
                    ns = s0;
                    enter = 0;
                    exit = 0;
                end
            end
        endcase

        always_ff @(posedge clk) begin
            if (reset) begin
                ps <= s0;
            end
            else begin
                ps <= ns;
            end
        end
    end


endmodule