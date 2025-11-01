module binary_search_reg (clk, initialize, move_up, move_down, a, m_gt_a, loc, found);

    input logic initialize, move_up, move_down;
    input logic [7:0] a;
    output logic m_gt_a, found;
    output logic [4:0] loc; // 5 bits for 32 addresses

    logic [4:0] r_ptr, l_ptr;


    always_comb begin           // should this be always ff??
        if (initialize) begin
            l_ptr = 5'd0;
            r_ptr = 5'd31;
            loc = 5'd16; // middle address
        end
        if (move_up) begin
            l_ptr = loc + 1;
            loc = (r_ptr + l_ptr) << 1;
        end
        if (move_down) begin
            r_ptr = loc - 1;
            loc = (r_ptr + l_ptr) >> 1;
        end
    end // always_comb

    // instantiate RAM
    logic data_out
    registered_ram32x8 ram32x8 (.clk(clk), .address(loc), .data_in(8'd255), .wren(1'd0), .data_out(data_out));

    assign found = (data_out == a);
    assign m_gt_a = (data_out > a);


endmodule // binary_search_reg