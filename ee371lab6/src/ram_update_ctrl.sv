// // V3
// // control module for ram_update
// // recieves status signals and sends control signals to ram_update_datapath.sv
// `timescale 1 ps / 1 ps
// module ram_update_ctrl (input logic clk,
//                         input logic reset, 
//                         input logic [3:0] key,
//                         input logic count_eq_11,
//                         input logic valid_xy,
//                         input logic legal_dir,
//                         input logic edge_blocked0,
//                         input logic own_adj,
//                         input logic opp_adj,
//                         input logic edge_blocked1,
//                         input logic two_over,
//                         input logic cont_turn,
//                         input logic mult_iter,
//                         output logic load_iter,
//                         output logic initialize,
//                         output logic read,
//                         output logic check0,
//                         output logic check_done,
//                         output logic incr_count,
//                         output logic reset_count,
//                         output logic invalid_xy,
//                         output logic illegal_dir,
//                         output logic board_in_way,
//                         output logic token_in_way,
//                         output logic load_adj, 
//                         output logic load_skip,
//                         output logic mult_true,
//                         output logic done
//                         );

//     // states
//     // FIX: added explicit read/check pair states for BOTH scan and check-done paths
//     typedef enum logic [4:0] {
//         s_reset,
//         s_idle,
//         s_read0,      // FIX: present read address for scanning loop (cycle N)
//         s_check0,     // FIX: sample q_* and evaluate adjacency (cycle N+1)
//         s_known0,     // original known0 name preserved semantics (decision point)
//         s_update,
//         s_read1,      // FIX: present read address for post-capture checking (cycle N)
//         s_check_done, // FIX: sample q_* for post-capture (cycle N+1)
//         s_known1,
//         s_wait0,
//         s_wait1
//     } states;
//     states ps, ns;

//     // next state logic
//     always_comb begin
//         ns = ps;
//         case(ps)
//             s_reset: ns = s_idle;

//             // idle → start scanning when a key (any) is pressed
//             s_idle: ns = (|key) ? s_read0 : s_idle;      // FIX: use |key for any-key detection

//             // read0: present address = count to RAM for scanning loop (one full cycle)
//             s_read0: ns = s_check0;                      // FIX: guarantee 1 cycle read before check

//             // check0: sample q_* and set flags in datapath (this is the cycle datapath uses q_*).
//             s_check0: ns = s_known0;                     // next go to the "known0" decision state

//             // known0: make decision; if we've scanned all entries (count_eq_11) go to update
//             // otherwise go back to read0 to present next address
//             s_known0: ns = count_eq_11 ? s_update : s_read0;

//             // update: decide whether to perform move or skip or go idle
//             s_update: ns = (valid_xy && legal_dir && ~edge_blocked0 && ~own_adj) ? 
//                            (opp_adj ? ((~edge_blocked1 && ~two_over) ? s_read1 : s_idle)
//                                     : (mult_iter ? s_idle : s_read1)) : 
//                            s_idle;
//             // NOTE: In the original you went to s_check_done or s_idle; here we route through s_read1 so the datapath
//             //       receives a read cycle before check_done (FIX). This makes the timing explicit and consistent.

//             // read1: present address = count to RAM for the post-capture check (one full cycle)
//             s_read1: ns = s_check_done;                   // FIX: 1 cycle read before check_done

//             // check_done: datapath samples q_* (post-capture adjacency detection)
//             s_check_done: ns = s_known1;

//             // known1: after check_done, either continue multi-capture (cont_turn) -> wait0, or if scanned all tokens -> wait1,
//             // otherwise loop to read1 to continue scanning (this mirrors the original structure)
//             s_known1: ns = cont_turn ? s_wait0 : (count_eq_11 ? s_wait1 : s_read1);

//             // wait0/wait1 wait for the player to release the key (any key). Then transition accordingly.
//             s_wait0: ns = (|key) ? s_wait0 : s_idle;      // FIX: use |key
//             s_wait1: ns = (|key) ? s_wait1 : s_reset;     // FIX: use |key

//             default: ns = s_reset;
//         endcase
//     end

//     // state update logic
//     always_ff @(posedge clk) begin
//         if (reset)
//             ps <= s_reset;
//         else
//             ps <= ns;
//     end

//     // output logic (all combinational outputs derived from ps)
//     // FIX: outputs changed to match the new read/check state names and to guarantee the 2-cycle read-then-check timing.

//     assign load_iter    = (ps == s_reset);                // same as before
//     assign initialize   = (ps == s_idle) && (|key);       // start initialization when key pressed

//     // read is asserted in the explicit read states (one cycle each)
//     assign read         = (ps == s_read0) || (ps == s_read1);   // FIX: explicit read pulses

