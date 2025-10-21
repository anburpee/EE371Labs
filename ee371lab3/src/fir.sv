// FIR for task 3
// N = size of fifo buffer
// W = width of data_in, data_out
// leonard an an enable -- why??
// rd and wr signals should be connected to the read and write signals in top level?
// or both should be assigned to read_ready && write_ready (which is what the 
// read and write signals that go from the circuit to the codec are assigned to)
// probably shouldn't have a continuous assignment of 1'b1
module fir #(parameter D_WIDTH=24, N=4) (clk, reset, rd, wr, data_in, data_out);

    input logic clk, reset, rd, wr;
    input logic [D_WIDTH-1:0] data_in;
    output logic [D_WIDTH-1:0] data_out;

    logic [D_WIDTH-1:0] divided;
    assign divided = {{$clog2(N){data_in[D_WIDTH-1]}}, data_in[D_WIDTH-1:$clog2(N)]};

    logic unused_empty, unused_full;
    logic [D_WIDTH-1:0] fifo_out;

    fifo #(.DATA_WIDTH(D_WIDTH), .ADDR_WIDTH($clog2(N))) buffer
                 (.clk(clk), .reset(reset), .rd(rd), .wr(wr), 
                  .empty(unused_empty), .full(unused_full), 
                  .w_data(divided), .r_data(fifo_out));
    
    logic [D_WIDTH-1:0] subtracted;
    assign subtracted = divided + (-fifo_out);

    // accumulator
    always_ff @(posedge clk) begin
        if (reset) begin
            data_out <= '0;
        end
        // rd must be high because fifo only outputs a value on rd
        // and you only want the register to update when there's a new
        // fifo_out value
        // rd condition synchronizes fifo buffer and accumulator
        else if (rd) begin  
            data_out <= subtracted + data_out;
        end
    end // always_ff

endmodule // fir