module line_drawer_reg (
    input logic clk,
    //input logic reset,
    //input logic start,
    input logic [] x0,
    input logic [] y0,
    input logic [] x1,
    input logic [] y1, 
    input logic [] x_out,
    input logic [] y_out,
    input logic init_load,
    input logic swap_axes,
    input logic x_swap_y_swap,
    input logic load_delta,
    input logic load_err_y_x,
    input logic ystep_pos,
    input logic ystep_neg,
    // input logic write,
    input logic draw_yx,
    input logic draw_xy,
    input logic update_err,
    input logic update_err_y,
    input logic incr_x,
    output logic is_steep,
    output logic x0_gt_x1,
    output logic y0_lt_y1,
    output logic err_gte_zero,
    output logic x_eq_x0,
    );

    logic [10:0] x0_t, x1_t, y0_t, y1_t, deltax, deltay, x, y;
    logic signed [1:0] ystep;
    logic signed [11:0] err;

    always_ff @(posedge clk) begin
        if(init_load) begin
            x0_t <= x0;
            x1_t <= x1;
            y0_t <= y0;
            y1_t <= y1;
        end
        if (swap_axes) begin
            x0_t <= y0_t;
            x1_t <= y1_t;
            y0_t <= x0_t;
            y1_t <= x1_t;
        end
        if (x_swap_y_swap) begin
            x0_t <= x1_t;
            x1_t <= x0_t;
            y0_t <= y1_t;
            y1_t <= y0_t;
        end
        if (load_delta) begin
            deltax <= x1_t - x0_t;
            deltay <= ((y1_t - y0_t) >= 0) ? (y1_t - y0_t) : -(y1_t - y0_t);
        end
        if (load_err_y_x) begin
            err <= -(deltax >> 1);
            x <= x0_t;
            y <= y0_t;
        end
        if (ystep_pos) begin
            ystep <= 2'sb01; // 1
        end
        if (ystep_neg) begin
            ystep <= 2'sb11; // -1
        end
        if (draw_yx) begin
            x_out <= y;
            y_out <= x;
        end
        if (draw_xy) begin
            x_out <= x;
            y_out <= y;
        end
        if (update_err) begin
            err <= err + deltay;
        end
        if (update_err_y) begin
            y <= y + ystep;
            err <= err - deltax
        end
        if (incr_x) begin
            x <= x + 1;
        end
    end // always_ff

    // output logic
    assign is_steep = ((y1 - y0) > (x1 - x0));
    assign x0_gt_x1 = (x0 > x1);
    assign y0_lt_y1 = (y0 < y1);
    assign err_gte_zero = (err >= 0);
    assign x_eq_x0 = (x == x0);

endmodule // line_drawer_ctrl