// control circuit for bit_counter.sv
// inputs:
// outputs:
// modified logic for load_a (asserted once after s instead of
// continual assertion while s == 0)
module bit_counter_ctrl (clk, reset, s, a_eq_zero, a0,
                         clear_result, load_a, incr_result, right_shift_a, done);

    input logic clk, reset, s, a_eq_zero, a0;
    output logic clear_result, load_a, incr_result, right_shift_a, done;

    // states
    enum {s1, s2, s3} ps, ns;

    // next state logic
    always_comb begin
        case (ps)
            s1: ns = s ? s2 : s1;

            s2: ns = a_eq_zero ? s3 : s2;

            s3: ns = s ? s3 : s1;
        endcase
    end // always_comb


    // state update logic
    always_ff @(posedge clk) begin
        if (reset)
            ps <= s1;
        else 
            ps <= ns;
    end // always_ff


    // output logic
    assign clear_result = (ps == s1);
    assign load_a = ((ps == s1) && (~s));
    assign incr_result = ((ps == s2) && (a0));
    assign right_shift_a = (ps == s2);
    assign done = (ps == s3);

endmodule // bit counter_ctrl