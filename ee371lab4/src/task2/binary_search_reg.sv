// Register file/datapath for binary_search module
// takes 1 bit input clk from and 8 bit input "a" from binary_search.sv as a target value
// to search for in the 32x8 ram instantiated in this module
// takes 1 bit signals idle, search from control module to prevent false status outputs
// 1 bit control signal inputs initialize, incr_addr, decr_addr from control module
// outputs status signals m_gt_a, found, and not_found to control module
// outputs loc (location of target value) to binary_search.sv as overall output to binary_search
module binary_search_reg (clk, idle, search, initialize, incr_addr, decr_addr, a, m_gt_a, loc, found, not_found);

    input logic clk, idle, search, initialize, incr_addr, decr_addr;
    input logic [7:0] a;
    output logic m_gt_a, found, not_found;
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


    // status signals
    assign found = ((data_out == a) && ~idle);
    assign m_gt_a = (data_out > a);
    assign not_found = (~found && (r_ptr == l_ptr) && (search)); // need to also chech that state machine is in
                                                                 // in search state because otherwise the RAM value
                                                                 // at the address we want to check is still unknown 
                                                                 // (in the wait state)


endmodule // binary_search_reg