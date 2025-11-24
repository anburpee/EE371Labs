// draws checkers board and its pieces (referenced from token_RAMs)
// tile size = 60, left offset is 80

module vga_update(clk, x, y, selected_tile, r, g, b, 
                    ram_addr_red, ram_dout_red, ram_addr_black, ram_dout_black);
    input logic clk;
    input logic [9:0] x; // all 10 switches accounted for
    input logic [8:0] y;
    input logic [5:0] selected_tile;
    output logic [7:0] r, g, b;

    // token RAM port b read access
    output logic [3:0] ram_addr_red; // address to read data from red RAM
    input logic [6:0] ram_dout_red; // read data from red RAM

    output logic [3:0] ram_addr_black; // address to read data from black RAM
    input logic [6:0] ram_dout_black; // read data from black RAM

    //------------------- board placement ----------------------------
    localparam int TILE = 60;
    localparam int BOARD_LEFT = 80; // 80 pixel left offset
    localparam int BOARD_TOP = 0;
    localparam int BOARD_W = TILE * 8;
    localparam int BOARD_H = TILE * 8;

    // RGB colors for board tiles and tokens (this is from ChatGPT)

    // color palette (8-bit per channel)
    localparam logic [7:0] COLOR_WHITE_R = 8'd245;
    localparam logic [7:0] COLOR_WHITE_G = 8'd245;
    localparam logic [7:0] COLOR_WHITE_B = 8'd240;

    // soft brown for playable squares
    localparam logic [7:0] COLOR_BROWN_R = 8'd139;
    localparam logic [7:0] COLOR_BROWN_G = 8'd69;
    localparam logic [7:0] COLOR_BROWN_B = 8'd19;

    // token colors
    localparam logic [7:0] COLOR_RED_R   = 8'd220;
    localparam logic [7:0] COLOR_RED_G   = 8'd20;
    localparam logic [7:0] COLOR_RED_B   = 8'd60;

    localparam logic [7:0] COLOR_BLACK_R = 8'd20;
    localparam logic [7:0] COLOR_BLACK_G = 8'd20;
    localparam logic [7:0] COLOR_BLACK_B = 8'd20;

    // highlight color (selected tile border)
    localparam logic [7:0] COLOR_HL_R = 8'd255;
    localparam logic [7:0] COLOR_HL_G = 8'd255;
    localparam logic [7:0] COLOR_HL_B = 8'd0;

    // sentinel: essentially an empty spot of the board
    // that we use as a reference point for the rest of the board
    localparam logic [6:0] EMPTY_SENTINEL = 7'b1111111;

    // tile positions on coordinate plane
    logic inside_board; // is the switch combo inside the board?
    logic [2:0] tile_x, tile_y;
    logic [9:0] x_pixel, y_pixel; // pixels within the tile (x and y coord.)

    always_comb begin
        if (
            (x >= BOARD_LEFT) &&
            (x < BOARD_LEFT + BOARD_W) &&
            (y >= BOARD_TOP) &&
            (y < BOARD_TOP + BOARD_H)
            ) begin
                inside_board = 1;
                tile_x = (x - BOARD_LEFT) / TILE;
                tile_y = (y - BOARD_TOP) / TILE;
                x_pixel = (x - BOARD_LEFT) % TILE;
                y_pixel = (y - BOARD_TOP) % TILE;
        end else begin
            inside_board = 0;
            tile_x = 3'd0;
            tile_y = 3'd0;
            x_pixel = 0;
            y_pixel = 0;
        end
    end

    // board color based on parity check
    logic is_brown = ((tile_x + tile_y) & 3'd1) == 1; // check LSB of sum (all odd tiles are brown)

    // use two counters to iterate through RAM
    logic [3:0] scan_counter;
    always_ff @(posedge clk) begin
        scan_counter <= scan_counter + 1'b1;
    end
    assign ram_addr_red = scan_counter;
    assign ram_addr_black = scan_counter;

    // local arrays to hold token positions
    logic [6:0] red_data [0:15];
    logic [6:0] black_data [0:15];

    always_ff @(posedge clk) begin
        red_data[scan_counter] <= ram_dout_red;
        black_data[scan_counter] <= ram_dout_black;
    end

    // check tokens for current tile
    integer i;
    logic red_here, black_here;
    logic [3:0] red_index, black_index;

    always_comb begin
        red_here = 1'b0;
        black_here = 1'b0;
        red_index = 4'd0;
        black_index = 4'd0;
        for (i=0; i<16; i=i+1) begin
            // decode position
            if (red_data[i] != EMPTY_SENTINEL) begin
                logic [5:0] pos_a = red_data[i][5:0];
                logic [2:0] pos_r_x = pos_a % 8;
                logic [2:0] pos_r_y = pos_a / 8;
                if (inside_board && (pos_r_x == tile_x) && (pos_r_y == tile_y)) begin
                    red_here = 1'b1;
                    red_index = i[3:0];
                end
            end
            if (black_data[i] != EMPTY_SENTINEL) begin
                logic [5:0] pos_b = black_data[i][5:0];
                logic [2:0] pos_b_x = pos_b % 8;
                logic [2:0] pos_b_y = pos_b / 8;
                if (inside_board && (pos_b_x == tile_x) && (pos_b_y == tile_y)) begin
                    black_here = 1'b1;
                    black_index = i[3:0];
                end
            end
        end
    end

    // drawing pixel: draw base tile color, and if token present, draw circle
    localparam int RAD = 21;
    logic signed [9:0] dx, dy;
    logic circle_mask;

    always_comb begin
        // default tile color
        if (!inside_board) begin
            // black background since we are not in the board
            r = 8'd0;
            g = 8'd0;
            b = 8'd0;
        end else begin
            if (is_brown) begin
                r = COLOR_BROWN_R;
                g = COLOR_BROWN_G;
                b = COLOR_BROWN_B;
            end else begin
                r = COLOR_WHITE_R;
                g = COLOR_WHITE_G;
                b = COLOR_WHITE_B;
            end

            // circle bit mask for tokens (typecast to signed)
            dx = $signed(x_pixel) - $signed(TILE >> 1);
            dy = $signed(y_pixel) - $signed(TILE >> 1);
            circle_mask = (dx*dx + dy*dy) < (RAD * RAD);
        end

        // draw black/red token if needed (only on brown tile)
        if (red_here && circle_mask) begin
            r = COLOR_RED_R;
            g = COLOR_RED_G;
            b = COLOR_RED_B;
        end
        else if (black_here && circle_mask) begin
            r = COLOR_BLACK_R;
            g = COLOR_BLACK_G;
            b = COLOR_BLACK_B;
        end

        // draw border around selected tile
        if (inside_board) begin
            logic [5:0] this_tile = {tile_y, tile_x};
            if (this_tile == selected_tile) begin
                if (x_pixel < 3 || x_pixel >= TILE-3 || y_pixel < 3 || y_pixel >= TILE-3) begin
                    r = COLOR_HL_R;
                    g = COLOR_HL_G;
                    b = COLOR_HL_B;
                end
            end
        end
    end
endmodule