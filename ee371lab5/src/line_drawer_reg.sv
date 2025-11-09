// screen resolution: 640 x 480

module line_drawer_reg (
    input logic clk,
    input logic [10:0] x0,
    input logic [10:0] y0,
    input logic [10:0] x1,
    input logic [10:0] y1, 
    input logic init_load,
    input logic swap_axes,
    input logic x_swap_y_swap,
    input logic load_delta_err_y_x,
    input logic ystep_pos,
    input logic ystep_neg,
    input logic draw_yx,
    input logic draw_xy,
    input logic update_err,
    input logic update_err_y,
    input logic incr_x,
    output logic is_steep,
    output logic x0_gt_x1,
    output logic y0_lt_y1,
    output logic err_gte_zero,
    output logic x_eq_x1,
    output logic [10:0] x_out,
    output logic [10:0] y_out
    );

    logic [10:0] x0_t, x1_t, y0_t, y1_t, deltax, deltay, x, y;
    logic signed [1:0] ystep; // consider extending ystep to [11:0]
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
        if (load_delta_err_y_x) begin
            deltax <= x1_t - x0_t;
            deltay <= (y1_t >= y0_t) ? (y1_t - y0_t) : (y0_t - y1_t); // abs(delta y)
            err <= -($signed(x1_t - x0_t) >>> 1); // cast to signed since deltax is unsigned
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
            err <= err + $signed(deltay);
        end
        if (update_err_y) begin
            y <= $unsigned($signed(y) + ystep);
            err <= err - $signed(deltax);
        end
        if (incr_x) begin
            x <= x + 1;
        end
    end // always_ff

    // output logic
    assign is_steep = ((y1 > y0) ? ((x1 > x0) ? ((y1 - y0) > (x1 - x0)) : ((y1 - y0) > (x0 - x1))) : ((x1 > x0) ? ((y0 - y1) > (x1 - x0)) : ((y0 - y1) > (x0 - x1)))); // use original input variables
    assign x0_gt_x1 = (x0_t > x1_t);
    assign y0_lt_y1 = (y0_t < y1_t);
    assign err_gte_zero = (err >= 0);
    assign x_eq_x1 = (x == x1_t);

endmodule // line_drawer_reg