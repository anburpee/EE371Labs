// parking_lot_occupancy.sv displays the number of cars in the lot on the 7-seg displays
// inputs are from car_counter.sv, output is to HEX displays

module parking_lot_occupancy (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, num_cars);
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    input logic [4:0] num_cars; // input is "count" variable from car_counter.sv
    
    // case statement (fully combinational logic) that displays a certain HEX based on value of num_cars

    always_comb begin
        if (num_cars == 5'd0) begin
            HEX5 = 7'b1000110; // C
            HEX4 = 7'b1000111; // L
            HEX3 = 7'b0000110; // E
            HEX2 = 7'b0001000; // A
            HEX1 = 7'b1001110; // R
            HEX0 = 7'b1000000; // 0
        end
        else if (num_cars == 5'd1) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b1111001; // 1
        end
        else if (num_cars == 5'd2) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b0100100; // 2
        end
        else if (num_cars == 5'd3) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b0110000; // 3
        end
        else if (num_cars == 5'd4) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b0011001; // 4
        end
        else if (num_cars == 5'd5) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b0010010; // 5
        end
        else if (num_cars == 5'd6) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b0000010; // 6
        end
        else if (num_cars == 5'd7) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b1111000; // 7
        end
        else if (num_cars == 5'd8) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b0000000; // 8
        end
        else if (num_cars == 5'd9) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111111; // 
            HEX0 = 7'b0010000; // 9
        end
        else if (num_cars == 5'd10) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111001; // 1
            HEX0 = 7'b1000000; // 0
        end
        else if (num_cars == 5'd11) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111001; // 1
            HEX0 = 7'b1111001; // 1
        end
        else if (num_cars == 5'd12) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111001; // 1
            HEX0 = 7'b0100100; // 2
        end
        else if (num_cars == 5'd13) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111001; // 1
            HEX0 = 7'b0110000; // 3
        end
        else if (num_cars == 5'd14) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111001; // 1
            HEX0 = 7'b0011001; // 4
        end
        else if (num_cars == 5'd15) begin
            HEX5 = 7'b1111111; // 
            HEX4 = 7'b1111111; // 
            HEX3 = 7'b1111111; // 
            HEX2 = 7'b1111111; // 
            HEX1 = 7'b1111001; // 1
            HEX0 = 7'b0010010; // 5
        end
        else if (num_cars == 5'd16) begin
            HEX5 = 7'b0001110; // F
            HEX4 = 7'b1000001; // U
            HEX3 = 7'b1000111; // L
            HEX2 = 7'b1000111; // L
            HEX1 = 7'b1111001; // 1
            HEX0 = 7'b0000010; // 6
        end
    end
endmodule

module parking_lot_occupancy_testbench();
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [4:0] num_cars;
	 logic clk;

    parking_lot_occupancy dut (.*);

    // set up simulated clk
    parameter clk_period = 100;
    initial begin
        clk <= 0;
        forever #(clk_period/2) clk <= ~clk;
    end

    // actual testbench part
    integer i;
    initial begin
        num_cars <= 0; repeat (10) @(posedge clk);
        num_cars <= 1; repeat (10) @(posedge clk);
        num_cars <= 2; repeat (10) @(posedge clk);
        num_cars <= 3; repeat (10) @(posedge clk);
        num_cars <= 4; repeat (10) @(posedge clk);
        num_cars <= 5; repeat (10) @(posedge clk);
        num_cars <= 6; repeat (10) @(posedge clk);
        num_cars <= 7; repeat (10) @(posedge clk);
        num_cars <= 8; repeat (10) @(posedge clk);
        num_cars <= 9; repeat (10) @(posedge clk);
        num_cars <= 10; repeat (10) @(posedge clk);
        num_cars <= 11; repeat (10) @(posedge clk);
        num_cars <= 12; repeat (10) @(posedge clk);
        num_cars <= 13; repeat (10) @(posedge clk);
        num_cars <= 14; repeat (10) @(posedge clk);
        num_cars <= 15; repeat (10) @(posedge clk);
        num_cars <= 16; repeat (10) @(posedge clk);
        $stop;
    end

endmodule