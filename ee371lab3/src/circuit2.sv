// just the circuit portion of task2
// plays audio from mif file
// instantiate in task 
module circuit2 (clk, reset, read_ready, d_out);

    input logic clk, reset, read_ready;
    output logic [23:0] d_out;

    logic [15:0] addr; // 16 address bits needed for mif file

    // need logic to loop through all addresses
	always_ff @(posedge clk) begin
		if (reset) begin
			addr <= 0;
		end
		else if (read_ready) begin
			addr <= addr + 1; // if at max value, tosses MSB and loops back to 0

		end
	end // always_ff

    rom_1port rom (.address(addr), .clock(clk), .q(d_out));
    //assign d_out = '0; // for testing

endmodule // circuit 2
