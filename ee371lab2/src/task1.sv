//comments
module task1 (clk, reset, address, data_in, wren, data_out);
    input logic clk, reset, address, wren;
    input logic [2:0] data_in;
    output logic [2:0] data_out;

    ram32x3 ram (.address(address), .clock(clk), .data(data_in),
                 .wren(wren), .q(data_out));

endmodule // task1


//module task1_testbech();
//    
//
//
//endmodule // task1_testbench