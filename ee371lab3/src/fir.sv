// FIR filter for task 3 that filters audio by computing the average of the last N audio samples
// N = size of fifo buffer
// D_WIDTH = width of data_in, data_out (audio samples)
// 1 bit enable signal drives the fifo rd and wr signals simultaneously
// input data_in (width D_WIDTH, 24 bits for audio samples) comes from the unfiltered audio from the task3_top.sv
// output data_out (width D_WIDTH, 24 bits for audio samples) is the filtered_data in task3_top.sv
module fir #(parameter D_WIDTH=24, N=4) (clk, reset, enable, data_in, data_out);

    input logic clk, reset, enable;
    input logic [D_WIDTH-1:0] data_in;
    output logic [D_WIDTH-1:0] data_out;

    // divide data_in by N
    logic [D_WIDTH-1:0] divided;
    assign divided = {{$clog2(N){data_in[D_WIDTH-1]}}, data_in[D_WIDTH-1:$clog2(N)]};

    logic empty, full;
    logic [D_WIDTH-1:0] fifo_out;


    // data width is set to the width of data_in, the width of the audio samples
    // N is the number of addresses in the fifo buffer, so address width is log_2(N)
    // rd and wr is simultaneous, driven by enable
    fifo #(.DATA_WIDTH(D_WIDTH), .ADDR_WIDTH($clog2(N))) buffer
                 (.clk(clk), .reset(reset), .rd(enable), .wr(enable),
                  .empty(empty), .full(full), 
                  .w_data(divided), .r_data(fifo_out)); 

    // subtract oldest value from the fifo buffer(fifo_out) from the most recent 
    // input to the buffer so that the oldest value can be taken out from the accumulator value
    logic [D_WIDTH-1:0] subtracted;
    assign subtracted = divided + (-1 * fifo_out);

    // accumulator
    always_ff @(posedge clk) begin
        if (reset) begin
            data_out <= '0;
        end
        // enable must be high because fifo only outputs a value on enable
        // and you only want the register to update when there's a new
        // fifo_out value
        // enable condition synchronizes fifo buffer and accumulator
        else if (enable) begin  
            data_out <= subtracted + data_out;
        end
    end // always_ff

endmodule // fir

