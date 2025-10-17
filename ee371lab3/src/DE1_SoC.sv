// Top level module for tasks 1 & 2
// specify inputs and outputs (including bit widths)

module DE1_SoC (CLOCK_50, CLOCK2_50, KEY, SW, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

	input logic CLOCK_50, CLOCK2_50;
	input logic [0:0] KEY;
    input logic [9:0] SW; // new
	// I2C Audio/Video config interface
	output logic FPGA_I2C_SCLK;
	inout logic FPGA_I2C_SDAT;
	// Audio CODEC
	output logic AUD_XCK;
	input logic AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input logic AUD_ADCDAT;
	output logic AUD_DACDAT;
	
	// Logic
	logic task_toggle;
    assign task_toggle = SW[9];
	logic reset;
    assign reset = ~KEY[0];

	logic task1_output, task2_output;

    // instantiate task1 and task2 modules
	part1 task_1 (.CLOCK_50, .CLOCK2_50, .KEY, .FPGA_I2C_SCLK, .FPGA_I2C_SDAT, .AUD_XCK, 
		          .AUD_DACLRCK, .AUD_ADCLRCK, .AUD_BCLK, .AUD_ADCDAT, .AUD_DACDAT(task1_output));
    task2 task_2 (.CLOCK_50, .CLOCK2_50, .KEY, .FPGA_I2C_SCLK, .FPGA_I2C_SDAT, .AUD_XCK, 
		          .AUD_DACLRCK, .AUD_ADCLRCK, .AUD_BCLK, .AUD_ADCDAT, .AUD_DACDAT(task2_output));

	assign AUD_DACDAT = SW[9] ? task2_output : task1_output;
  
endmodule // DE1_SoC