//     // check0/check_done asserted in the following cycle (when q_* will be valid)
//     assign check0       = (ps == s_check0);               // FIX: sample q_* after read0
//     assign check_done   = (ps == s_check_done);           // FIX: sample q_* after read1

//     // increment the count when we are in a known state and haven't scanned all entries
//     assign incr_count   = ((ps == s_known0) && ~count_eq_11) || 
//                           ((ps == s_known1) && ~count_eq_11);         // same semantics as original

//     // when entering update, reset_count asserted (same as before)
//     assign reset_count  = (ps == s_update);

//     // error/status outputs for invalid/illegal/blocked/token-in-way (same semantics)
//     assign invalid_xy   = (ps == s_update) && ~valid_xy;
//     assign illegal_dir  = (ps == s_update) && ~legal_dir;
//     assign board_in_way = (ps == s_update) && (edge_blocked0 || (opp_adj && edge_blocked1));
//     assign token_in_way = (ps == s_update) && (own_adj || (opp_adj && ~edge_blocked1 && two_over));

//     // load_adj and load_skip: these are asserted in s_update (same as original) — datapath will perform writes during that clock
//     assign load_adj     = (ps == s_update) && valid_xy && legal_dir &&
//                           ~edge_blocked0 && ~own_adj && ~opp_adj &&
//                           ~mult_iter;                      // same condition as original, but now timing around reads is explicit

//     assign load_skip    = (ps == s_update) && valid_xy && legal_dir &&
//                           ~edge_blocked0 && ~own_adj && opp_adj &&
//                           ~edge_blocked1 && two_over;      // same as original

//     // mult_true/done: wait states behavior preserved (use |key)
//     assign mult_true    = (ps == s_wait0) && (~|key);
//     assign done         = (ps == s_wait1) && (~|key);

// endmodule // ram_update_ctrl






// V2
// control module for ram_update
// recieves status signals and sends control signals to ram_update_datapath.sv
`timescale 1 ps / 1 ps


// control module for ram_update
// recieves status signals and sends control signals to ram_update_datapath.sv
`timescale 1 ps / 1 ps
module ram_update_ctrl (input logic clk,
                        input logic reset, 
                        input logic [3:0] key,
                        input logic count_eq_11,
                        input logic valid_xy,
                        input logic legal_dir,
                        input logic edge_blocked0,
                        input logic own_adj,
                        input logic opp_adj,
                        input logic edge_blocked1,
                        input logic two_over,
                        input logic cont_turn,
                        input logic mult_iter,
                        output logic load_iter,
                        output logic initialize,
                        output logic read,
                        output logic check0,
                        output logic check_done,
                        output logic incr_count,
                        output logic reset_count,
                        output logic invalid_xy,
                        output logic illegal_dir,
                        output logic board_in_way,
                        output logic token_in_way,
                        output logic load_adj, 
                        output logic load_skip,
                        output logic mult_true,
                        output logic done
                        );

    // states
    typedef enum logic [4:0] {s_reset, s_idle, s_check0, s_unknown00, s_unknown01, s_known0, s_update, 
                              s_check_done, s_unknown10, s_unknown11, s_known1, s_wait0, s_wait1} states;
    states ps, ns;

    // next state logic
    always_comb begin
        ns = ps;
        case(ps)
            s_reset: ns = s_idle;

            s_idle: ns = (|key) ? s_check0 : s_idle;      // FIX: key → |key

            s_check0: ns = s_unknown00;

            s_unknown00: ns = s_unknown01;

            s_unknown01: ns = s_known0;

            s_known0: ns = count_eq_11 ? s_update : s_check0;

            s_update: ns = (valid_xy && legal_dir && ~edge_blocked0 && ~own_adj) ? 
                           (opp_adj ? ((~edge_blocked1 && ~two_over) ? s_check_done : s_idle) :
                           (mult_iter ? s_idle : s_check_done)) : 
                           s_idle;

            s_check_done: ns = s_unknown10;

            s_unknown10: ns = s_unknown11;

            s_unknown11: ns = s_known1;

            s_known1: ns = count_eq_11 ? (cont_turn ? s_wait0 : s_wait1) : s_check_done; 
            // s_known1: ns = cont_turn ?  s_wait0 : (count_eq_11 ? s_wait1 : s_check_done);

            s_wait0: ns = (|key) ? s_wait0 : s_idle;      // FIX: key → |key

            s_wait1: ns = (|key) ? s_wait1 : s_reset;     // FIX: key → |key
        endcase
    end

    // state update logic
    always_ff @(posedge clk) begin
        if (reset)
            ps <= s_reset;
        else
            ps <= ns;
    end

    // output logic (FIXED: compare ps to states, and use |key)
    assign load_iter    = (ps == s_reset);                // FIX
    assign initialize   = (ps == s_idle) && (|key);       // FIX
    assign read         = (ps == s_check0) || (ps == s_check_done);   // FIX
    assign check0       = (ps == s_known0);               // FIX
    assign check_done   = (ps == s_known1);               // FIX
    assign incr_count   = ((ps == s_known0) && ~count_eq_11) || 
                          ((ps == s_known1) && ~count_eq_11);         // FIX
    assign reset_count  = (ps == s_update);               // FIX
    assign invalid_xy   = (ps == s_update) && ~valid_xy;  // FIX
    assign illegal_dir  = (ps == s_update) && ~legal_dir; // FIX
    assign board_in_way = (ps == s_update) && (edge_blocked0 || 
                         (opp_adj && edge_blocked1));     // FIX
    assign token_in_way = (ps == s_update) && (own_adj || 
                         (opp_adj && ~edge_blocked1 && two_over)); // FIX
    assign load_adj     = (ps == s_update) && valid_xy && legal_dir &&
                          ~edge_blocked0 && ~own_adj && ~opp_adj &&
                          ~mult_iter;                      // FIX
    assign load_skip    = (ps == s_update) && valid_xy && legal_dir &&
                          ~edge_blocked0 && ~own_adj && opp_adj &&
                          ~edge_blocked1 && ~two_over;      // FIX
    assign mult_true    = (ps == s_wait0) && (~|key);      // FIX
    assign done         = (ps == s_wait1) && (~|key);      // FIX

