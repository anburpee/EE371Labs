// datapath for ram_update module
// sends status signals to and recieves control signals from ram_update_ctrl.sv
`timescale 1 ps / 1 ps
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
                            input logic done,
                            output logic count_eq_11,
                            output logic valid_xy,
                            output logic legal_dir,
                            output logic edge_blocked0,
                            output logic own_adj,
                            output logic opp_adj,
                            output logic edge_blocked1,
                            output logic two_over,  // checks if there is a token two spaces over in the specified direction
                            output logic cont_turn,
                            output logic mult_iter,
                            ////////////////v3//////////////////
                            // even_iter & having 2 RAMs is to make sure RAMs are not written to by ram_update and read from display_update at the same time @ load_skip
                            output logic even_iter, // toggles every iteration
                            // should instead be write_in_progress that goes high @ load_skip, load_adj, and check_done
                            output logic [5:0] encodings_addr1_even, 
                            output logic [5:0] encodings_addr2_even, 
                            output logic [2:0] encodings_data1_even,
                            output logic [2:0] encodings_data2_even,
                            output logic encodings_wren1_even,
                            output logic encodings_wren2_even,
                            output logic [5:0] encodings_addr1_odd, 
                            output logic [5:0] encodings_addr2_odd, 
                            output logic [2:0] encodings_data1_odd,
                            output logic [2:0] encodings_data2_odd,
                            output logic encodings_wren1_odd,
                            output logic encodings_wren2_odd
                            ////////////////v3//////////////////
                            );

    logic reds_turn;
    logic wren_red, wren_blk;
    logic [6:0] q_red, q_blk;
    logic [6:0] data_red, data_blk;
    logic [3:0] token_addr; // addr of the token to be moved on current player's turn
    logic [3:0] opp_addr;
    logic [1:0] direction;
    logic king;
    logic [2:0] x_curr, y_curr;
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
            even_iter <= 1'b1; //////////////////////////v3
            red_count <= 4'd12;
            blk_count <= 4'd12;
        end
        if (load_iter) begin
            mult_iter <= 1'b0;
        end
        if (initialize) begin
            direction <= key[0] ? 2'b00 : (key[1] ? 2'b01 : (key[2] ? 2'b10 : 2'b11));
            count <= 1'b0;
            valid_xy <= 1'b0;
            own_adj <= 1'b0;
            opp_adj <= 1'b0;
            token_addr <= 1'b0;
            two_over <= 1'b0;
            king <= 1'b0;
            if (mult_iter == 1'b0) begin
                x_curr <= sw[5:3]; // only update when mult_iter == 0 b/c x_curr is set the new value at load_skip (when there's a possibility of another turn)
                y_curr <= sw[2:0]; // only update when mult_iter == 0 b/c y_curr is set the new value at load_skip
                two_over0 <= 1'b0; // take out of conditional?
                two_over1 <= 1'b0;
                two_over2 <= 1'b0;
                two_over3 <= 1'b0;
                opp_adj0 <= 1'b0;
                opp_adj1 <= 1'b0;
                opp_adj2 <= 1'b0;
                opp_adj3 <= 1'b0;
            end
        end
        if (read) begin
            red_addr <= count;
            blk_addr <= count;
            wren_blk <= 1'b0;
            wren_red <= 1'b0;
        end
        if (check0) begin
            logic [2:0] x_own, y_own, x_opp, y_opp;
            logic [2:0] x_cond0, y_cond0, x_cond1, y_cond1;
            x_own = reds_turn ? q_red[5:3] : q_blk [5:3];
            y_own = reds_turn ? q_red[2:0] : q_blk [2:0];
            x_opp = reds_turn ? q_blk[5:3] : q_red [5:3];
            y_opp = reds_turn ? q_blk[2:0] : q_red [2:0];
            if ((x_own == x_curr) && (y_own == y_curr) && !({x_own, y_own} == 7'b0000001)) begin
                valid_xy <= 1'b1;
                token_addr <= count;
                king <= reds_turn ? q_red[6] : q_blk[6];
            end
            case (direction)
                2'b00: begin
                    x_cond0 = x_curr + 1;    y_cond0 = y_curr + 1;   x_cond1 = x_curr + 2;    y_cond1 = y_curr + 2;
                end
                2'b01: begin
                    x_cond0 = x_curr - 1;    y_cond0 = y_curr + 1;   x_cond1 = x_curr - 2;    y_cond1 = y_curr + 2;
                end
                2'b10: begin
                    x_cond0 = x_curr + 1;    y_cond0 = y_curr - 1;   x_cond1 = x_curr + 2;    y_cond1 = y_curr - 2;
                end
                2'b11: begin
                    x_cond0 = x_curr - 1;    y_cond0 = y_curr - 1;   x_cond1 = x_curr - 2;    y_cond1 = y_curr - 2;
                end
            endcase
            if (x_own == x_cond0 && y_own == y_cond0) begin
                own_adj <= 1'b1;
            end
            if (x_opp == x_cond0 && y_opp == y_cond0) begin
                opp_adj <= 1'b1;
                opp_addr <= count;
            end
            if (((x_own == x_cond1) && (y_own == y_cond1)) || ((x_opp == x_cond1) && (y_opp == y_cond1))) begin
                two_over <= 1'b1;
            end
        end
        if (check_done) begin   // new values from load_adj/load_skip are now in blk_ram, red_ram
            logic [2:0] x_own, y_own, x_opp, y_opp;
            // fine even if q_red, q_blk stores an invalid location(after being skipped over & "erased") because
            // opp_adjx will always be false
            x_own = reds_turn ? q_red[5:3] : q_blk[5:3];
            y_own = reds_turn ? q_red[2:0] : q_blk[2:0];
            x_opp = reds_turn ? q_blk[5:3] : q_red[5:3];
            y_opp = reds_turn ? q_blk[2:0] : q_red[2:0];

            if ((x_opp == x_curr + 1) && (y_opp == y_curr + 1)) 
                opp_adj0 <= 1'b1;
            if (((x_own == x_curr + 2) && (y_own == y_curr + 2)) || ((x_opp == x_curr - 2) && (y_opp == y_curr + 2)))
                two_over0 <= 1'b1;
            if ((x_opp == x_curr - 1) && (y_opp == y_curr + 1)) 
                opp_adj1 <= 1'b1;
            if (((x_own == x_curr - 2) && (y_own == y_curr + 2)) || ((x_opp == x_curr - 2) && (y_opp == y_curr + 2)))
                two_over1 <= 1'b1;
            if ((x_opp == x_curr + 1) && (y_opp == y_curr - 1)) 
                opp_adj2 <= 1'b1;
            if (((x_own == x_curr + 2) && (y_own == y_curr - 2)) || ((x_opp == x_curr + 2) && (y_opp == y_curr - 2)))
                two_over2 <= 1'b1;
            if ((x_opp == x_curr - 1) && (y_opp == y_curr - 1)) 
                opp_adj3 <= 1'b1;
            if (((x_own == x_curr - 2) && (y_own == y_curr - 2)) || ((x_opp == x_curr - 2) && (y_opp == y_curr - 2)))
                two_over3 <= 1'b1;
            ////////////////////v3 -- update spot_encodings64x3 RAMs////////////////////////
            // output logic [5:0] encodings_addr1_even, 
            // output logic [5:0] encodings_addr2_even, 
            // output logic [2:0] encodings_data1_even,
            // output logic [2:0] encodings_data2_even,
            // output logic encodings_wren1_even,
            // output logic encodings_wren2_even,
            // output logic [5:0] encodings_addr1_odd, 
            // output logic [5:0] encodings_addr2_odd, 
            // output logic [2:0] encodings_data1_odd,
            // output logic [2:0] encodings_data2_odd,
            // output logic encodings_wren1_odd,
            // output logic encodings_wren2_odd,
            case (even_iter) // do all 12 iterations(b/c we don't know everything that changed -- yes, we know to draw a new spot at x_curr, y_curr but we don't have the coordinates of tokens jumped over to write in 0s to) 
                //------------ this is after the previous spot is erased in load_skip/load_adj
                // wren should be turned off after this current state ????
                1'b0: begin // update odd iteration RAM
                    // encodings_wren1_odd <= 1'b1; //  CONTROL ALL WREN LOGIC FROM DE1_SOC BASED ON EVEN_ITER -- should be fine since even if q_red and q_blk are updated, these registers don't update until the next check_done
                    // encodings_wren2_odd <= 1'b1;
                    encodings_addr1_odd <= 8*(q_red[5:3]) + q_red[2:0]; // red
                    encodings_data1_odd <= (q_red == 7'b0000001) ? 3'b000 : (king ? 3'b100 : 3'b010); // if invalid location, then piece is "erased"/ out of the game so load 0 (dark square)
                    encodings_addr2_odd <= 8*(q_blk[5:3]) + q_blk[2:0]; // black
                    encodings_data2_odd <= (q_blk == 7'b0000001) ? 3'b000 : (king ? 3'b011 : 3'b001);
                end
                1'b1: begin // update even iteration RAM
                    // encodings_wren1_even <= 1'b1;
                    // encodings_wren2_even <= 1'b1;
                    encodings_addr1_even <= 8*(q_red[5:3]) + q_red[2:0]; // red
                    encodings_data1_even <= (q_red == 7'b0000001) ? 3'b000 : (king ? 3'b100 : 3'b010);
                    encodings_addr2_even <= 8*(q_blk[5:3]) + q_blk[2:0]; // black
                    encodings_data2_even <= (q_blk == 7'b0000001) ? 3'b000 : (king ? 3'b011 : 3'b001);
                end
            endcase
            //////////////////////////////////////////// set wren to 0? or unnessasary since the data & addrs are not changing
        end
        if (incr_count) begin
            count <= count + 1;
        end
        if (reset_count) begin
            count <= 3'd0;
        end
        if (load_adj) begin
            logic [2:0] x_new, y_new;
            logic king_new;
            case(direction)
                2'b00: begin
                    x_new = x_curr + 1;   y_new = y_curr + 1;
                end
                2'b01: begin
                    x_new = x_curr - 1;   y_new = y_curr + 1;
                end
                2'b10: begin
                    x_new = x_curr + 1;   y_new = y_curr - 1;
                end
                2'b11: begin
                    x_new = x_curr - 1;   y_new = y_curr - 1;
                end
            endcase
            case (reds_turn)
                1'b0: begin
                    king_new = (y_new == 3'd7); 
                    wren_blk <= 1'b1;  
                    blk_addr <= token_addr;
                    data_blk <= {king_new, x_new, y_new};
                end

                1'b1: begin
                    king_new = (y_new == 3'd0);
                    wren_red <= 1'b1;
                    red_addr <= token_addr;
                    data_red <= {king_new, x_new, y_new};
                end
            endcase
            king <= king_new;
            // don't need to assign x_curr, y_curr is loaded in initialize
            ////////////////////v3 -- update spot_encodings64x3 RAMs////////////////////////
            ////////////////////erase moving token from current spot (to later redraw it in the new spot)///////////////////////
            //////////////////// if we don't erase here, we would have to do 3 simultaneous writes at check_done:
            //////////////////// the erasing of the old location, erasing of token jumped over, and the storage of the toke in the new spot
            case (even_iter)
                1'b0: begin // update odd iteration RAM -- only need to change location of 1 token, so only write to 1 port
                    // since we're only writing from 1 port, we don't need to consider overlap (with read) here if all of the reading is done 
                    // from the second port
                    // encodings_wren1_odd <= 1'b1;
                    encodings_addr1_odd <= 8*(x_curr) + y_curr;
                    encodings_data1_odd <= 3'b000; // dark square encoding
                end
                1'b1: begin // update even iteration RAM
                    // encodings_wren1_even <= 1'b1;
                    encodings_addr1_even <= 8*(x_curr) + y_curr;
                    encodings_data1_even <= 3'b000; // dark square encoding
                end
            endcase
            ////////////////////////////////////////////
        end
        if (load_skip) begin
            logic [2:0] x_new, y_new;
            logic king_new;
            wren_blk <= 1'b1;
            wren_red <= 1'b1;
            case(direction)
                2'b00: begin
                    x_new = x_curr + 2;   y_new = y_curr + 2;
                end
                2'b01: begin
                    x_new = x_curr - 2;   y_new = y_curr + 2;
                end
                2'b10: begin
                    x_new = x_curr + 2;   y_new = y_curr - 2;
                end
                2'b11: begin
                    x_new = x_curr - 2;   y_new = y_curr - 2;
                end
            endcase
            case (reds_turn)
                1'b0: begin
                    king_new = (y_new == 3'd7);
                    blk_addr <= token_addr;
                    data_blk <= {king_new, x_new, y_new};
                    red_addr <= opp_addr;
                    data_red <= {{6{1'b0}}, 1'b1}; // erase opponent's token
                    red_count <= red_count - 1;
                end

                1'b1: begin
                    king_new = (y_new == 3'd0);
                    red_addr <= token_addr;
                    data_red <= {king_new, x_new, y_new};
                    blk_addr <= opp_addr;
                    data_blk <= {{6{1'b0}}, 1'b1}; // erase opponent's token
                    blk_count <= blk_count - 1;
                end
            endcase
            king <= king_new;
            x_curr <= x_new;
            y_curr <= y_new;
            ////////////////////v3 -- update spot_encodings64x3 RAMs////////////////////////
            ////////////////////erase moving token from current spot (to later redraw it in the new spot)///////////////////////
            //////////////////// if we don't erase here, we would have to do 3 simultaneous writes at check_done:
            //////////////////// the erasing of the old location, erasing of token jumped over, and the storage of the toke in the new spot
            case (even_iter)
                1'b0: begin // update odd iteration RAM -- only need to change location of 1 token, so only write to 1 port
                    // since we're only writing from 1 port, we don't need to consider overlap (with read) here if all of the reading is done 
                    // from the second port
                    encodings_wren1_odd <= 1'b1;
                    encodings_addr1_odd <= 8*(x_curr) + y_curr;
                    encodings_data1_odd <= 3'b000; // dark square encoding
                end
                1'b1: begin // update even iteration RAM
                    encodings_wren1_even <= 1'b1;
                    encodings_addr1_even <= 8*(x_curr) + y_curr;
                    encodings_data1_even <= 3'b000; // dark square encoding
                end
            endcase
            ////////////////////////////////////////////
        end
        if (mult_true) begin
            mult_iter <= 1'b1;
        end
        if (done) begin
            reds_turn <= ~reds_turn;
            even_iter <= ~even_iter; ///////////////////////////////v3
        end
    end

    // status signals
    assign count_eq_11 = (count == 4'd11);    
    // direction[1] == TRUE   means direction is upward
    // direction[1] == False   means direction is downward
    assign legal_dir = king ? 1'b1 : (reds_turn ? ((direction[1]) ? 1'b1 : 1'b0) : ((direction[1]) ? 1'b0 : 1'b1));
    assign edge_blocked0 = ((direction[1]) && (y_curr == 0)) || (~(direction[1]) && (y_curr == 7)) || 
                           ((direction[0]) && (x_curr == 0)) || (~(direction[0]) && (x_curr == 7));
    assign edge_blocked1 = ((direction[1]) && (y_curr == 1)) || (~(direction[1]) && (y_curr == 6)) || 
                           ((direction[0]) && (x_curr == 1)) || (~(direction[0]) && (x_curr == 6));
    // king piece -> check all directions
    // otherwise:
    // red's turn -> check upward directions
    // black's turn -> check downward directions
    assign cont_turn = king ? 
                       ((opp_adj0 && ~two_over0) || (opp_adj1 && ~two_over1) || (opp_adj2 && ~two_over2) || (opp_adj3 && ~two_over3)) :
                       (reds_turn ? ((opp_adj2 && ~two_over2) || (opp_adj3 && ~two_over3)) : ((opp_adj0 && ~two_over0) || (opp_adj1 && ~two_over1)));


endmodule // ram_update_datapath