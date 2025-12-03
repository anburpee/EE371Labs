// module for updating rams that store the token locations
// submodules ram_update_ctrl, ram_update_datapath
// CONNECT VALID_MOVE TO AN LED
`timescale 1 ps / 1 ps
module ram_update (input logic clk, 
                   input logic reset,
                   input logic [3:0] keys,
                   input logic [5:0] sw,
                   output logic iter_done, // don't need?
                   output logic invalid_move
                   );
    
    logic initialize, read, check0, check_done, incr_count, reset_count, load_adj, load_skip, mult_true, done; // control signals
    logic invalid_xy, illegal_dir, board_in_way, token_in_way; // outputs from ctrl
    logic count_eq_11, cont_turn, mult_iter; // status signals
    logic valid_xy, legal_dir, edge_blocked0, own_adj, opp_adj, edge_blocked1, two_over; // checks (status)

    ram_update_ctrl ram_ctrl (.*);

    ram_update_datapath ram_datapath (.*);
    // output logic
    assign iter_done = done || mult_true;
    assign invalid_move = invalid_xy || illegal_dir || board_in_way || token_in_way;
endmodule
