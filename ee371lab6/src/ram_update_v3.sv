// Module for in charge of game logic for checkers  and updating rams that store the token locations & encodings
// Submodules ram_update_ctrl, ram_update_datapath
// Inputs:
//      1-bit clk, reset from DE1_SoC
//      4-bit key from DE1_SoC
//      6-bit sw from DE1_SoC
// Outputs:
//      1-bit invalid_move, reds_turn, game_over, even_iter signals to DE1_SoC
//      6-bit encodings_addr1_even, encodings_addr2_even, encodings_addr1_odd, encodings_addr2_odd,
//      connected to the odd/even 64x3 RAMs in DE1_SoC respectively
//      3-bit encodings_data1_even, encodings_data2_even, encodings_data1_odd, encodings_data2_odd,
//      connected to the odd/even 64x3 RAMs in DE1_SoC respectively
`timescale 1 ps / 1 ps
module ram_update_v3 (input logic clk, 
                   input logic reset,
                   input logic [3:0] key,
                   input logic [5:0] sw,
                   output logic invalid_move,
                   output logic reds_turn,
                   output logic game_over,
                    ////////////////v3//////////////////
                    output logic even_iter,
                    output logic [5:0] encodings_addr1_even, 
                    output logic [5:0] encodings_addr2_even, 
                    output logic [2:0] encodings_data1_even,
                    output logic [2:0] encodings_data2_even,
                    output logic [5:0] encodings_addr1_odd, 
                    output logic [5:0] encodings_addr2_odd, 
                    output logic [2:0] encodings_data1_odd,
                    output logic [2:0] encodings_data2_odd
                   );
    
    logic load_iter, initialize, read, check0, check_done, incr_count, reset_count, load_adj, load_skip, mult_true, done; // control signals
    logic invalid_xy, illegal_dir, board_in_way, token_in_way; // outputs from ctrl
    logic count_eq_11, cont_turn, mult_iter; // status signals
    logic valid_xy, legal_dir, edge_blocked0, own_adj, opp_adj, edge_blocked1, two_over; // checks (status)

    ram_update_ctrl_v3 ram_ctrl (.*);

    ram_update_datapath_v3 ram_datapath (.*);

    // output logic
    assign invalid_move = invalid_xy || illegal_dir || board_in_way || token_in_way;
endmodule // ram_update_v3
