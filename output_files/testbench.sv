typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module testbench();

timeprecision 10ns;
timeunit 10ns;

logic CLOCK_50;
logic [3:0] KEY;
logic [7:0] VGA_R, VGA_G, VGA_B;
logic VGA_CLK, VGA_SYNC_N, VGA_BLANK_N, VGA_VS, VGA_HS;
logic PS2_KBCLK, PS2_KBDAT;

//final_top_level ftl(.*);

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

module random_testbench();

timeprecision 1ns;
timeunit 10ns;

logic Clk, Reset;
fixed_real random;

rand_lut rl(.*);

initial begin
Clk = 1'b1;
end

always begin
#1 Clk = ~Clk;
end

initial begin
Reset = 1'b1;
#4 Reset = 1'b0;
end

endmodule
