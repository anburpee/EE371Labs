module bit_counter_tb ();
    logic clk, reset, s;
    logic [7:0] a_input;
    logic [3:0] result;
    logic done;

    // instantiate DUT
    bit_counter dut (.*);

    // set up clock
    parameter period = 100;
    initial begin
        clk <= 0;
        forever #(period/2) clk <= ~clk;
    end // initial clock

    // test the design
    initial begin
        reset <= 1'b1;                                        @(posedge clk);
        reset <= 1'b0; 
        
        // stays in s1
        s <= 1'b0;      a_input <= 8'b10101010;     repeat(3)  @(posedge clk);

        // loads A with a_input
        s <= 1'b1;                                  repeat(12) @(posedge clk);

        // back to s1
        s <= 1'b0;                                  repeat(2) @(posedge clk);

        $stop; //stop simultaion
    end // initial 

endmodule // bit_counter_tb