// datapath for ram_update module
// sends status signals to and recieves control signals from ram_update_ctrl.sv
module ram_update_datapath (input logic clk,
                            input logic reset, 
                            input logic [3:0] key,
                            input logic [5:0] sw,
                            input logic load_iter,
                            input logic initialize,
                            input logic read,
                            input logic check0,
                            input logic check_done,
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
                            output logic mult_iter
                        );

    logic reds_turn;
    logic [3:0] token_addr; // addr of the token to be moved on current player's turn
    logic [1:0] direction;
    logic [2:0] x_curr, y_curr;
    logic [2:0] x_new, y_new;
    logic [2:0] x_own, y_own, x_opp, y_opp;
    logic [2:0] x_cond0, y_cond0, x_cond1, y_cond1;
    logic opp_adj0, opp_adj1, opp_adj2, opp_adj3;
    logic two_over0, two_over1, two_over2, two_over3;
    logic [3:0] count;
    logic [3:0] red_addr, blk_addr; // red into rams
    logic [4:0] red_count, blk_count;

    // instantiate RAMS that store location of each token
    black_ram16x7 blk_ram (.address(blk_addr), .clock(clk), .data(data_blk), .wren(wren_blk), .q(q_blk));

    red_ram16x7 red_ram (.address(red_addr), .clock(clk), .data(data_red), .wren(wren_red), .q(q_red));


    // ctrl logic
    always_ff @(posedge clk) begin
        if (reset) begin
            reds_turn <= 1'b0;
        end
        if (load_iter) begin
            mult_iter <= 1'b0;
        end
        if (initialize) begin
            direction <= key[0] ? 2'b00 : (key[1] ? 2'b01 : (key[2] ? 2'b10 : 2'b11));
            count <= 1'b0;
            red_count <= 4'd12;
            blk_count <= 4'd12;
            if (mult_iter == 1'b0)
                x_curr <= sw[5:3];
                y_curr <= sw[2:0];
            cont_turn <= 1'b0;
        end
        if (read) begin
            red_addr <= count;
            blk_addr <= count;
            wren_blk <= 1'b0;
            wren_red <= 1'b0;
        end
        if (check0) begin
            x_own = reds_turn ? q_red[5:3] : q_blk [5:3];
            y_own = reds_turn ? q_red[2:0] : q_blk [2:0];
            x_opp = reds_turn ? q_blk[5:3] : q_red [5:3];
            y_opp = reds_turn ? q_blk[2:0] : q_red [2:0];
            if ((x_own == x_curr) && (y_own == y_curr)) begin
                valid_xy <= 1'b1;
                token_addr <= count;
                king <= reds_turn ? q_red[7] : q_blk[7];
            end
            case (direction)
                2'b00: x_cond0 = x_curr + 1;    y_cond0 = y_curr + 1;   x_cond1 = x_curr + 2;    y_cond1 = y_curr + 2;
                2'b01: x_cond0 = x_curr - 1;    y_cond0 = y_curr + 1;   x_cond1 = x_curr - 2;    y_cond1 = y_curr + 2;
                2'b10: x_cond0 = x_curr + 1;    y_cond0 = y_curr - 1;   x_cond1 = x_curr + 2;    y_cond1 = y_curr - 2;
                2'b11: x_cond0 = x_curr - 1;    y_cond0 = y_curr - 1;   x_cond1 = x_curr - 2;    y_cond1 = y_curr - 2;
            endcase
            if (x_own == x_cond0 && y_own == y_cond0) begin
                own_adj <= 1'b1;
            end
            if (x_opp == x_cond0 && y_opp == y_cond0) begin
                opp_adj <= 1'b1;
                opp_addr <= count;
            end
            if (x_own == x_cond1 && y_own == y_cond1 || x_opp == x_cond1 && y_opp == y_cond1) begin
                two_over <= 1'b1;
            end
        end
        if (check_done) begin
            x_own = reds_turn ? q_red[5:3] : q_blk [5:3];
            y_own = reds_turn ? q_red[2:0] : q_blk [2:0];
            x_opp = reds_turn ? q_blk[5:3] : q_red [5:3];
            y_opp = reds_turn ? q_blk[2:0] : q_red [2:0];

            if (x_opp == x_curr + 1 && y_opp == y_curr + 1) 
                opp_adj0 <= 1'b1;
            if (x_own == x_curr + 2 && y_own == y_curr + 2 || x_opp == x_curr - 2 && y_opp == y_curr + 2) 
                two_over0 <= 1'b1;
            if (x_opp == x_curr - 1 && y_own == y_curr + 1) 
                opp_adj1 <= 1'b1;
            if (x_own == x_curr - 2 && y_own == y_curr + 2 || x_opp == x_curr - 2 && y_opp == y_curr + 2) 
                two_over1 <= 1'b1;
            if (x_opp == x_curr + 1 && y_own == y_curr + 1) 
                opp_adj2 <= 1'b1;
            if (x_own == x_curr + 2 && y_own == y_curr - 2 || x_opp == x_curr + 2 && y_opp == y_curr - 2) 
                two_over2 <= 1'b1;
            if (x_opp == x_curr + 1 && y_own == y_curr + 1) 
                opp_adj3 <= 1'b1;
            if (x_own == x_curr - 2 && y_own == y_curr - 2 || x_opp == x_curr - 2 && y_opp == y_curr - 2) 
                two_over3 <= 1'b1;
        end
        if (incr_count) begin
            count <= count + 1;
        end
        if (reset_count) begin
            count <= 3'd0;
        end
        if (load_adj) begin
            case(direction)
                2'b00: x_new = x_curr + 1;   y_new = y_curr + 1;
                2'b01: x_new = x_curr - 1;   y_new = y_curr + 1;
                2'b10: x_new = x_curr + 1;   y_new = y_curr - 1;
                2'b11: x_new = x_curr - 1;   y_new = y_curr - 1;
            endcase
            case (reds_turn)
                1'b0: king_new = (y_new == 3'd7); 
                      wren_blk <= 1'b1;  
                      blk_addr <= token_addr;
                      data_blk <= {king_new, x_new, y_new};

                1'b1: king_new = (y_new == 3'd0);
                      wren_red <= 1'b1;
                      red_addr <= token_addr;
                      data_red <= {king_new, x_new, y_new};
            endcase
            king <= king_new;
        end
        if (load_skip) begin
            wren_blk <= 1'b1;
            wren_red <= 1'b1;
            case(direction)
                2'b00: x_new = x_curr + 2;   y_new = y_curr + 2;
                2'b01: x_new = x_curr - 2;   y_new = y_curr + 2;
                2'b10: x_new = x_curr + 2;   y_new = y_curr - 2;
                2'b11: x_new = x_curr - 2;   y_new = y_curr - 2;
            endcase
            case (reds_turn)
                1'b0: king_new = (y_new == 3'd7);
                      blk_addr <= token_addr;
                      data_blk <= {king_new, x_new, y_new};
                      red_addr <= opp_addr;
                      data_red <= {6{1'b0}, 1'b1}; // erase opponent's token
                      red_count <= red_count - 1;

                1'b1: king_new = (y_new == 3'd0);
                      red_addr <= token_addr;
                      data_red <= {king_new, x_new, y_new};
                      blk_addr <= opp_addr;
                      data_blk <= {6{1'b0}, 1'b1}; // erase opponent's token
                      blk_count <= blk_count - 1;
            endcase
            king <= king_new;
            x_curr <= x_new;
            y_curr <= y_new;
        end
        if (mult_true) begin
            mult_iter <= 1'b1;

        end
        if (done) begin
            reds_turn <= ~reds_turn;
        end
    end

    // status signals
    assign legal_dir = king ? 1'b1 : (reds_turn ? ((difrection / 2) ? 1'b1 : 1'b0) : ((direction / 2) ? 1'b0 : 1'b1));
    assign edge_blocked0 = ((direction  / 2) && (y_curr == 0)) || (~(direction / 2) && (y_curr == 7)) || 
                           ((direction  % 2) && (x_curr == 0)) || (~(direction % 2) && (x_curr == 7));
    assign edge_blocked1 = ((direction  / 2) && (y_curr == 1)) || (~(direction / 2) && (y_curr == 6)) || 
                           ((direction  % 2) && (x_curr == 1)) || (~(direction % 2) && (x_curr == 6));
    // king piece -> check all directions
    // otherwise:
    // red's turn -> check upward directions
    // black's turn -> check downward directions
    assign cont_turn = king_new ? 
                       ((opp_adj0 && ~two_over0) || (opp_adj1 && ~two_over1) || (opp_adj2 && ~two_over2) || (opp_adj3 && ~two_over3)) :
                       (reds_turn ? ((opp_adj2 && ~two_over2) || (opp_adj3 && ~two_over3)) : ((opp_adj0 && ~two_over0) || (opp_adj1 && ~two_over1)));


endmodule // ram_update_datapath