module registered_ram32x8 (clk, address, data_in, wren, data_out);
    input logic clk, wren;
    input logic [4:0] address;
    input logic [4:0] data_in;
    output logic [2:0] data_out;

    logic reg_wren;
    logic [4:0] reg_address;
    logic [4:0] reg_data_in;

    always_ff @(posedge clk) begin
        reg_wren <= wren;
        reg_address <= address;
        reg_data_in <= data_in;
    end // always_ff

    ram32x8 ram (.address(reg_address), .clock(clk), .data(reg_data_in),
                 .wren(reg_wren), .q(data_out));

endmodule // registered_ram32x8