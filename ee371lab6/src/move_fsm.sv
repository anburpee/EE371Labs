// move logic with switches
module move_fsm (clk, reset, sel_sw, key, red_dout_a, red_addr_a, red_din_a,
                    red_wren_a, black_dout_a, black_addr_a, black_din_a, black_wren_a);
    input logic clk, reset;
    input logic [5:0] sel_sw;
    input logic [3:0] key;

    // red RAM port a interface
    input logic [6:0] red_dout_a;
    output logic [3:0] red_addr_a;
    output logic [6:0] red_din_a;
    output logic red_wren_a;

    // black RAM port a interface
    input logic [6:0] black_dout_a;
    output logic [3:0] black_addr_a;
    output logic [6:0] black_din_a;
    output logic black_wren_a;

    // empty sentinel
    localparam logic [6:0] EMPTY_SENTINEL = 7'b1111111;

    // scanning counter to scan red and black RAM into local arrays
    logic [3:0] scan_counter;
    always_ff @(posedge clk) begin
        scan_counter <= scan_counter + 1'b1;
    end

    assign red_addr_a = scan_counter;
    assign black_addr_a = scan_counter;

    // read data -> local arrays
    logic [6:0] red_mem [0:15];
    logic [6:0] black_mem [0:15];

    always_ff @(posedge clk) begin
        red_mem[scan_counter] <= red_dout_a;
        black_mem[scan_counter] <= black_dout_a;
    end

    // edge detection for keys
    logic [3:0] key_last;
    always_ff @(posedge clk) begin
        key_last <= key;
    end
    logic [3:0] key_falling = key_last & ~key; // 1 when pressed (falling edge)

    function logic [2:0] pos_x(input logic [5:0] p);
        pos_x = p % 8;
    endfunction
    function logic [2:0] pos_y(input logic [5:0] p);
        pos_y = p / 8;
    endfunction

    // on key press (falling edge), attempt move (check validity first)
    logic signed [2:0] dx [0:3];
    logic signed [2:0] dy [0:3];

    initial begin
        dx[0] =  1; dy[0] =  1;
        dx[1] = -1; dy[1] =  1;
        dx[2] =  1; dy[2] = -1;
        dx[3] = -1; dy[3] = -1;
    end

    always_comb begin
        red_wren_a = 1'b0;
        black_wren_a = 1'b0;
        red_din_a = EMPTY_SENTINEL;
        black_din_a = EMPTY_SENTINEL;
    end


endmodule