// this is a generalized counter module that cycles through 0 to 2**num_bits - 1
// counter increments every 50,000,000 clock cycles
// (if 50MHZ clk is passed in, count increments every second)
// takes in a parameter that specifies the bit-width of the number to count up to
// outputs the count, which is put in as the signal for the read address
// in the task3 module

module enabled_counter #(parameter num_bits = 1) (clk, reset, count);
    input logic clk, reset;
    output logic [num_bits-1:0] count;

    logic count_enable = 1'b0;
    logic [26:0] clk_cycles = 26'd0; // need 26 bits to make 50 million


    // logic for driving cout_enable
    always_ff @(posedge clk or posedge reset) begin // asynchronous reset
        if (reset) begin
            clk_cycles <= 26'b0;
        end // if
        else begin
            if (clk_cycles >= 50,000,000) begin 
                count_enable <= 1'b1;
                clk_cycles <= 26'b0;
            end
            else begin
                count_enable <= 1'b0;
                clk_cycles <= clk_cycles + 1;
            end 
        end // else
    end // always_ff


    // logic for incrementing the count
    always_ff @(posedge clk or posedge reset) begin // asynchronous reset
        if (reset)
            count <= '0;
        else if (count_enable) 
            count <= count + 1;
    end // always_ff

endmodule