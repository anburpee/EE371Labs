// Top level module for tasks 1 & 2
// specify inputs and outputs (including bit widths)

module task3_top (CLOCK_50, CLOCK2_50, KEY, SW, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
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
	
	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];

	/////////////////////////////////
	// task2
	logic en_48;

	enable_48khz en (.clk(CLOCK_50), .reset(reset), .enable(en_48));

	logic [23:0] d_out;

	circuit2 rom_data (.clk(en_48), .reset(reset), .d_out(d_out));
	/////////////////////////////////
	
    logic [23:0] unfiltered_left, unfiltered_right, filtered_left, filtered_right;

    assign unfiltered_left = SW[9] ? d_out : readdata_left;
	assign unfiltered_right = SW[9] ? d_out : readdata_right;

    // use status signals as enables for FIR
    fir #(.D_WIDTH(24), .N(32)) fir_left (.clk(CLOCK_50), .reset(reset),
            .enable(read_ready && write_ready),
            .data_in(unfiltered_left), .data_out(filtered_left));

    fir #(.D_WIDTH(24), .N(32)) fir_right (.clk(CLOCK_50), .reset(reset),
            .enable(read_ready && write_ready),
            .data_in(unfiltered_right), .data_out(filtered_right));
	
	assign writedata_left = SW[8] ? filtered_left : unfiltered_left;
	assign writedata_right = SW[8] ? filtered_right : unfiltered_right;


	assign read = read_ready && write_ready;
	assign write = read_ready && write_ready;


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

endmodule // task3_top