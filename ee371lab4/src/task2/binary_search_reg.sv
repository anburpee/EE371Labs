module binary_search_reg (clk, idle, initialize, incr_addr, decr_addr, a, m_gt_a, loc, found);

    input logic clk, idle, initialize, incr_addr, decr_addr;
    input logic [7:0] a;
    output logic m_gt_a, found;
    output logic [4:0] loc; // 5 bits for 32 addresses

    logic [4:0] r_ptr, l_ptr;



    always_ff @(posedge clk) begin
        if (initialize) begin
            l_ptr <= 5'd0;
            r_ptr <= 5'd31;
            loc <= 5'd15; // middle address
        end
        if (incr_addr) begin
            l_ptr <= loc + 1;
            loc <= (r_ptr + (loc + 1)) >> 1;
        end
        if (decr_addr) begin
            r_ptr <= loc - 1;
            loc <= ((loc - 1) + l_ptr) >> 1;
        end
    end // always_ff

    // instantiate RAM
    logic [7:0] data_out;
    ram32x8 ram (.address(loc), .clock(clk), .data(8'd255),
                 .wren(1'b0), .q(data_out));


    assign found = ((data_out == a) && ~idle);
    assign m_gt_a = (data_out > a);


endmodule // binary_search_reg