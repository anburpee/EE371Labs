`timescale 1 ps / 1 ps

module ram_update_ctrl (
    input  logic clk,
    input  logic reset, 
    input  logic [3:0] key,
    input  logic count_eq_11,
    input  logic valid_xy,
    input  logic legal_dir,
    input  logic edge_blocked0,
    input  logic own_adj,
    input  logic opp_adj,
    input  logic edge_blocked1,
    input  logic two_over,
    input  logic cont_turn,
    input  logic mult_iter,
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

    typedef enum logic [4:0] {
        s_reset, s_idle, s_check0, s_known0,
        s_update, s_check_done, s_known1,
        s_wait0, s_wait1
    } states;

    states ps, ns;

    // NEXT STATE
    always_comb begin
        ns = ps;
        case (ps)

            s_reset: ns = s_idle;

            s_idle: ns = (|key) ? s_check0 : s_idle;   // FIX

            s_check0: ns = s_known0;

            s_known0: ns = count_eq_11 ? s_update : s_check0;

            s_update:
                ns = (valid_xy && legal_dir && ~edge_blocked0 && ~own_adj) ?
                        (opp_adj ?
                            ((~edge_blocked1 && ~two_over) ? s_check_done : s_idle)
                          : (mult_iter ? s_idle : s_check_done))
                      : s_idle;

            s_check_done: ns = s_known1;

            s_known1:
                ns = cont_turn ? s_wait0 :
                     (count_eq_11 ? s_wait1 : s_check_done);

            s_wait0: ns = (|key) ? s_wait0 : s_idle;   // FIX

            s_wait1: ns = (|key) ? s_wait1 : s_reset;  // FIX

        endcase
    end

    // STATE REGISTER
    always_ff @(posedge clk) begin
        if (reset)
            ps <= s_reset;
        else
            ps <= ns;
    end

    // FIX: detect state entry for incr_count
    logic known0_prev, known1_prev;

    always_ff @(posedge clk) begin
        if (reset) begin
            known0_prev <= 1'b0;   // FIX
            known1_prev <= 1'b0;   // FIX
        end else begin
            known0_prev <= (ps == s_known0);   // FIX
            known1_prev <= (ps == s_known1);   // FIX
        end
    end

    // OUTPUT LOGIC
    assign load_iter  = (ps == s_reset);
    assign initialize = (ps == s_idle) && (|key);
    assign read       = (ps == s_check0) || (ps == s_check_done);
    assign check0     = (ps == s_known0);
    assign check_done = (ps == s_known1);

    // FIX: pulse incr_count only on state entry
    assign incr_count =
        ((ps == s_known0) && ~known0_prev && ~count_eq_11) ||
        ((ps == s_known1) && ~known1_prev && ~count_eq_11);  // FIX

    assign reset_count = (ps == s_update);

    assign invalid_xy  = (ps == s_update) && ~valid_xy;
    assign illegal_dir = (ps == s_update) && ~legal_dir;

    assign board_in_way =
        (ps == s_update) &&
        (edge_blocked0 || (opp_adj && edge_blocked1));

    assign token_in_way =
        (ps == s_update) &&
        (own_adj || (opp_adj && ~edge_blocked1 && two_over));

    assign load_adj =
        (ps == s_update) &&
        valid_xy && legal_dir &&
        ~edge_blocked0 && ~own_adj &&
        ~opp_adj && ~mult_iter;

    assign load_skip =
        (ps == s_update) &&
        valid_xy && legal_dir &&
        ~edge_blocked0 && ~own_adj &&
        opp_adj && ~edge_blocked1 &&
        two_over;

    assign mult_true = (ps == s_wait0) && (~|key);

    // FIX: correct done pulse
    assign done =
        (ps == s_wait1) &&
        count_eq_11 &&    // FIX
        ~cont_turn &&     // FIX
        (~|key);          // FIX

endmodule
