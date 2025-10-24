// circuit portion of task2
// plays audio from mif file
// instantiated in task2 (top level)
// clk is set to be the 48kHz enable so that data is read from the ROM at
// the same rate as the sampling frequency of the audio CODEC

// module circuit2 (clk, reset, d_out);

//     input logic clk, reset;
//     output logic [23:0] d_out;

//     logic [15:0] addr; // 16 address bits needed for mif file

//     // loop through all addresses
// 	always_ff @(posedge clk) begin
// 		if (reset) begin
// 			addr <= 0;
// 		end
// 		else begin
// 			if (addr < 48000) // lenth of mif file
// 				addr <= addr + 1; 
// 			else
// 				addr <= 0;
// 		end
// 	end // always_ff

//     rom_1port rom (.address(addr), .clock(clk), .q(d_out));
//     //assign d_out = '0; // for testing

// endmodule // circuit 2


module circuit2 (clk, reset, read_ready, write_ready, d_out);

    input logic clk, reset, read_ready, write_ready;
    output logic [23:0] d_out;

    logic [15:0] addr; // 16 address bits needed for mif file

	logic write_ready_prev, read_ready_prev; // signals to help detect positive edges

    // loop through all addresses
	always_ff @(posedge clk) begin
		if (reset) begin
			addr <= 0;
			write_ready_prev <= 0;
			read_ready_prev <= 0;
		end
		else begin
			write_ready_prev <= write_ready;
			read_ready_prev <= read_ready;
			if (addr < 48000) begin
				// if read_ready has a positive edge or write_ready as a positive edge or both
				if ((read_ready && write_ready) && ((!write_ready_prev) | (!read_ready_prev)))
					addr <= addr + 1; 
			end
			else begin
				addr <= 0;
			end
		end
	end // always_ff

    rom_1port rom (.address(addr), .clock(clk), .q(d_out));
    //assign d_out = '0; // for testing

endmodule // circuit 2



// module circuit2 (clk, reset, read_ready, write_ready, d_out);

//     input logic clk, reset, read_ready, write_ready;
//     output logic [23:0] d_out;

//     logic [15:0] addr; // 16 address bits needed for mif file

// 	logic write_ready_prev;

//     // loop through all addresses
// 	always_ff @(posedge clk) begin
// 		if (reset) begin
// 			addr <= 0;
// 			write_ready_prev <= 0;
// 		end
// 		else begin
// 			write_ready_prev <= write_ready;

// 			if (read_ready && write_ready && !write_ready_prev)
// 				addr <= addr + 1; 
// 		end
// 	end // always_ff

//     rom_1port rom (.address(addr), .clock(clk), .q(d_out));
//     //assign d_out = '0; // for testing

// endmodule // circuit 2



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
// 				addr <= addr + 1; 
// 		end
// 	end // always_ff

//     rom_1port rom (.address(addr), .clock(clk), .q(d_out));
//     //assign d_out = '0; // for testing

// endmodule // circuit 2
