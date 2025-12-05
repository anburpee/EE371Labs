// // datapath for ram_update module
// // sends status signals to and recieves control signals from ram_update_ctrl.sv
// `timescale 1 ps / 1 ps
// module ram_update_datapath (input logic clk,
//                             input logic reset, 
//                             input logic [3:0] key,
//                             input logic [5:0] sw,
//                             input logic load_iter,
//                             input logic initialize,
//                             input logic read,
//                             input logic check0,
//                             input logic check_done,
//                             input logic incr_count,
//                             input logic reset_count,
//                             input logic load_adj, 
//                             input logic load_skip,
//                             input logic mult_true,
//                             input logic done,
//                             output logic count_eq_11,
//                             output logic valid_xy,
//                             output logic legal_dir,
//                             output logic edge_blocked0,
//                             output logic own_adj,
//                             output logic opp_adj,
//                             output logic edge_blocked1,
//                             output logic two_over,  // checks if there is a token two spaces over in the specified direction
//                             output logic cont_turn,
//                             output logic mult_iter
//                         );

//     logic reds_turn;
//     // KEEP original names (some are kept for compatibility / debugging)
//     logic wren_red, wren_blk;               // NOTE: these are not used to drive RAM directly anymore
//     logic [6:0] q_red, q_blk;
//     logic [6:0] data_red, data_blk;        // FIX: no longer produced inside always_ff; they are kept for backward compatibility/debug
//     logic [3:0] token_addr; // addr of the token to be moved on current player's turn
//     logic [3:0] opp_addr;
//     logic [1:0] direction;
//     logic king;
//     logic [2:0] x_curr, y_curr;
//     logic opp_adj0, opp_adj1, opp_adj2, opp_adj3;
//     logic two_over0, two_over1, two_over2, two_over3;
//     logic [3:0] count;
//     logic [3:0] red_addr, blk_addr; // registers storing addresses used elsewhere (kept)
//     logic [4:0] red_count, blk_count;

//     // --- FIX: combinational RAM interface signals (RAM must see address/data/wren stable before posedge) ---
//     logic [3:0] ram_blk_addr;      // FIX: combinational address to black RAM (drives blk_ram.address)
//     logic [3:0] ram_red_addr;      // FIX: combinational address to red RAM (drives red_ram.address)
//     logic [6:0] ram_blk_data;      // FIX: combinational data to black RAM
//     logic [6:0] ram_red_data;      // FIX: combinational data to red RAM
//     logic       ram_blk_wren;      // FIX: combinational write-enable to black RAM
//     logic       ram_red_wren;      // FIX: combinational write-enable to red RAM

//     // instantiate RAMS that store location of each token
//     // FIX: instantiating with ram_* signals so inputs are combinationally driven before clock
//     black_ram16x7 blk_ram (.address(ram_blk_addr), .clock(clk), .data(ram_blk_data), .wren(ram_blk_wren), .q(q_blk));
//     red_ram16x7 red_ram (.address(ram_red_addr), .clock(clk), .data(ram_red_data), .wren(ram_red_wren), .q(q_red));


//     // ctrl logic / state registers (no change in behavioral sequencing)
//     always_ff @(posedge clk) begin
//         if (reset) begin
//             reds_turn <= 1'b0;
//             red_count <= 4'd12;
//             blk_count <= 4'd12;

//             // FIX: initialize stateful outputs/regs to known values on reset to avoid X propagation
//             count <= 4'd0;
//             valid_xy <= 1'b0;
//             own_adj <= 1'b0;
//             opp_adj <= 1'b0;
//             token_addr <= 4'd0;
//             opp_addr <= 4'd0;
//             two_over <= 1'b0;
//             king <= 1'b0;
//             direction <= 2'b00;
//             x_curr <= 3'd0;
//             y_curr <= 3'd0;
//             two_over0 <= 1'b0;
//             two_over1 <= 1'b0;
//             two_over2 <= 1'b0;
//             two_over3 <= 1'b0;
//             opp_adj0 <= 1'b0;
//             opp_adj1 <= 1'b0;
//             opp_adj2 <= 1'b0;
//             opp_adj3 <= 1'b0;

