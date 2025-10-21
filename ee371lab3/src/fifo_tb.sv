/* Testbench for Homework 3 Problem 1 */
module fifo_tb ();
	logic clk, reset, rd, wr;
	logic empty, full;
	logic [8-1:0] w_data; // set DATA_WIDTH to 8 for testbench
	logic [8-1:0] r_data;

	// instantiace fifo
	// DATA_WIDTH=8, ADDR_WIDTH=4 (16 different addresses) -- default
	fifo dut (.*);

	// set up clock
	parameter period = 100;
	initial begin
		clk <= 0;
		forever #(period/2) clk <= ~clk;
	end // initial clock

	// test the device
	integer i;
	initial begin

		reset <= 1'b1; 		@(posedge clk);
		reset <= 1'b0;		
		wr <= 1'b1;		rd <= 1'b0;		
		$display("------------wr = high, rd = low-----------");
		// write only until make buffer is full
		// should see on_left go high before full goes high
		for (i = 0; i < 16; i++) begin	
			w_data <= 8'b11110000; 	@(posedge clk);
			$display("w_data: %b  r_data: %b  empty: %b  full: %b",
					 w_data, r_data, empty, full);
		end

		// one more clock edge to update signals
		wr <= 1'b0; 	@(posedge clk);
		$display("w_data: %b  r_data: %b  empty: %b  full: %b",
					 w_data, r_data, empty, full);

		//see what's stored in register file
		$display("Array contents:");
		for (i = 0; i < 16; i++) begin
			$display("%b", dut.r_unit.array_reg[i]); 
		end

		// ------------------------edge case: check you can't write new data when full -------------------------
		// ONLY write
		wr <= 1'b1;		rd <= 1'b0;
		w_data <= 8'b10101010; 	@(posedge clk);
		@(posedge clk); // for signals to update
		$display("---------tried to ONLY write data when full-----------");
		$display("w_data: %b  r_data: %b  empty: %b  full: %b",
					 w_data, r_data, empty, full);

		//see what's stored in register file -- should be unchanged
		$display("Array contents (should be unchanged):");
		for (i = 0; i < 16; i++) begin
			$display("%b", dut.r_unit.array_reg[i]); 
		end

		// read and write
		rd <= 1'b1;
		w_data <= 8'b10101010; 	@(posedge clk);
		wr <= 1'b0;		rd <= 1'b0;
		@(posedge clk); // for signals to update
		$display("---------tried to read and write data when full-----------");
		$display("w_data: %b  r_data: %b  empty: %b  full: %b",
					 w_data, r_data, empty, full);
		

		//see what's stored in register file -- SHOULD CHANGE
		$display("Array contents (SHOULD CHANGE):");
		for (i = 0; i < 16; i++) begin
			$display("%b", dut.r_unit.array_reg[i]); 
		end

		// now read out all the data
		// should see one_left after reading from the first address
		// should see empty go high after reading out all the data
		// rd <= 1'b0;
		$display("------------wr = low, rd = toggling-----------");
		wr <= 1'b0; 	rd <= 1'b0;
		for (i = 0; i < 16; i++) begin
			$display("w_data: %b  r_data: %b  empty: %b  full: %b",
					 w_data, r_data, empty, full);
			rd <= 1'b1; @(posedge clk);
			rd <= 1'b0; @(posedge clk);
		end
		
		@(posedge clk);
		$display("w_data: %b  r_data: %b  empty: %b  full: %b",
					 w_data, r_data, empty, full);

		// see what's store in register file
		$display("Array contents:");
		for (i = 0; i < 16; i++) begin
			$display("%b", dut.r_unit.array_reg[i]); 
		end
		
		$stop; // stop simultion
	end  // initial
	
endmodule  // fifo_tb

