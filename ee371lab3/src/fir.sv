// FIR for task 3
// N = size of fifo buffer
// W = width of data_in, data_out
// leonard an an enable -- why??
// rd and wr signals should be connected to the read and write signals in top level?
// or both should be assigned to read_ready && write_ready (which is what the 
// read and write signals that go from the circuit to the codec are assigned to)
// probably shouldn't have a continuous assignment of 1'b1
// use enable instead of rd/wr since rd and wr should happen simultaneously and 
// you only need 1 signal
module fir #(parameter D_WIDTH=24, N=4) (clk, reset, enable, data_in, data_out);

    input logic clk, reset, enable;
    input logic [D_WIDTH-1:0] data_in;
    output logic [D_WIDTH-1:0] data_out;

    logic [D_WIDTH-1:0] divided;
    assign divided = {{$clog2(N){data_in[D_WIDTH-1]}}, data_in[D_WIDTH-1:$clog2(N)]};

    logic empty, full;
    logic [D_WIDTH-1:0] fifo_out;

    fifo #(.DATA_WIDTH(D_WIDTH), .ADDR_WIDTH($clog2(N))) buffer
                 (.clk(clk), .reset(reset), .rd(enable && full), .wr(enable), // only start reading once full
                  .empty(empty), .full(full), 
                  .w_data(divided), .r_data(fifo_out)); // you still have fifo_out even when you're not reading, so is it pointless to set the decault fifo values to 0?
    
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