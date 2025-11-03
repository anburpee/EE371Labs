// Given an N bit binary number, counts the number of 1's in that number
// Uses bit_counter_ctrl and bit_counter_reg as the control and datapath modules
// 1 bit inputs clock, reset, s (start) and N-bit a_input, the binary number
// to check the numbers of 1's in, all from top-level (task1_top, DE1_SoC)
// log2(N)-bit output result, the number of 1's in the given a_input
// 1 bit output done, also to top level
module bit_counter #(parameter N=8) (clk, reset, s, a_input, result, done);
    input logic clk, reset, s;
    input logic [N-1:0] a_input;
    output logic [$clog2(N):0] result; // ceiling log base 2 -- for using minimum number of bits to address value
    output logic done;

    logic a_eq_zero, a0, clear_result, load_a, right_shift_a, incr_result;

    bit_counter_ctrl ctrl (.*);
    bit_counter_reg #(.N(N)) reg_file (.*);

endmodule // bit_counter.sv