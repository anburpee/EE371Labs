// datapath for ram_update module
// sends status signals to and recieves control signals from ram_update_ctrl.sv
module ram_update_datapath (input logic clk,
                            input logic reset, 
                            input logic [3:0] key,
                            input logic [5:0] sw,
                            input logic load_iter,
                            input logic initialize,
                            input logic read,
                            input logic incr_count,
                            input logic reset_count,
                            input logic load_adj, 
                            input logic load_skip,
                            input logic mult_true,
                            input logic done
                            output logic count_eq_11,
                            output logic valid_xy,
                            output logic legal_dir,
                            output logic edge_blocked0,
                            output logic own_adj,
                            output logic opp_adj,
                            output logic edge_blocked1,
                            output logic two_over,
                            output logic cont_turn,
                            output logic mult_iter,
                        )

    logic reds_turn;
    logic [1:0] direction;
    logic [2:0] x_curr, y_curr;
    logic [2:0] x_new, y_new;
    logic [3:0] count;
    logic [3:0] red_addr, blk_addr;

    // instantiate RAMS that store location of each token
    black_ram16x7 blk_ram (.address(address_blk), .clock(clk), .data(data_blk), .wren(wren_blk), .q(q_blk));

    red_ram16x7 red_ram (.address(address_red), .clock(clk), .data(data_red), .wren(wren_red), .q(q_red));



    always_ff @(posedge clk) begin
        if (reset) begin
            reds_turn <= 1'b0;
        end
        if (load_iter) begin
            mult_iter <= 1'b0;
        end
        if (initialize) begin
            direction <= key[0] ? 2'b00 : (key[1] ? 2'b01 : (key2 ? 2'b10 : 11));
            count <= 1'b0;
            if (mult_iter == 1'b0)
                x_curr <= sw[5:3];
                y_curr <= sw[2:0];
        end
        if (read) begin
            red_addr <= count;
            blk_addr <= count;
        end
        if (incr_count) begin
            count <= count + 1;
        end
        if (reset_count) begin
            count <= 3'd0;
        end
        if (load_adj) begin
            wren = 1'b1;
            case(direction)
                2'b00: x_new = x_curr + 1;   y_new = y_curr + 1;
                2'b01: x_new = x_curr - 1;   y_new = y_curr + 1;
                2'b10: x_new = x_curr + 1;   y_new = y_curr - 1;
                2'b11: x_new = x_curr - 1;   y_new = y_curr - 1;
            endcase
            case (reds_turn)
                1'b0: king_new = (y_new == 3'd7);   
                      address_blk <= token_addr;
                      data_blk <= {king_new, x_new, y_new};

                1'b1: king_new = (y_new == 3'd0);   
                      address_red <= token_addr;
                      data_red <= {king_new, x_new, y_new};
            endcase
        end
        if (load_skip) begin
            wren <= 1'b1;
            case(direction)
                2'b00: x_new = x_curr + 2;   y_new = y_curr + 2;
                2'b01: x_new = x_curr - 2;   y_new = y_curr + 2;
                2'b10: x_new = x_curr + 2;   y_new = y_curr - 2;
                2'b11: x_new = x_curr - 2;   y_new = y_curr - 2;
            endcase
            case (reds_turn)
                1'b0: king_new = (y_new == 3'd7);
                      address_blk <= token_addr;
                      data_blk <= {king_new, x_new, y_new};
                      address_red <= opp_addr;
                      data_red <= {6{1'b0}, 1'b1}; // erase opponent's token

                1'b1: king_new = (y_new == 3'd0);
                      address_red <= token_addr;
                      data_red <= {king_new, x_new, y_new};
                      address_blk <= opp_addr;
                      data_blk <= {6{1'b0}, 1'b1}; // erase opponent's token
            endcase
            x_curr <= x_new;
            y_curr <= y_new;
        end
        if (mult_true) begin

        end
        if (done) begin
        end

    end

endmodule // ram_update_datapath