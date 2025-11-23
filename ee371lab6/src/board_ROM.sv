// ROM defines 8x8 checkers board with brown and white alternating tiles
// brown tiles can have tokens on them, white tiles stay empty always
// TILE SIZE = 60 PIXELS

module board_ROM (tile_x, tile_y, is_brown);
    input logic [2:0] tile_x, tile_y;
    output logic is_brown; // whether the tile is playable

    assign is_brown = (tile_x + tile_y) % 2 == 1;
endmodule