// pulses for 1 clock cycle every 1042 cyles of CLOCK_50
// i.e. creates a pulse at a frequency of 48kHz
module enable_48khz (clk, reset, enable);
    input logic clk, reset;
    output logic enable;

    logic [10:0] count = '{default: '0}; // need 1 bits to represent 1042 (number of 50Mhz clock within between 48khz clock)

    always_ff @(posedge clk) begin
        if (reset) begin
            enable <= 0;
            count <= 0;
        end
        else if (count == 1041) begin
            count <= 0;
            enable <= 1;
        end
        else begin
            count <= count + 1;
            enable <= 0;
        end
    end // always_ff

endmodule // enable_48khz