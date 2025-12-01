// module for updating rams that store the token locations
// submodules ram_update_ctrl, ram_update_datapath
module ram_update (input logic clk, 
                   input logic reset,
                   input logic [3:0] keys,
                   input logic [5:0] sw,
                   output logic iter_done // use as a start signal for checking the rams for detecting the end of the game
                   );
    
    logic initialize, read, check0, check_done, incr_count, reset_count, load_adj, load_skip, mult_true, done; // control signals
    logic count_eq_11, cont_turn, mult_iter; // status signals
    logic valid_xy, legal_dir, edge_blocked0, own_adj, opp_adj, edge_blocked1, two_over; // checks (status)

    ram_update_ctrl ram_ctrl (.*);

    ram_update_datapath ram_datapath (.*);

    // output logic
    assign iter_done = done || mult_true;
endmodule
