// just the circuit portion of task2
// plays audio from mif file
// instantiate in task 
module circuit2 (clk, reset, read_ready, write_ready, d_out);

    input logic clk, reset, read_ready, write_ready;
    output logic [23:0] d_out;

    logic [15:0] addr; // 16 address bits needed for mif file

	logic write_ready_prev;

    // loop through all addresses
	always_ff @(posedge clk) begin
		if (reset) begin
			addr <= 0;
			write_ready_prev <= 0;
		end
		else begin
			write_ready_prev <= write_ready;

			if (read_ready && write_ready && !write_ready_prev)
				addr <= addr + 1; // if at max value, tosses MSB and loops back to 0

		end
	end // always_ff

    rom_1port rom (.address(addr), .clock(clk), .q(d_out));
    //assign d_out = '0; // for testing

endmodule // circuit 2



// module circuit2 (clk, reset, write_ready, d_out);

//     input logic clk, reset, write_ready;
//     output logic [23:0] d_out;

//     logic [15:0] addr; // 16 address bits needed for mif file

// 	logic write_ready_prev;

//     // need logic to loop through all addresses
// 	always_ff @(posedge clk) begin
// 		if (reset) begin
// 			addr <= 0;
// 			write_ready_prev <= 0;
// 		end
// 		else begin
// 			write_ready_prev <= write_ready;

// 			if (write_ready && !write_ready_prev)
// 				addr <= addr + 1; // if at max value, tosses MSB and loops back to 0

// 		end
// 	end // always_ff

//     rom_1port rom (.address(addr), .clock(clk), .q(d_out));
//     //assign d_out = '0; // for testing

// endmodule // circuit 2