endmodule // ram_update_ctrl


// OG: WRONG
// module ram_update_ctrl (input logic clk,
//                         input logic reset, 
//                         input logic [3:0] key,
//                         input logic count_eq_11,
//                         input logic valid_xy,
//                         input logic legal_dir,
//                         input logic edge_blocked0,
//                         input logic own_adj,
//                         input logic opp_adj,
//                         input logic edge_blocked1,
//                         input logic two_over,
//                         input logic cont_turn,
//                         input logic mult_iter,
//                         output logic load_iter,
//                         output logic initialize,
//                         output logic read,
//                         output logic check0,
//                         output logic check_done,
//                         output logic incr_count,
//                         output logic reset_count,
//                         output logic invalid_xy,
//                         output logic illegal_dir,
//                         output logic board_in_way,
//                         output logic token_in_way,
//                         output logic load_adj, 
//                         output logic load_skip,
//                         output logic mult_true,
//                         output logic done
//                         );

//     // states
//     typedef enum logic [4:0] {s_reset, s_idle, s_check0, s_known0, s_update, s_check_done, s_known1, s_wait0, s_wait1} states;
//     states ps, ns;

//     // next state logic
//     always_comb begin
//         ns = ps;
//         case(ps)
//             s_reset: ns = s_idle;

//             s_idle: ns = key ? s_check0 : s_idle;

//             s_check0: ns = s_known0;

//             s_known0: ns = count_eq_11 ? s_update : s_check0;

//             s_update: ns = (valid_xy && legal_dir && ~edge_blocked0 && ~own_adj) ? 
//                            (opp_adj ? ((~edge_blocked1 && ~two_over) ? s_check_done : s_idle) : (mult_iter ? s_idle : s_check_done)) : 
//                            s_idle;

//             s_check_done: ns = s_known1;

//             s_known1: ns = cont_turn ?  s_wait0 : (count_eq_11 ? s_wait1 : s_check_done);

//             s_wait0: ns = key ? s_wait0 : s_idle;

//             s_wait1: ns = key ? s_wait1 : s_reset;
//         endcase
//     end

//     // state update logic
//     always_ff @(posedge clk) begin
//         if (reset)
//             ps <= s_reset;
//         else
//             ps <= ns;
//     end

//     // output logic
//     assign load_iter = s_reset;
//     assign initialize = s_idle && key;
//     assign read = s_check0 || s_check_done;
//     assign check0 = s_known0;
//     assign check_done = s_known1;
//     assign incr_count = (s_known0 && ~count_eq_11) || (s_known1 && ~count_eq_11);
//     assign reset_count = s_update;
//     assign invalid_xy = s_update && ~valid_xy;
//     assign illegal_dir = s_update && ~legal_dir;
//     assign board_in_way = s_update && (edge_blocked0 || (opp_adj && edge_blocked1));
//     assign token_in_way = s_update && (own_adj || (opp_adj && ~edge_blocked1 && two_over));
//     assign load_adj = s_update && valid_xy && legal_dir && ~edge_blocked0 && ~own_adj && ~opp_adj && ~mult_iter;
//     assign load_skip = s_update && valid_xy && legal_dir && ~edge_blocked0 && ~own_adj && opp_adj && ~edge_blocked1 && two_over;
//     assign mult_true = s_wait0 && ~key;
//     assign done = s_wait1 && ~key;


// endmodule // ram_update_ctrl