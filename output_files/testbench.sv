typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module testbench();

timeprecision 10ns;
timeunit 10ns;

logic CLOCK_50;
logic [3:0] KEY;
wire PS2_KBCLK, PS2_KBDAT;
 logic [7:0] VGA_R, VGA_G, VGA_B;
 logic VGA_CLK, VGA_SYNC_N, VGA_BLANK_N, VGA_VS, VGA_HS;
 logic [17:0] LEDR;
 logic [7:0] LEDG;
logic [7:0] SW;
 logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
 
final_top_level ftl(.*);

initial begin
CLOCK_50 = 1'b1;
end

always begin
#1 CLOCK_50 = ~CLOCK_50;
end

initial begin
KEY = 4'b1111;
#8 KEY = 4'b1110;
#8 KEY = 4'b1111;
end

endmodule

