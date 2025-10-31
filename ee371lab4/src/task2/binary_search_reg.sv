module binary_search_reg #(parameter DATA_WIDTH=8, DATA_DEPTH=32)
                          (initialize, move_up, move_down, a, m_gt_a, loc, found);
    input logic initialize, move_up, move_down;
    input logic [$clog2(DATA_WIDTH):0] a;
    output logic m_gt_a, found;
    output logic [$clog2(DATA_DEPTH)-1:0] loc; // 5 bits for 32 addresses


    // instantiate ROM


    logic [$clog2(DATA_DEPTH)-1:0] r_ptr, l_ptr;


    always_ff @(posedge clk) begin // or always_comb???
        if (initialize) begin
            l_ptr <= 0;
            r_ptr <= DATA_DEPTH - 1;
            loc <= DATA_DEPTH / 2;
        end
        if (move_up) begin
            l_ptr <= loc + 1;
            loc <= (r_ptr + l_ptr) / 2
        end
        if (move_down) begin
            r_ptr <= loc - 1;
            loc <= (r_ptr + l_ptr) / 2
        end
    end // always_ff


    assign found = (rom_chip[loc] == a)
    assign m_gt_a = (loc > a);


endmodule // binary_search_reg