// determines input RGB values for video_driver.sv based on the (x, y) coordinates that video_driver.sv outputs
// start with basic functionality of displaying the current player locations
// if there's extra time, add in selection highlights around the square that is selected by the switches
// must output the correct rgb values within 2 cycles after the target x, y is outputted from video_driver.
// 480 x 480 board displayed in the center of the 480 x 640 pixel VGA display
module display_update (input logic clk,
                       input logic reset, // don't need?
                       input logic [9:0] x_vga,
                       input logic [8:0] y_vga,
                       input logic [2:0] encoding,
                       //input logic rom_reading, // for round tokens
                       output logic [5:0] read_addr,
                       output logic [7:0] r,
                       output logic [7:0] g,
                       output logic [7:0] b
                       );

    // determine:
    // light square vs dark square (even vs odd, % 2 then scale)
    // if there's a piece in that square and whether its red or black -- and if it's a king
    logic [7:0] r_next, g_next, b_next;

    // use later after testing with just colored squares
    // logic [5:0] x_relative, y_relative; // up to 60,  keeps track of which relative location you are within a square
    // assign x_relative = (x_vga - 80) % 60;
    // assign y_relative = y_vga % 60;

    logic [2:0] x_board, y_board; // current (x, y) of board based on x_vga, y_vga (x and y ranging from 0-7)
    assign x_board = (x_vga - 80) / 60;
    assign y_board = y_vga / 60;

    assign read_addr = 8 * y_board + x_board;

    // color assignments
    always_comb begin
        case (encoding) 
            // dark square
            3'b000: begin
                r_next = 8'd128;
                g_next = 8'd96;
                b_next = 8'd77;
            end

            // light square
            3'b001: begin
                r_next = 8'd196;
                g_next = 8'd164;
                b_next = 8'd132;
            end

            // normal red
            3'b010: begin // change to circle later
                r_next = 8'd140;
                g_next = 8'd0;
                b_next = 8'd0;
            end

            // normal black
            3'b011: begin // change to circle later
                r_next = 8'd0;
                g_next = 8'd0;
                b_next = 8'd0;
            end

            // king red
            3'b100: begin // change later
                r_next = 8'd100;
                g_next = 8'd0;
                b_next = 8'd100;
            end

            // king black
            3'b101: begin // change later
                r_next = 8'd0;
                g_next = 8'd100;
                b_next = 8'd0;
            end
            default: begin
                r_next = 8'd0;
                g_next = 8'd0;
                b_next = 8'd0;
            end
        endcase
    end // always_comb


    always_ff @(posedge clk) begin
        if (reset || x_vga < 80 || x_vga > 559) begin
            r <= 0;
            g <= 0;
            b <= 0;
        end
        else begin
            r <= r_next;
            g <= g_next;
            b <= b_next;
        end
    end // always_ff


endmodule