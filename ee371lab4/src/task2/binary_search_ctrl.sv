// control circuit for binary_search module
// takes 1 bit inputs clk, reset, start from binary_search.sv
// takes 1 bit status signals found, not_found, m_gt_a from binary_search_reg
// outputs idle and search as phase signals/output-valid qualifiers to feed
// into register file
// outputs initialize, incr_addr, decr_addr as control signals to register file
// outputs done to binary_search.sv as overall output
module binary_search_ctrl (clk, reset, start, found, not_found, m_gt_a, idle, search, initialize,
                           incr_addr, decr_addr, done);
    input logic clk, reset, start, found, not_found, m_gt_a;
    output logic idle, search, initialize, incr_addr, decr_addr, done;

    enum {s_idle, s_wait, s_search, s_done} ps, ns;

    // next state logic
    always_comb begin
        case (ps)
            s_idle: ns = start ? s_wait : s_idle;

            s_wait: ns = s_search;

            s_search: ns = (found || not_found) ? s_done : s_wait;

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


    // outputs

    // feed into reg file to indicate current state--to prevent false status outputs by the datapath
    assign idle = (ps == s_idle);
    assign search = (ps == s_search);

    // control signals
    assign initialize = ((ps == s_idle) && (start == 1'b1)); // && (~reset)
    assign incr_addr = ((ps == s_search) && (m_gt_a == 1'b0) && ((found || not_found) == 1'b0));
    assign decr_addr = ((ps == s_search) && (m_gt_a == 1'b1) && ((found || not_found) == 1'b0));

    // system output 
    assign done = ((ps == s_done));

endmodule // binary_search_ctrl