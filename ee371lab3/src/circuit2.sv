// Control circuit portion of task2, instantiated in task2.sv (top level for task2)
// Plays audio from memory, outputting audio samples from a ROM starting at 
// address 0 to the last address, and looping back again
// 24 bit output d_out from the ROM is used for the write_data assignments in task2.sv and the 
// unfiltered audio in task3_top
// 1 bit output enable is used as the enable signal in the FIR filter in task3_top
// 1 bit read_ready and write_ready input signals come from the audio CODEC in task2.sv or task3
// Runs on CLOCK_50

module circuit2 (clk, reset, read_ready, write_ready, enable, d_out);

    input logic clk, reset, read_ready, write_ready;
	output logic enable;
    output logic [23:0] d_out;

    logic [15:0] addr = '{default: '0}; // 16 address bits needed for mif file (ROM)

	// signals to help detect positive edges of read_ready and write_ready
	logic write_ready_prev, read_ready_prev; 

	// enabling condition for incrementing the address
	// both read_ready and write_ready are high AND at least one of them has a positive edge
	// ~48kHz
	assign enable = (read_ready && write_ready) && ((!write_ready_prev) | (!read_ready_prev));

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

			// need this condition because won't just overflow back to 0 
			// since 47794 isn't the largest number you can make with 16 address bits
			if (addr < 47794) begin 
				if (enable)
					addr <= addr + 1; 
			end
			else if (addr == 47794) begin
				if (enable)
					addr <= 0; 
			end
			else begin
				addr <= 0;
			end

		end
	end // always_ff

	// 1 port rom storing 1 secod worth of A4
	rom_1port rom (.address(addr), .clock(clk), .q(d_out));

endmodule // circuit 2


///////////////////////////////////////////////////////////////////////
// past versions
///////////////////////////////////////////////////////////////////////
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