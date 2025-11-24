// draws checkers board and its pieces (referenced from token_RAMs)
// tile size = 60, left offset is 80

module vga_update();
    input logic clk;
    input logic [9:0] x; // all 10 switches accounted for
    input logic [8:0] y;
    input logic [5:0] selected_tile;
    output logic [7:0] r, g, b;

    // token RAM port b read access
    output logic [3:0] ran_addr_red; // address to read data from red RAM
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

    

endmodule