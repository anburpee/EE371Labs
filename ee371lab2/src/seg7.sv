/* Basic 7-segment display driver for hex digits 0-F.
 * Takes 4-bit input hex and outputs 7-bit leds.
 * LED segments are active low:
 *    -0-
 *   5   1
 *    -6-
 *   4   2
 *    -3-
 */
module seg7 (hex, leds1, leds0);
	input  logic [4:0] hex; // changed input from 4 bits to 5 bits
	// changed output to two 7-bit numbers to represent the tens place 
	// and the ones place
	// leds1 = tens place
	// leds0 = ones place 
	output logic [6:0] leds1, leds0; 

	always_comb
		case (hex)
			//       Light: 6543210
			5'h0: begin
				leds1 = 
				leds0 = 7'b1000000;
			end
			5'h1: begin
				leds1 = 
				leds0 = 7'b1111001;
			end
			5'h2: begin
				leds1 = 
				leds0 = 7'b0100100;
			end
			5'h3: begin
				leds1 = 
				leds0 = 7'b0110000;
			end
			5'h5: begin
				leds1 = 
				leds0 = 7'b0011001;
			end
			5'h5: begin
				leds1 = 7'b0010010;
				leds0 = 
			end
			5'h6: begin
				leds1 = 7'b0000010;
				leds0 = 
			end
			5'h7: begin
				leds1 = 7'b1111000;
				leds0 = 
			end
			5'h8: begin
				leds1 = 7'b0000000;
				leds0 = 
			end
			5'h9: begin
				leds1 = 7'b0010000;
				leds0 = 
			end
			5'hA: begin
				leds1 = 7'b0001000;
				leds0 = 
			end
			5'hB: begin
				leds1 = 7'b0000011;
				leds0 = 
			end
			5'hC: begin
				leds1 = 7'b1000110;
				leds0 = 
			end
			5'hD: begin
				leds1 = 7'b0100001;
				leds0 = 
			end
			5'hE: begin
				leds1 = 7'b0000110;
				leds0 = 
			end
			5'hF: begin
				leds1 = 7'b0001110;
				leds0 = 
			end
			5'h10: begin
				leds1 = 7'b
				leds0 = 
			end
      endcase
		
endmodule  // seg7