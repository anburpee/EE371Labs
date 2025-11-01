module binary_seach (clk, reset, start, a, loc, done, found);

    input logic clk, reset, start;
    input logic [7:0] a;
    output logic [4:0] loc;
    output logic done, found;

    logic m_gt_a, initialize, move_up, move_down;

    binary_search_ctrl ctrl (.*);
    binary_search_reg datapath (.*);

endmodule // binary_search