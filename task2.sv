// task2 module 
// output the values stored in the 1 port ROM sequencially to the Audio CODEC,
// looping back to the start when you reach the end
// increment the address only once each time you write

// IDK WHAT THE FUCK I'M DOING 
module task2 (clk, addr, d_out);
    input logic clk;
    input logic [17:0] addr;
    output logic [23:0] d_out;

    rom_1_port rom (.address(addr), .clock(clk), .q(d_out));

endmodule
