// Top level module for tasks 1 & 2
// specify inputs and outputs (including bit widths)

module DE1_SoC (CLOCK_50, CLOCK2_50, KEY, SW, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	input [9:0] SW; // new
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// logic
	logic read_ready, write_ready, read, write;
	logic [23:0] readdata_left, readdata_right;
	logic [23:0] writedata_left, writedata_right;
	logic reset;
	assign reset = ~KEY[0];

	/////////////////////////////////
	// task2
	logic [23:0] d_out;

	circuit2 rom_data (.clk(CLOCK_50), .reset(reset),
					   .read_ready(read_ready), .write_ready(write_ready), .d_out(d_out));


	/////////////////////////////////
	
	
	assign writedata_left = SW[9] ? d_out: readdata_left;
	assign writedata_right = SW[9] ? d_out: readdata_right;
	assign read = read_ready && write_ready;
	assign write = write_ready && read_ready;


/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule // DE1_SoC






// module DE1_SoC (CLOCK_50, CLOCK2_50, KEY, SW, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
// 		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

// 	input logic CLOCK_50, CLOCK2_50;
// 	input logic [0:0] KEY;
//     input logic [9:0] SW; // new
// 	// I2C Audio/Video config interface
// 	output logic FPGA_I2C_SCLK;
// 	inout logic FPGA_I2C_SDAT;
// 	// Audio CODEC
// 	output logic AUD_XCK;
// 	input logic AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
// 	input logic AUD_ADCDAT;
// 	output logic AUD_DACDAT;
	
// 	// Logic
// 	logic task_toggle;
//     assign task_toggle = SW[9];
// 	logic reset;
//     assign reset = ~KEY[0];

// 	logic task1_output, task2_output;

//     // instantiate task1 and task2 modules
// 	part1 task_1 (.CLOCK_50, .CLOCK2_50, .KEY, .FPGA_I2C_SCLK, .FPGA_I2C_SDAT, .AUD_XCK, 
// 		          .AUD_DACLRCK, .AUD_ADCLRCK, .AUD_BCLK, .AUD_ADCDAT, .AUD_DACDAT(task1_output));
//     task2 task_2 (.CLOCK_50, .CLOCK2_50, .KEY, .FPGA_I2C_SCLK, .FPGA_I2C_SDAT, .AUD_XCK, 
// 		          .AUD_DACLRCK, .AUD_ADCLRCK, .AUD_BCLK, .AUD_ADCDAT, .AUD_DACDAT(task2_output));

// 	assign AUD_DACDAT = task_toggle ? task2_output : task1_output;
  
// endmodule // DE1_SoC