//             // keep data_* defined to prevent X when combinational logic reads them before they are prepared
//             // data_blk <= 7'd0; // FIX: known default content (empty tile encoding)
//             // data_red <= 7'd0;
//             red_addr <= 4'd0;
//             blk_addr <= 4'd0;
//             wren_blk <= 1'b0;
//             wren_red <= 1'b0;
//             mult_iter <= 1'b0;
//         end
//         else begin
//             if (load_iter) begin
//                 mult_iter <= 1'b0;
//             end
//             if (initialize) begin
//                 direction <= key[0] ? 2'b00 : (key[1] ? 2'b01 : (key[2] ? 2'b10 : 2'b11));
//                 count <= 1'b0;
//                 valid_xy <= 1'b0;
//                 own_adj <= 1'b0;
//                 opp_adj <= 1'b0;
//                 token_addr <= 1'b0;
//                 two_over <= 1'b0;
//                 king <= 1'b0;
//                 if (mult_iter == 1'b0) begin
//                     x_curr <= sw[5:3];
//                     y_curr <= sw[2:0];
//                     two_over0 <= 1'b0;
//                     two_over1 <= 1'b0;
//                     two_over2 <= 1'b0;
//                     two_over3 <= 1'b0;
//                     opp_adj0 <= 1'b0;
//                     opp_adj1 <= 1'b0;
//                     opp_adj2 <= 1'b0;
//                     opp_adj3 <= 1'b0;
//                 end
//             end
//             if (read) begin
//                 // keep local copies of addresses for debugging; actual RAM address is driven combinationally
//                 red_addr <= count;
//                 blk_addr <= count;
//                 wren_blk <= 1'b0;
//                 wren_red <= 1'b0;
//             end
//             if (check0) begin
//                 logic [2:0] x_own, y_own, x_opp, y_opp;
//                 logic [2:0] x_cond0, y_cond0, x_cond1, y_cond1;
//                 x_own = reds_turn ? q_red[5:3] : q_blk [5:3];
//                 y_own = reds_turn ? q_red[2:0] : q_blk [2:0];
//                 x_opp = reds_turn ? q_blk[5:3] : q_red [5:3];
//                 y_opp = reds_turn ? q_blk[2:0] : q_red [2:0];
//                 if ((x_own == x_curr) && (y_own == y_curr) && !({x_own, y_own} == 7'b0000001)) begin
//                     valid_xy <= 1'b1;
//                     token_addr <= count;
//                     king <= reds_turn ? q_red[6] : q_blk[6];
//                 end
//                 case (direction)
//                     2'b00: begin
//                         x_cond0 = x_curr + 1;    y_cond0 = y_curr + 1;   x_cond1 = x_curr + 2;    y_cond1 = y_curr + 2;
//                     end
//                     2'b01: begin
//                         x_cond0 = x_curr - 1;    y_cond0 = y_curr + 1;   x_cond1 = x_curr - 2;    y_cond1 = y_curr + 2;
//                     end
//                     2'b10: begin
//                         x_cond0 = x_curr + 1;    y_cond0 = y_curr - 1;   x_cond1 = x_curr + 2;    y_cond1 = y_curr - 2;
//                     end
//                     2'b11: begin
//                         x_cond0 = x_curr - 1;    y_cond0 = y_curr - 1;   x_cond1 = x_curr - 2;    y_cond1 = y_curr - 2;
//                     end
//                 endcase
//                 if (x_own == x_cond0 && y_own == y_cond0) begin
//                     own_adj <= 1'b1;
//                 end
//                 if (x_opp == x_cond0 && y_opp == y_cond0) begin
//                     opp_adj <= 1'b1;
//                     opp_addr <= count;
//                 end
//                 if (((x_own == x_cond1) && (y_own == y_cond1)) || ((x_opp == x_cond1) && (y_opp == y_cond1))) begin
//                     two_over <= 1'b1;
//                 end
//             end
//             if (check_done) begin
//                 logic [2:0] x_own, y_own, x_opp, y_opp;
//                 x_own = reds_turn ? q_red[5:3] : q_blk [5:3];
//                 y_own = reds_turn ? q_red[2:0] : q_blk [2:0];
//                 x_opp = reds_turn ? q_blk[5:3] : q_red [5:3];
//                 y_opp = reds_turn ? q_blk[2:0] : q_red [2:0];

