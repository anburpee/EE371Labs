/* Given two points on the screen this module draws a line between
 * those two points by coloring necessary pixels
 *
 * Inputs:
 *   clk    - should be connected to a 50 MHz clock
 *   reset  - resets the module and starts over the drawing process
 *	 x0 	- x coordinate of the first end point
 *   y0 	- y coordinate of the first end point
 *   x1 	- x coordinate of the second end point
 *   y1 	- y coordinate of the second end point
 *
 * Outputs:
 *   x 		- x coordinate of the pixel to color
 *   y 		- y coordinate of the pixel to color
 *   write  - enable the VGA framebuffer to write in a new value
 *   done	- flag that line has finished drawing
 *
 */
module line_drawer(clk, reset, x0, y0, x1, y1, x, y, write, done); // added write as output
	input logic clk, reset;
	input logic [10:0]	x0, y0, x1, y1;
	output logic write, done; // added write
	output logic [10:0]	x, y;
	
    logic is_steep;
    logic err_gte_zero;
    logic x_eq_x1;
    logic init_load;
    logic swap_axes;
    // logic x_swap_y_swap;
    logic second_load;
    logic draw_yx;
    logic draw_xy;
    logic update_err;
    logic update_err_y;
    logic update_x;


	line_drawer_ctrl ctrl (
		.clk,
		.reset,
		.is_steep,
		.err_gte_zero,
		.x_eq_x1,
		.init_load,
		.swap_axes,
		// .x_swap_y_swap,
		.second_load,
		.draw_yx,
		.draw_xy,
		.update_err,
		.update_err_y,
		.update_x,
		.write, // NEED
		.done
	);

	line_drawer_reg reg_file (
		.clk,
		.reset,
		.x0,
		.y0,
		.x1,
		.y1, 
		.init_load,
		.swap_axes,
		// .x_swap_y_swap,
		.second_load,
		.draw_yx,
		.draw_xy,
		.update_err,
		.update_err_y,
		.update_x,
		.is_steep,
		.err_gte_zero,
		.x_eq_x1,
		.x_out(x),
		.y_out(y)
	);
	
endmodule  // line_drawer












/* Given two points on the screen this module draws a line between
 * those two points by coloring necessary pixels
 *
 * Inputs:
 *   clk    - should be connected to a 50 MHz clock
 *   reset  - resets the module and starts over the drawing process
 *	 x0 	- x coordinate of the first end point
 *   y0 	- y coordinate of the first end point
 *   x1 	- x coordinate of the second end point
 *   y1 	- y coordinate of the second end point
 *
 * Outputs:
 *   x 		- x coordinate of the pixel to color
 *   y 		- y coordinate of the pixel to color
 *   write  - enable the VGA framebuffer to write in a new value
 *   done	- flag that line has finished drawing
 *
//  */
// module line_drawer(clk, reset, x0, y0, x1, y1, x, y, write, done); // added write as output
// 	input logic clk, reset;
// 	input logic [10:0]	x0, y0, x1, y1;
// 	output logic write, done; // added write
// 	output logic [10:0]	x, y;
	
//     logic is_steep;
//     logic x0_gt_x1;
//     logic y0_lt_y1;
//     logic err_gte_zero;
//     logic x_eq_x1;
//     logic init_load;
//     logic swap_axes;
//     logic x_swap_y_swap;
//     logic load_delta_err_y_x;
//     logic ystep_pos;
//     logic ystep_neg;
//     logic draw_yx;
//     logic draw_xy;
//     logic update_err;
//     logic update_err_y;
//     logic incr_x;
// 	//new
// 	// logic decr_x;


// 	line_drawer_ctrl ctrl (
// 		.clk,
// 		.reset,
// 		.is_steep,
// 		.x0_gt_x1,
// 		.y0_lt_y1,
// 		.err_gte_zero,
// 		.x_eq_x1,
// 		.init_load,
// 		.swap_axes,
// 		.x_swap_y_swap,
// 		.load_delta_err_y_x,
// 		.ystep_pos,
// 		.ystep_neg,
// 		.draw_yx,
// 		.draw_xy,
// 		.update_err,
// 		.update_err_y,
// 		.incr_x,
// 		//new
// 		// .decr_x,
// 		//
// 		.write, // NEED
// 		.done
// 	);

// 	line_drawer_reg reg_file (
// 		.clk,
// 		.x0,
// 		.y0,
// 		.x1,
// 		.y1, 
// 		.init_load,
// 		.swap_axes,
// 		.x_swap_y_swap,
// 		.load_delta_err_y_x,
// 		.ystep_pos,
// 		.ystep_neg,
// 		.draw_yx,
// 		.draw_xy,
// 		.update_err,
// 		.update_err_y,
// 		.incr_x,
// 		//new
// 		// .decr_x,
// 		//
// 		.is_steep,
// 		.x0_gt_x1,
// 		.y0_lt_y1,
// 		.err_gte_zero,
// 		.x_eq_x1,
// 		.x_out(x),
// 		.y_out(y)
// 	);
	
// endmodule  // line_drawer