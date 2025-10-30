module bit_counter #(parameter N=8) (clk, reset, s, a_input, result, done);
    input logic clk, reset, s;
    input logic [N-1:0] a_input;
    output logic [$clog2(N):0] result;
    output logic done;

    logic a_eq_zero, a0, clear_result, load_a, right_shift_a, incr_result;

    bit_counter_ctrl ctrl (.*);
    bit_counter_reg #(.N(N)) reg_file (.*);

endmodule // bit_counter.sv