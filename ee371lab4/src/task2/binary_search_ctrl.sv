module binary_search_ctrl (clk, reset, start, found, m_gt_a, initialize,
                           move_up, move_down, done);
    input logic clk, reset, start, found, m_gt_a;
    output logic initialize, move_up, move_down, done;

    enum {s_idle, s_search, s_done} ps, ns;

    // next state logic
    always_comb begin
        case (ps)
            s_idle: ns = start ? s_search : s_idle;

            s_search: ns = found : s_done : s_search;

            s_done: ns = s_done;
            
        endcase
    end // always_ff

    // state update logic
    always_ff @(posedge clk) begin
        if (reset) begin
            ps <= s_idle;
        end
        else begin
            ps <= ns;
        end
    end // always_ff

    // output logic
    assign initialize = ((ps == s_idle) && (start == 1'b0));
    assign move_up = ((ps == s_search) && (m_gt_a == 1'b0));
    assign move_down = ((ps == s_search) && (m_gt_a == 1'b1));
    assign done = (ps == s_done);

endmodule // binary_search_ctrl