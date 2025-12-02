// determines input RGB values for video_driver.sv based on the (x, y) coordinates that video_driver.sv outputs

module display_update (input logic clk,
                       input logic reset,
                       input logic x,
                       input logic y,
                       output logic r,
                       output logic g,
                       output logic b
                       );