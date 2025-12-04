// datapath for ram_update module
`timescale 1 ps / 1 ps

module ram_update_datapath (
    input  logic clk,
    input  logic reset, 
    input  logic [3:0] key,
    input  logic [5:0] sw,
    input  logic load_iter,
    input  logic initialize,
    input  logic read,
    input  logic check0,
    input  logic check_done,
    input  logic incr_count,
    input  logic reset_count,
    input  logic load_adj, 
    input  logic load_skip,
    input  logic mult_true,
    input  logic done,
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
    logic wren_red, wren_blk;
    logic [6:0] q_red, q_blk;
    logic [6:0] data_red, data_blk;
    logic [3:0] token_addr;
    logic [3:0] opp_addr;
    logic [1:0] direction;
    logic king;
    logic [2:0] x_curr, y_curr;

    logic opp_adj0, opp_adj1, opp_adj2, opp_adj3;
    logic two_over0, two_over1, two_over2, two_over3;

    logic [3:0] count;
    logic [3:0] red_addr, blk_addr;
    logic [4:0] red_count, blk_count;

    // RAMs
    black_ram16x7 blk_ram (.address(blk_addr), .clock(clk), .data(data_blk), .wren(wren_blk), .q(q_blk));
    red_ram16x7   red_ram (.address(red_addr),  .clock(clk), .data(data_red), .wren(wren_red), .q(q_red));

    // MAIN SEQUENTIAL LOGIC
    always_ff @(posedge clk) begin
        if (reset) begin
            reds_turn <= 1'b0;
            red_count <= 5'd12;
            blk_count <= 5'd12;
            mult_iter <= 1'b0;

            // FIX: deterministic reset
            count <= 4'd0;        // FIX
            valid_xy <= 1'b0;     // FIX
            own_adj  <= 1'b0;     // FIX
            opp_adj  <= 1'b0;     // FIX
            token_addr <= 4'd0;   // FIX
            two_over <= 1'b0;     // FIX
            king <= 1'b0;         // FIX
            x_curr <= 3'd0;       // FIX
            y_curr <= 3'd0;       // FIX

            opp_adj0 <= 1'b0; opp_adj1 <= 1'b0; opp_adj2 <= 1'b0; opp_adj3 <= 1'b0;   // FIX
            two_over0 <= 1'b0; two_over1 <= 1'b0; two_over2 <= 1'b0; two_over3 <= 1'b0; // FIX

            wren_blk <= 1'b0; // FIX
            wren_red <= 1'b0; // FIX
        end 

        else begin
            if (load_iter)
                mult_iter <= 1'b0;

            if (initialize) begin
                direction <= key[0] ? 2'b00 :
                             key[1] ? 2'b01 :
                             key[2] ? 2'b10 : 2'b11;

                count <= 4'd0;       // FIX
                valid_xy <= 1'b0;
                own_adj  <= 1'b0;
                opp_adj  <= 1'b0;
                token_addr <= 4'd0;  // FIX
                two_over <= 1'b0;
                king <= 1'b0;

                if (mult_iter == 1'b0) begin
                    x_curr <= sw[5:3];
                    y_curr <= sw[2:0];

                    opp_adj0 <= 1'b0; opp_adj1 <= 1'b0; opp_adj2 <= 1'b0; opp_adj3 <= 1'b0;
                    two_over0 <= 1'b0; two_over1 <= 1'b0; two_over2 <= 1'b0; two_over3 <= 1'b0;
                end
            end

            if (read) begin
                red_addr <= count;
                blk_addr <= count;
                wren_blk <= 1'b0;
                wren_red <= 1'b0;
            end

            // check0: unchanged except for style consistency
            if (check0) begin
                logic [2:0] x_own, y_own, x_opp, y_opp;
                logic [2:0] x_c0, y_c0, x_c1, y_c1;

                x_own = reds_turn ? q_red[5:3] : q_blk[5:3];
                y_own = reds_turn ? q_red[2:0] : q_blk[2:0];
                x_opp = reds_turn ? q_blk[5:3] : q_red[5:3];
                y_opp = reds_turn ? q_blk[2:0] : q_red[2:0];

                if (x_own == x_curr && y_own == y_curr) begin
                    valid_xy <= 1'b1;
                    token_addr <= count;
                    king <= reds_turn ? q_red[6] : q_blk[6];
                end

                case (direction)
                    2'b00: begin x_c0 = x_curr+1; y_c0 = y_curr+1; x_c1 = x_curr+2; y_c1 = y_curr+2; end
                    2'b01: begin x_c0 = x_curr-1; y_c0 = y_curr+1; x_c1 = x_curr-2; y_c1 = y_curr+2; end
                    2'b10: begin x_c0 = x_curr+1; y_c0 = y_curr-1; x_c1 = x_curr+2; y_c1 = y_curr-2; end
                    2'b11: begin x_c0 = x_curr-1; y_c0 = y_curr-1; x_c1 = x_curr-2; y_c1 = y_curr-2; end
                endcase

                if (x_own == x_c0 && y_own == y_c0)
                    own_adj <= 1'b1;
                if (x_opp == x_c0 && y_opp == y_c0) begin
                    opp_adj <= 1'b1;
                    opp_addr <= count;
                end
                if ((x_own == x_c1 && y_own == y_c1) ||
                    (x_opp == x_c1 && y_opp == y_c1))
                    two_over <= 1'b1;
            end

            // check_done: unchanged
            if (check_done) begin
                logic [2:0] xo, yo, xp, yp;
                xo = reds_turn ? q_red[5:3] : q_blk[5:3];
                yo = reds_turn ? q_red[2:0] : q_blk[2:0];
                xp = reds_turn ? q_blk[5:3] : q_red[5:3];
                yp = reds_turn ? q_blk[2:0] : q_red[2:0];

                if (xp == x_curr+1 && yp == y_curr+1) opp_adj0 <= 1'b1;
                if ((xo == x_curr+2 && yo == y_curr+2) || (xp == x_curr+2 && yp == y_curr+2)) two_over0 <= 1'b1;

                if (xp == x_curr-1 && yp == y_curr+1) opp_adj1 <= 1'b1;
                if ((xo == x_curr-2 && yo == y_curr+2) || (xp == x_curr-2 && yp == y_curr+2)) two_over1 <= 1'b1;

                if (xp == x_curr+1 && yp == y_curr-1) opp_adj2 <= 1'b1;
                if ((xo == x_curr+2 && yo == y_curr-2) || (xp == x_curr+2 && yp == y_curr-2)) two_over2 <= 1'b1;

                if (xp == x_curr-1 && yp == y_curr-1) opp_adj3 <= 1'b1;
                if ((xo == x_curr-2 && yo == y_curr-2) || (xp == x_curr-2 && yp == y_curr-2)) two_over3 <= 1'b1;
            end

            if (incr_count)
                count <= count + 1;

            if (reset_count)
                count <= 4'd0;

            // load_adj: unchanged
            if (load_adj) begin
                logic [2:0] xn, yn;
                logic kn;

                case (direction)
                    2'b00: begin xn = x_curr+1; yn = y_curr+1; end
                    2'b01: begin xn = x_curr-1; yn = y_curr+1; end
                    2'b10: begin xn = x_curr+1; yn = y_curr-1; end
                    2'b11: begin xn = x_curr-1; yn = y_curr-1; end
                endcase

                case (reds_turn)
                    1'b0: begin
                        kn = (yn == 3'd7);
                        wren_blk <= 1'b1;
                        blk_addr <= token_addr;
                        data_blk <= {kn, xn, yn};
                    end
                    1'b1: begin
                        kn = (yn == 3'd0);
                        wren_red <= 1'b1;
                        red_addr <= token_addr;
                        data_red <= {kn, xn, yn};
                    end
                endcase

                king <= kn;
            end

            // load_skip: with FIX (zero-out opponent)
            if (load_skip) begin
                logic [2:0] xn, yn;
                logic kn;

                wren_blk <= 1'b1;
                wren_red <= 1'b1;

                case (direction)
                    2'b00: begin xn = x_curr+2; yn = y_curr+2; end
                    2'b01: begin xn = x_curr-2; yn = y_curr+2; end
                    2'b10: begin xn = x_curr+2; yn = y_curr-2; end
                    2'b11: begin xn = x_curr-2; yn = y_curr-2; end
                endcase

                case (reds_turn)
                    1'b0: begin
                        kn = (yn == 3'd7);
                        blk_addr <= token_addr;
                        data_blk <= {kn, xn, yn};

                        red_addr <= opp_addr;
                        data_red <= 7'd0;   // FIX: zero = erased
                        red_count <= red_count - 1;
                    end

                    1'b1: begin
                        kn = (yn == 3'd0);
                        red_addr <= token_addr;
                        data_red <= {kn, xn, yn};

                        blk_addr <= opp_addr;
                        data_blk <= 7'd0;   // FIX
                        blk_count <= blk_count - 1;
                    end
                endcase

                king <= kn;
                x_curr <= xn;
                y_curr <= yn;
            end

            if (mult_true)
                mult_iter <= 1'b1;

            if (done)
                reds_turn <= ~reds_turn;

        end
    end

    // STATUS SIGNALS
    assign count_eq_11 = (count == 4'd11);

    assign legal_dir = king ? 1'b1 :
                       (reds_turn ? direction[1] : ~direction[1]);

    assign edge_blocked0 =
        (direction[1] && y_curr == 0) ||
        (~direction[1] && y_curr == 7) ||
        (direction[0] && x_curr == 0) ||
        (~direction[0] && x_curr == 7);

    assign edge_blocked1 =
        (direction[1] && y_curr == 1) ||
        (~direction[1] && y_curr == 6) ||
        (direction[0] && x_curr == 1) ||
        (~direction[0] && x_curr == 6);

    assign cont_turn = king ?
        ((opp_adj0 && ~two_over0) || (opp_adj1 && ~two_over1) ||
         (opp_adj2 && ~two_over2) || (opp_adj3 && ~two_over3)) :
        (reds_turn ?
            ((opp_adj2 && ~two_over2) || (opp_adj3 && ~two_over3)) :
            ((opp_adj0 && ~two_over0) || (opp_adj1 && ~two_over1)));

endmodule
