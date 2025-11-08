module line_drawer_ctrl (
    input logic clk,
    input logic reset,
    input logic start,
    input logic is_steep,
    input logic x0_gt_x1,
    input logic y0_lt_y1,
    input logic err_gte_zero,
    input logic x_eq_x0,
    output logic init_load,
    output logic swap_axes,
    output logic x_swap_y_swap,
    output logic load_delta,
    output logic load_err_y_x,
    output logic ystep_pos,
    output logic ystep_neg,
    output logic draw_yx,
    output logic draw_xy,
    output logic update_err,
    output logic update_err_y,
    output logic incr_x,
    output logic write,
    output logic done
    );

    // states
    typedef enum logic [3:0] {s_idle, s_check_steep, s_check_neg_slope,
                              s_load2, s_load3, s_draw, s_err_known, s_done} states;

    states ps, ns;

    // next state logic
    always_comb begin
        case(ps)
            s_idle:             ns = start ? s_check_steep : s_idle;

            s_check_steep:      ns = s_check_neg_slope;

            s_check_neg_slope:  ns = s_load2;

            s_load2:            ns = s_load3;

            s_load3:            ns = s_draw;

            s_draw:             ns = s_err_known;

            s_err_known:        ns = x_eq_zero ? s_done : s_draw;

            s_done:             ns = start ? s_done : s_idle;

        endcase
    end // always_comb


    // staet update logic
    always_ff @(posedge clk) begin
        if (reset)
            ps <= s_idle;
        else
            ps <= ns;
    end; // always_ff

    // control signals
    assign init_load = ((ps == s_idle) && start);
    assign swap_axes = ((ps == s_check_steep) && is_steep);
    assign x_swap_y_swap = ((ps == s_check_neg_slope) && x0_gt_x1);
    assign load_delta = (ps == s_load2);
    assign load_err_y_x = (ps == s_load3);
    assign ystep_pos = ((ps == s_load3) && yo_lt_y1);
    assign ystep_neg = ((ps == s_load3) && (~yo_lt_y1));
    assign draw_yx = ((ps == s_draw) && is_steep)
    assign draw_xy = ((ps == s_draw) && (~is_steep));
    assign update_err = ((ps == s_draw) && (~is_steep));
    assign update_err_y = ((ps == s_err_known) && err_gte_zero);
    assign incr_x = ((ps == s_err_known) && (~x_eq_x0));

    // system outputs
    assign write = (ps == s_draw);
    assign done = (ps == s_done);



endmodule // line_drawer_ctrl