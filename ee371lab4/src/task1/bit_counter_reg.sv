module bit_counter_reg #(parameter N=8) (clk, clear_result, load_a, right_shift_a,
                                         incr_result, a_input, a_eq_zero, a0, result);

    input logic clk, clear_result, load_a, right_shift_a, incr_result;
    input logic [N-1:0] a_input;
    output logic a_eq_zero, a0;
    output logic [$clog2(N):0] result;

    logic [N-1:0] a; //= {default : '0};

    always_ff @(posedge clk) begin
        if (clear_result) 
            result <= '0;
        if (load_a)
            a <= a_input;
        if (right_shift_a)
            a <= a >> 1;
        if (incr_result)
            result <= result + 1;
    end // always_ff

    // output logic
    assign a_eq_zero = (a == '0);
    assign a0 = (a[0]);

endmodule // bit_counter_reg