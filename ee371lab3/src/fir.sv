module fir #(parameter W=24, N=4) (clk, reset, rd, wr, data_in, data_out);

    input logic clk, reset, rd, wr;
    input logic [W-1:0] data_in;
    output logic [W-1:0] data_out;

    logic [W-1:0] divided;
    assign divided = {{$clog2(N){data_in[W-1]}}, data_in[W-1:$clog2(N)]};

    logic unused_empty, unused_full;

    fifo buffer #(.DATA_WIDTH(W), .ADDR_WIDTH($clog2(N)))
                    (.clk(clk), .reset(reset), .rd(rd), .wr(wr),
                     .empty(unused_empty), .full(unused_full), 
                     .w_data(divided), .r_data(fifo_out));
    
    logic [W-1:0] subtracted;
    assign subtracted = divided + (-fifo_out);

    logic [W-1:0] accum_out;

    // accumulator
    always_ff @(posedge clk) begin
        if (reset) begin
            accum_out <= '0;
        end
        else begin
            accum_out <= subtracted + accum_out;
        end
    end

endmodule