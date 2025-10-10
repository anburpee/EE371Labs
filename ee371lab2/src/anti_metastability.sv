// takes a given signal through 2 D-FFs to prevent metastability
module anti_metastability (clk, in, out);
	output logic out;
	input logic clk, in;
	
	logic ff1_out;
	
	always_ff @(posedge clk) begin
	
			ff1_out <= in;
			
			out <= ff1_out;
			
	end
endmodule 