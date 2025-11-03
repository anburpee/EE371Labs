// binary search module that takes an 8 bit value "a" and performs
// a binary search to find that value within an 32x8 RAM.
// 1 bit inputs clk, reset, and start from top level module
// outputs loc, the search address, done which indicates the end
// of the search, and found, indicating whether the target value was found
// uses binary_search_ctrl.sv and binary_search_reg as the control and 
// datapath modules
module binary_search (clk, reset, start, a, loc, done, found);

    input logic clk, reset, start;
    input logic [7:0] a;
    output logic [4:0] loc;
    output logic done, found;

    logic m_gt_a, not_found, idle, search, initialize, incr_addr, decr_addr;

    binary_search_ctrl ctrl (.*);
    binary_search_reg datapath (.*);

endmodule // binary_search