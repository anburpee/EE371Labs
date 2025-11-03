module binary_search (clk, reset, start, a, loc, done, found);

    input logic clk, reset, start;
    input logic [7:0] a;
    output logic [4:0] loc;
    output logic done, found;

    logic m_gt_a, not_found, idle, search, initialize, incr_addr, decr_addr;

    binary_search_ctrl ctrl (.*);
    binary_search_reg datapath (.*);

endmodule // binary_search