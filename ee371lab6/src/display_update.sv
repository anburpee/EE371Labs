// determines input RGB values for video_driver.sv based on the (x, y) coordinates that video_driver.sv outputs
// start with basic functionality of displaying the current player locations
// if there's extra time, add in selection highlights around the square that is selected by the switches
// must output the correct rgb values within 2 cycles after the target x, y is outputted from video_driver.
// 480 x 480 board displayed in the center of the 480 x 640 pixel VGA display
module display_update (input logic clk,
                       input logic reset,
                       input logic [9:0] x_vga,
                       input logic [8:0] y_vga,
                       input logic [6:0] ram_reading,
                       input logic [2:0] x_sel, // SW[5:3]  -- for highlight box
                       input logic [2:0] y_sel, // SW[2:0]  -- for highlight box
                       output logic [7:0] r,
                       output logic [7:0] g,
                       output logic [7:0] b
                       );

    // determine:
    // light square vs dark square (even vs odd, % 2 then scale)
    // if there's a piece in that square and whether its red or black -- and if it's a king
    // whether the square is selected by the switches (highlighted)
    // 

    logic light_square, dark_square;
    logic red_normal, black_normal;
    logic red_king, black_king;
    logic [5:0] x_counter, y_counter; // to count up to 60 (side lenth of each square on the board)

    always_ff @(posedge clk) begin
        if (x_vga < 80 || x_vga > 559) begin
            r <= 0;
            g <= 0;
            b <= 0;
        end
    end
    
    //  WHEN YOU READ FROM THE 64X3 RAMS, MAKE SURE TO SET WREN = 0


endmodule