/* 7-segment display driver for hex digits 0-1F.
 * Takes 5-bit input hex and outputs two 7-bit leds in decimal format.
 * LED segments are active low:
 *    -0-
 *   5   1
 *    -6-
 *   4   2
 *    -3-
 */
 // enabled by 1 bit found signal, otherwise display off
module seg7_two_outputs (hex, found, leds1, leds0);
	input  logic [4:0] hex; 
	input logic found;
	// leds1 = tens place
	// leds0 = ones place 
	output logic [6:0] leds1, leds0; 

	always_comb begin
		if (found) begin
			case (hex)
				//       Light: 6543210
				5'h0: begin // 0
					leds1 = 7'b1111111;
					leds0 = 7'b1000000;
				end
				5'h1: begin // 1
					leds1 = 7'b1111111;
					leds0 = 7'b1111001;
				end
				5'h2: begin // 2
					leds1 = 7'b1111111;
					leds0 = 7'b0100100;
				end
				5'h3: begin // 3
					leds1 = 7'b1111111;
					leds0 = 7'b0110000;
				end
				5'h4: begin // 4
					leds1 = 7'b1111111;
					leds0 = 7'b0011001;
				end
				5'h5: begin // 5
					leds1 = 7'b1111111;
					leds0 = 7'b0010010;
				end
				5'h6: begin // 6
					leds1 = 7'b1111111;
					leds0 = 7'b0000010;
				end
				5'h7: begin // 7
					leds1 = 7'b1111111;
					leds0 = 7'b1111000;
				end
				5'h8: begin // 8
					leds1 = 7'b1111111;
					leds0 = 7'b0000000;
				end
				5'h9: begin // 9
					leds1 = 7'b1111111;
					leds0 = 7'b0010000;
				end
				5'hA: begin // 10
					leds1 = 7'b1111001;
					leds0 = 7'b1000000;
				end
				5'hB: begin // 11
					leds1 = 7'b1111001;
					leds0 = 7'b1111001;
				end
				5'hC: begin // 12
					leds1 = 7'b1111001;
					leds0 = 7'b0100100;
				end
				5'hD: begin // 13
					leds1 = 7'b1111001;
					leds0 = 7'b0110000;
				end
				5'hE: begin // 14
					leds1 = 7'b1111001;
					leds0 = 7'b0011001;
				end
				5'hF: begin // 15
					leds1 = 7'b1111001;
					leds0 = 7'b0010010;
				end
				5'h10: begin // 16
					leds1 = 7'b1111001;
					leds0 = 7'b0000010;
				end
				5'h11: begin // 17
					leds1 = 7'b1111001;
					leds0 = 7'b1111000;
				end
				5'h12: begin // 18
					leds1 = 7'b1111001;
					leds0 = 7'b0000000;
				end
				5'h13: begin // 19
					leds1 = 7'b1111001;
					leds0 = 7'b0010000;
				end
				5'h14: begin // 20
					leds1 = 7'b0100100;
					leds0 = 7'b1000000;
				end
				5'h15: begin // 21
					leds1 = 7'b0100100;
					leds0 = 7'b1111001;
				end
				5'h16: begin // 22
					leds1 = 7'b0100100;
					leds0 = 7'b0100100;
				end
				5'h17: begin // 23
					leds1 = 7'b0100100;
					leds0 = 7'b0110000;
				end
				5'h18: begin // 24
					leds1 = 7'b0100100;
					leds0 = 7'b0011001;
				end
				5'h19: begin // 25
					leds1 = 7'b0100100;
					leds0 = 7'b0010010;
				end
				5'h1A: begin // 26
					leds1 = 7'b0100100;
					leds0 = 7'b0000010;
				end
				5'h1B: begin // 27
					leds1 = 7'b0100100;
					leds0 = 7'b1111000;
				end
				5'h1C: begin // 28
					leds1 = 7'b0100100;
					leds0 = 7'b0000000;
				end
				5'h1D: begin // 29
					leds1 = 7'b0100100;
					leds0 = 7'b0010000;
				end
				5'h1E: begin // 30
					leds1 = 7'b0110000;
					leds0 = 7'b1000000;
				end
				5'h1F: begin // 31
					leds1 = 7'b0110000;
					leds0 = 7'b1111001;
				end
			endcase
		end
		else begin
				leds1 = 7'b1111111;
				leds0 = 7'b1111111;
		end
	end
		
endmodule  // seg7_two_outputs