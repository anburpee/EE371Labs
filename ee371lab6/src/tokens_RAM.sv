// instantiate this module twice, once for red tokens and once for black
// dual-port 16x7 RAM to store positions (and KING bit) of all 12 tokens per color
// 4 empty addr spaces as buffer
// data[6] is KING bit, data[5:0] is position bits

module tokens_RAM #(parameter ADDR_W = 4, DATA_W = 7) ();
    input logic clk;

    // port a: CPU read/write
    input logic wren_a;
    input logic [ADDR_W-1:0] addr_a;
    input logic [DATA_W-1:0] din_a;
    output logic [DATA_W-1:0] dout_a;

    // port b: VGA reader (read-only)
    input logic [ADDR_W-1:0] addr_b;
    output logic [DATA_W-1:0] dout_b;

    localparam integer DEPTH = (1 << ADDR_W); // localparam = private variable, written in CAPS
    logic [DATA_W-1:0] mem [0:DEPTH-1];

    // synchronous read/write for port a
    always_ff @(posedge clk) begin
        if (wren_a) begin
            mem[addr_a] <= din_a;
        end
        dout_a <= mem[addr_a]; // latch behavior ok in always_ff
    end

    // synchronous read for port b
    always_ff @(posedge clk) begin
        dout_b <= mem[addr_b];
    end
endmodule