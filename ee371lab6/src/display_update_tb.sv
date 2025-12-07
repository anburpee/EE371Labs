`timescale 1 ps / 1 ps
module display_update_tb ();

    logic clk;
    logic reset; // don't need?
    logic [9:0] x_vga;
    logic [8:0] y_vga;
    logic [2:0] encoding;
    // logic rom_reading; // for round tokens
    logic [5:0] read_addr;
    logic [7:0] r;
    logic [7:0] g;
    logic [7:0] b;

    display_update dut (.*);

    // simulation clock
    parameter period = 100;
    initial begin
        clk <= 0;
        forever #(period/2) clk <= ~clk;
    end

    // test the design
    int i, j;
    initial begin
        reset <= 1'b1;  @(posedge clk);
        reset <= 1'b0;  @(posedge clk);

        for (i = 0; i < 480; i++) begin
            y_vga <= 8'(i); 
            for (j = 0; j < 640; j++) begin
                x_vga <= 9'(i);
                repeat(2) @(posedge clk);
            end
        end

        $stop;
    end // initial

endmodule // display_update_tb