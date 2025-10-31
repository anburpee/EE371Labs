module task1_top_tb ();
    logic CLOCK_50;
    logic [9:0] SW;
    logic [3:0] KEY;
    logic [6:0] HEX0;
    logic [9:0] LEDR;

    // instantiate DUT
    task1_top dut (.*);

    // set up clock
    parameter period = 100;
    initial begin
        CLOCK_50 <= 0;
        forever #(period/2) CLOCK_50 <= ~CLOCK_50;
    end // initial clock

    // test the design
    initial begin
        KEY[0] <= 1'b0;                                             @(posedge CLOCK_50);
        KEY[0] <= 1'b1; 
        
        // stays in s1
        KEY[3] <= 1'b1;      SW[7:0] <= 8'b10101010;     repeat(3)  @(posedge CLOCK_50);

        // loads A with a_input
        KEY[3] <= 1'b0;                                  repeat(12) @(posedge CLOCK_50);

        // back to s1
        KEY[3] <= 1'b1;                                  repeat(5) @(posedge CLOCK_50);

        $stop; //stop simultaion
    end // initial 
endmodule // task1_top_tb