//                 if ((x_opp == x_curr + 1) && (y_opp == y_curr + 1)) 
//                     opp_adj0 <= 1'b1;
//                 if (((x_own == x_curr + 2) && (y_own == y_curr + 2)) || ((x_opp == x_curr - 2) && (y_opp == y_curr + 2)))
//                     two_over0 <= 1'b1;
//                 if ((x_opp == x_curr - 1) && (y_own == y_curr + 1)) 
//                     opp_adj1 <= 1'b1;
//                 if (((x_own == x_curr - 2) && (y_own == y_curr + 2)) || ((x_opp == x_curr - 2) && (y_opp == y_curr + 2)))
//                     two_over1 <= 1'b1;
//                 if ((x_opp == x_curr + 1) && (y_own == y_curr - 1)) 
//                     opp_adj2 <= 1'b1;
//                 if (((x_own == x_curr + 2) && (y_own == y_curr - 2)) || ((x_opp == x_curr + 2) && (y_opp == y_curr - 2)))
//                     two_over2 <= 1'b1;
//                 if ((x_opp == x_curr - 1) && (y_own == y_curr - 1)) 
//                     opp_adj3 <= 1'b1;
//                 if (((x_own == x_curr - 2) && (y_own == y_curr - 2)) || ((x_opp == x_curr - 2) && (y_opp == y_curr - 2)))
//                     two_over3 <= 1'b1;
//             end
//             if (incr_count) begin
//                 count <= count + 1;
//             end
//             if (reset_count) begin
//                 count <= 3'd0;
//             end

//             // NOTE: do NOT prepare RAM port values here. Only update stateful registers that must change.
//             // The combinational block below will compute ram_* signals from these registers + control inputs.

//             if (mult_true) begin
//                 mult_iter <= 1'b1;
//             end
//             if (done) begin
//                 reds_turn <= ~reds_turn;
//             end
//         end
//     end

//     // --- FIX: combinational block computes ram_* signals, and prepares erase/move data based on CURRENT state.
//     //           This ensures address/data/wren are stable *before* the clock edge.
//     always_comb begin
//         // defaults (avoid X)
//         ram_blk_wren  = 1'b0;
//         ram_red_wren  = 1'b0;
//         ram_blk_addr  = blk_addr;   // default to last known register address
//         ram_red_addr  = red_addr;
//         ram_blk_data  = 7'b0000001; // default empty encoding (use same erase code you used)
//         ram_red_data  = 7'b0000001;
//         // Also maintain data_blk/data_red for backward compatibility (drive them combinationally)
//         data_blk = 7'b0000001;      // FIX: ensure data_* never read as X in always_comb
//         data_red = 7'b0000001;

//         // Present read address when read is asserted (no writes)
//         if (read) begin
//             ram_blk_addr = count;
//             ram_red_addr = count;
//             ram_blk_wren = 1'b0;
//             ram_red_wren = 1'b0;
//         end

//         // If load_adj: single-step move. Compute new (x_new,y_new,king_new) *combinationally* from current state.
//         if (load_adj) begin
//             logic [2:0] x_new, y_new;
//             logic king_new;
//             case(direction)
//                 2'b00: begin x_new = x_curr + 1; y_new = y_curr + 1; end
//                 2'b01: begin x_new = x_curr - 1; y_new = y_curr + 1; end
//                 2'b10: begin x_new = x_curr + 1; y_new = y_curr - 1; end
//                 2'b11: begin x_new = x_curr - 1; y_new = y_curr - 1; end
//                 default: begin x_new = x_curr; y_new = y_curr; end
//             endcase

