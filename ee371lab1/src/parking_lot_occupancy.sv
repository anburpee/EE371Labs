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
            HEX5 = 7'b1000110; // C
            HEX4 = 7'b1000111; // L
            HEX3 = 7'b0000110; // E
            HEX2 = 7'b0001000; // A
            HEX1 = 7'b1001110; // R
            HEX0 = 7'b1000000; // 0
        end
    end

endmodule