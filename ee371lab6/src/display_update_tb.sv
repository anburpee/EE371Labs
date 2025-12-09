// testbench for display_update.sv
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
        reset <= 1'b1;  repeat(3) @(posedge clk);
        reset <= 1'b0;            @(posedge clk);

        // first row
        for (j = 0; j < 640; j++) begin
            y_vga <= 0; 
            x_vga <= 10'(j);
            encoding <= 3'($urandom_range(0,5));
            @(posedge clk);
            @(posedge clk);
            $display("x = %d    y = %d    encoding = %d     R = %d     G = %d     B = %d", x_vga, y_vga, encoding, r, g, b);
        end

        // rgb values should change every cycle here
        for (i = 0; i < 480; i += 60) begin
            y_vga <= 9'(i); 
            for (j = 0; j < 640; j += 60) begin
                x_vga <= 10'(j);
                encoding <= 3'($urandom_range(0,5));
                @(posedge clk);
                @(posedge clk);
                $display("x = %d    y = %d    encoding = %d     R = %d     G = %d     B = %d", x_vga, y_vga, encoding, r, g, b);
            end
        end

        $stop;
    end // initial

endmodule // display_update_tb