//             // produce the data word here (combinationally), do not rely on always_ff assignment
//             if (reds_turn == 1'b0) begin
//                 king_new = (y_new == 3'd7);
//                 ram_blk_wren  = 1'b1;
//                 ram_blk_addr  = token_addr;             // token_addr was set in a previous cycle by check0
//                 ram_blk_data  = {king_new, x_new, y_new};
//                 // reflect prepared data into data_blk (kept for visibility / debugging)
//                 data_blk = ram_blk_data;                // FIX: drive data_blk combinationally to avoid X
//             end
//             else begin
//                 king_new = (y_new == 3'd0);
//                 ram_red_wren  = 1'b1;
//                 ram_red_addr  = token_addr;
//                 ram_red_data  = {king_new, x_new, y_new};
//                 data_red = ram_red_data;                // FIX: drive data_red combinationally to avoid X
//             end
//         end

//         // If load_skip: capture. Need to write the moving piece AND erase the opponent piece
//         if (load_skip) begin
//             logic [2:0] x_new, y_new;
//             logic king_new;
//             case(direction)
//                 2'b00: begin x_new = x_curr + 2;   y_new = y_curr + 2; end
//                 2'b01: begin x_new = x_curr - 2;   y_new = y_curr + 2; end
//                 2'b10: begin x_new = x_curr + 2;   y_new = y_curr - 2; end
//                 2'b11: begin x_new = x_curr - 2;   y_new = y_curr - 2; end
//                 default: begin x_new = x_curr; y_new = y_curr; end
//             endcase

//             if (reds_turn == 1'b0) begin
//                 king_new = (y_new == 3'd7);
//                 ram_blk_wren  = 1'b1;
//                 ram_blk_addr  = token_addr;
//                 ram_blk_data  = {king_new, x_new, y_new};
//                 data_blk = ram_blk_data;

//                 ram_red_wren  = 1'b1;
//                 ram_red_addr  = opp_addr;                     // opponent address captured earlier
//                 ram_red_data  = 7'b0000001;                   // erase encoding (same as above)
//                 data_red = ram_red_data;
//             end
//             else begin
//                 king_new = (y_new == 3'd0);
//                 ram_red_wren  = 1'b1;
//                 ram_red_addr  = token_addr;
//                 ram_red_data  = {king_new, x_new, y_new};
//                 data_red = ram_red_data;

//                 ram_blk_wren  = 1'b1;
//                 ram_blk_addr  = opp_addr;
//                 ram_blk_data  = 7'b0000001;
//                 data_blk = ram_blk_data;
//             end
//         end
//     end // always_comb

//     // status signals
//     assign count_eq_11 = (count == 4'd11);    
//     // direction[1] == TRUE   means direction is upward
//     // direction[1] == False   means direction is downward
//     assign legal_dir = king ? 1'b1 : (reds_turn ? ((direction[1]) ? 1'b1 : 1'b0) : ((direction[1]) ? 1'b0 : 1'b1));
//     assign edge_blocked0 = ((direction[1]) && (y_curr == 0)) || (~(direction[1]) && (y_curr == 7)) || 
//                            ((direction[0]) && (x_curr == 0)) || (~(direction[0]) && (x_curr == 7));
//     assign edge_blocked1 = ((direction[1]) && (y_curr == 1)) || (~(direction[1]) && (y_curr == 6)) || 
//                            ((direction[0]) && (x_curr == 1)) || (~(direction[0]) && (x_curr == 6));
//     // king piece -> check all directions
//     // otherwise:
//     // red's turn -> check upward directions
//     // black's turn -> check downward directions
//     assign cont_turn = king ? 
//                        ((opp_adj0 && ~two_over0) || (opp_adj1 && ~two_over1) || (opp_adj2 && ~two_over2) || (opp_adj3 && ~two_over3)) :
//                        (reds_turn ? ((opp_adj2 && ~two_over2) || (opp_adj3 && ~two_over3)) : ((opp_adj0 && ~two_over0) || (opp_adj1 && ~two_over1)));

