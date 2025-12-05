// module for updating rams that store the token locations
// submodules ram_update_ctrl, ram_update_datapath
// CONNECT VALID_MOVE TO AN LED
`timescale 1 ps / 1 ps
module ram_update (input logic clk, 
                   input logic reset,
                   input logic [3:0] key,
                   input logic [5:0] sw,
                   output logic iter_done, // don't need?
                   output logic invalid_move,
                   output logic reds_turn,
                   output logic game_over,
                    ////////////////v3//////////////////
                    // even_iter & having 2 RAMs is to make sure RAMs are not written to by ram_update and read from display_update at the same time @ load_skip
                    output logic even_iter, // toggles every iteration
                    // should instead be write_in_progress that goes high @ load_skip, load_adj, and check_done
                    output logic [5:0] encodings_addr1_even, 
                    output logic [5:0] encodings_addr2_even, 
                    output logic [2:0] encodings_data1_even,
                    output logic [2:0] encodings_data2_even,
                    output logic encodings_wren1_even,
                    output logic encodings_wren2_even,
                    output logic [5:0] encodings_addr1_odd, 
                    output logic [5:0] encodings_addr2_odd, 
                    output logic [2:0] encodings_data1_odd,
                    output logic [2:0] encodings_data2_odd,
                    output logic encodings_wren1_odd,
                    output logic encodings_wren2_odd
                    ////////////////v3//////////////////
                   );
    
    logic load_iter, initialize, read, check0, check_done, incr_count, reset_count, load_adj, load_skip, mult_true, done; // control signals
    logic invalid_xy, illegal_dir, board_in_way, token_in_way; // outputs from ctrl
    logic count_eq_11, cont_turn, mult_iter; // status signals
    logic valid_xy, legal_dir, edge_blocked0, own_adj, opp_adj, edge_blocked1, two_over; // checks (status)

    ram_update_ctrl ram_ctrl (.*);

    ram_update_datapath ram_datapath (.*);
    // output logic
    assign iter_done = done || mult_true;
    assign invalid_move = invalid_xy || illegal_dir || board_in_way || token_in_way;
endmodule
