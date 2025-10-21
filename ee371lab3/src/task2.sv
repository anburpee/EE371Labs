// task2 module 
// output the values stored in the 1 port ROM sequencially to the Audio CODEC,
// looping back to the start when you reach the end
// increment the address only once each time you write

// aya -IDK WHAT THE FUCK I'M DOING 
// aya - i started with a blank task2 file and just copied
// & pasted everything fomr part1.v -- i think we just need to
// change the control circuit portion

module task2 (CLOCK_50, CLOCK2_50, KEY, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

	input logic CLOCK_50, CLOCK2_50;
	input logic [0:0] KEY;
	// I2C Audio/Video config interface
	output logic FPGA_I2C_SCLK;
	inout wire FPGA_I2C_SDAT;
	// Audio CODEC
	output logic AUD_XCK;
	input logic AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input logic AUD_ADCDAT;
	output logic AUD_DACDAT;
	
	// Logic -- changed from wire
	logic read_ready, write_ready, read, write;
	logic [23:0] readdata_left, readdata_right;
	logic [23:0] writedata_left, writedata_right;
	logic reset;
	assign reset = ~KEY[0];

	/////////////////////////////////
	// aya --- control circuit logic
	/////////////////////////////////

	logic [23:0] d_out;

	circuit2 rom_data (.clk(CLOCK_50), .reset(reset), .read_ready(read_ready), .d_out(d_out));


    // aya - output of rom should be played from both channels, left and right
    // (no difference between what's played from either speaker)
    // assign readdata_left = ; // don't need since not reading in data from microphone
    // assign readdata_right = ; // don't need since not reading in data from microphone

    // aya - does this need to be synchronous?
	// or can we just connect them by wires since the ROM is reading data
	// synchronously already?
    assign writedata_left = d_out;
    assign writedata_right = d_out;
    assign read = read_ready && write_ready; // = 1'b0?
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

endmodule // task2
