// Controller module for line_drawer 
// 1 bit inputs clk, reset from line_drawer.sv 
// 1 bit status signal inputs is_steep, err_gte_zero, x_eq_x1 from line_drawer_reg.sv
// 1 bit control signal outputs init_load, swap_axes, second_load, draw_yx, draw_yx,
// update_err, update_err_y, update_x, write sent to line_drawer_reg.sv
// 1 bit system outputs write, done 
module line_drawer_ctrl (
    input logic clk,
    input logic reset,
    input logic is_steep,
    input logic err_gte_zero,
    input logic x_eq_x1,
    output logic init_load,
    output logic swap_axes,
    output logic second_load,
    output logic draw_yx,
    output logic draw_xy,
    output logic update_err,
    output logic update_err_y,
    output logic update_x,
    output logic write,
    output logic done
    );

    // states
    typedef enum logic [2:0] {s_start, s_check_steep,
                              s_load2, s_assign_outs, s_write, s_done} states;

    states ps, ns;

    // next state logic
    always_comb begin
        ns = ps;
        case(ps)
            s_start:            ns = s_check_steep;

            s_check_steep:      ns = s_load2;

            s_load2:            ns = s_assign_outs;

            s_assign_outs:      ns = s_write;

            s_write:            ns = x_eq_x1 ? s_done : s_assign_outs;

            s_done:             ns = s_start;

        endcase
    end // always_comb


    // staet update logic
    always_ff @(posedge clk) begin
        if (reset) begin
            ps <= s_start;
        end
        else begin
                ps <= ns;
        end
    end // always_ff

    // control signals
    assign init_load = (ps == s_start);
    assign swap_axes = ((ps == s_check_steep) && is_steep);
    assign second_load = (ps == s_load2);
    assign draw_yx = ((ps == s_assign_outs) && is_steep);
    assign draw_xy = ((ps == s_assign_outs) && (~is_steep));
    assign update_err = ((ps == s_assign_outs));
    assign update_err_y = ((ps == s_write) && err_gte_zero);
    assign update_x = ((ps == s_write) && (~x_eq_x1));

    // system outputs
    assign write = (ps == s_write); 
    assign done = (ps == s_done);



endmodule // line_drawer_ctrl


////////////// unused: version with x_swap_y_swap //////////////
// module line_drawer_ctrl (
//     input logic clk,
//     input logic reset,
//     input logic is_steep,
//     input logic x0_gt_x1,
//     input logic y0_lt_y1,
//     input logic err_gte_zero,
//     input logic x_eq_x1,
//     output logic init_load,
//     output logic swap_axes,
//     output logic x_swap_y_swap,
//     output logic load_delta_err_y_x,
//     output logic ystep_pos,
//     output logic ystep_neg,
//     output logic draw_yx,
//     output logic draw_xy,
//     output logic update_err,
//     output logic update_err_y,
//     output logic incr_x,
//     ////
//     // output logic decr_x,
//     ///
//     output logic write,
//     output logic done
//     );

//     // states
//     typedef enum logic [2:0] {s_start, s_check_steep, s_check_neg_slope,
//                               s_load2, s_assign_outs, s_write, s_done} states;

//     states ps, ns;

//     // next state logic
//     always_comb begin
//         ns = ps;
//         case(ps)
//             s_start:            ns = s_check_steep;

//             s_check_steep:      ns = s_check_neg_slope;

//             s_check_neg_slope:  ns = s_load2;

//             s_load2:            ns = s_assign_outs;

//             s_assign_outs:      ns = s_write;

//             s_write:            ns = x_eq_x1 ? s_done : s_assign_outs;

//             s_done:             ns = s_start;

//         endcase
//     end // always_comb


//     // staet update logic
//     always_ff @(posedge clk) begin
//         if (reset) begin
//             ps <= s_start;
//         end
//         else begin
//             // if (enable)
//                 ps <= ns;
//         end
//     end // always_ff

//     // control signals
//     assign init_load = (ps == s_start);
//     assign swap_axes = ((ps == s_check_steep) && is_steep);
//     assign x_swap_y_swap = ((ps == s_check_neg_slope) && x0_gt_x1);
//     assign load_delta_err_y_x = (ps == s_load2);
//     assign ystep_pos = ((ps == s_load2) && y0_lt_y1);
//     assign ystep_neg = ((ps == s_load2) && (~y0_lt_y1));
//     assign draw_yx = ((ps == s_assign_outs) && is_steep);
//     assign draw_xy = ((ps == s_assign_outs) && (~is_steep));
//     assign update_err = ((ps == s_assign_outs));
//     assign update_err_y = ((ps == s_write) && err_gte_zero);
//     assign incr_x = ((ps == s_write) && (~x_eq_x1));
//     // assign incr_x = ((ps == s_write) && (~x_eq_x1) && ~(x0_gt_x1));
//     // assign decr_x = ((ps == s_write) && (~x_eq_x1) && (x0_gt_x1));

//     // system outputs
//     assign write = (ps == s_write); 
//     assign done = (ps == s_done);



// endmodule // line_drawer_ctrl