// parking_lot_occupancy.sv displays the number of cars in the lot on the 7-seg displays
// inputs are from car_counter.sv, output is to HEX displays

module parking_lot_occupancy (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, num_cars);
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    input logic [4:0] num_cars; // input is "count" variable from car_counter.sv
    
    // case statement (fully combinational logic) that displays a certain HEX based on value of num_cars

    always_comb begin
        if (num_cars == 5'b0) begin
            HEX5 = 7'b1000110; // C
            HEX4 = 7'b1000111; // L
            HEX3 = 7'b0000110; // E
            HEX2 = 7'b0001000; // A
            HEX1 = 7'b1001110; // R
            HEX0 = 7'b1000000; // 0
        end
        else if (num_cars == 5'b1) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b1111001; // 1
        end
        else if (num_cars == 5'b2) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b0100100; // 2
        end
        else if (num_cars == 5'b3) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b0110000; // 3
        end
        else if (num_cars == 5'b4) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b0011001; // 4
        end
        else if (num_cars == 5'b5) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b0010010; // 5
        end
        else if (num_cars == 5'b6) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b0000010; // 6
        end
        else if (num_cars == 5'b7) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b1111000; // 7
        end
        else if (num_cars == 5'b8) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b0000000; // 8
        end
        else if (num_cars == 5'b9) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b0010000; // 9
        end
        else if (num_cars == 5'b10) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111001; // 1
            HEX0 = 7'b1000000; // 0
        end
        else if (num_cars == 5'b11) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111001; // 1
            HEX0 = 7'b1111001; // 1
        end
        else if (num_cars == 5'b12) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111001; // 1
            HEX0 = 7'b0100100; // 2
        end
        else if (num_cars == 5'b13) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111001; // 1
            HEX0 = 7'b0110000; // 3
        end
        else if (num_cars == 5'b14) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111001; // 1
            HEX0 = 7'b0011001; // 4
        end
        else if (num_cars == 5'b15) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111001; // 1
            HEX0 = 7'b0010010; // 5
        end
        else if (num_cars == 5'b16) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111001; // 1
            HEX0 = 7'b0000010; // 6
        end
    end

endmodule