// endmodule // ram_update_datapath





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
                            output logic mult_iter
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
    logic skipped; // to keep track of whether the player skipped over opponent (to have a chance at another turn) /////////////////////////////////////////////////

    // instantiate RAMS that store location of each token
    black_ram16x7 blk_ram (.address(blk_addr), .clock(clk), .data(data_blk), .wren(wren_blk), .q(q_blk));
    red_ram16x7 red_ram (.address(red_addr), .clock(clk), .data(data_red), .wren(wren_red), .q(q_red));


    // ctrl logic
    always_ff @(posedge clk) begin
        if (reset) begin
            reds_turn <= 1'b0;
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
            skipped <= 1'b0; ///////////////////////////////////////////////////////////////////////////////////////////////new
            if (mult_iter == 1'b0) begin
                x_curr <= sw[5:3];
                y_curr <= sw[2:0];
                two_over0 <= 1'b0;
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
        if (check_done) begin
            logic [2:0] x_own, y_own, x_opp, y_opp;
            x_own = reds_turn ? q_red[5:3] : q_blk [5:3];
            y_own = reds_turn ? q_red[2:0] : q_blk [2:0];
            x_opp = reds_turn ? q_blk[5:3] : q_red [5:3];
            y_opp = reds_turn ? q_blk[2:0] : q_red [2:0];

            if ((x_opp == x_curr + 1) && (y_opp == y_curr + 1)) 
                opp_adj0 <= 1'b1;
            if (((x_own == x_curr + 2) && (y_own == y_curr + 2)) || ((x_opp == x_curr - 2) && (y_opp == y_curr + 2)))
                two_over0 <= 1'b1;
            if ((x_opp == x_curr - 1) && (y_own == y_curr + 1)) 
                opp_adj1 <= 1'b1;
            if (((x_own == x_curr - 2) && (y_own == y_curr + 2)) || ((x_opp == x_curr - 2) && (y_opp == y_curr + 2)))
                two_over1 <= 1'b1;
            if ((x_opp == x_curr + 1) && (y_own == y_curr - 1)) 
                opp_adj2 <= 1'b1;
            if (((x_own == x_curr + 2) && (y_own == y_curr - 2)) || ((x_opp == x_curr + 2) && (y_opp == y_curr - 2)))
                two_over2 <= 1'b1;
            if ((x_opp == x_curr - 1) && (y_own == y_curr - 1)) 
                opp_adj3 <= 1'b1;
            if (((x_own == x_curr - 2) && (y_own == y_curr - 2)) || ((x_opp == x_curr - 2) && (y_opp == y_curr - 2)))
                two_over3 <= 1'b1;
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
            skipped <= 1'b1;    ///////////////////////////////////////////////////////////////////////////////////////////new
        end
        if (mult_true) begin
            mult_iter <= 1'b1;
        end
        if (done) begin
            reds_turn <= ~reds_turn;
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
    assign cont_turn = skipped ? ////////////////////////////////////////////////////////////////////////////////////////////////new
                       (king ? 
                       ((opp_adj0 && ~two_over0) || (opp_adj1 && ~two_over1) || (opp_adj2 && ~two_over2) || (opp_adj3 && ~two_over3)) :
                       (reds_turn ? ((opp_adj2 && ~two_over2) || (opp_adj3 && ~two_over3)) : ((opp_adj0 && ~two_over0) || (opp_adj1 && ~two_over1)))) :
                       1'b0; // no chance of continuing turn unless you've already skipped over an opponent


endmodule // ram_update_datapath