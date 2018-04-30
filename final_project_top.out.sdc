## Generated SDC file "final_project_top.out.sdc"

## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus II License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 15.0.0 Build 145 04/22/2015 SJ Web Edition"

## DATE    "Mon Apr 30 00:07:07 2018"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {CLOCK_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]
create_clock -name {Pixel_Clk} -period 1.000 -waveform { 0.000 0.500 } [get_registers {Pixel_Clk}]
create_clock -name {PS2_KBCLK} -period 1.000 -waveform { 0.000 0.500 } [get_ports {PS2_KBCLK}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {vga_clk_instance|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 2 -master_clock {CLOCK_50} [get_pins {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {PS2_KBCLK}] -rise_to [get_clocks {CLOCK_50}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {PS2_KBCLK}] -fall_to [get_clocks {CLOCK_50}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {PS2_KBCLK}] -rise_to [get_clocks {CLOCK_50}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {PS2_KBCLK}] -fall_to [get_clocks {CLOCK_50}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {Pixel_Clk}] -rise_to [get_clocks {Pixel_Clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {Pixel_Clk}] -fall_to [get_clocks {Pixel_Clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {Pixel_Clk}] -rise_to [get_clocks {CLOCK_50}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {Pixel_Clk}] -fall_to [get_clocks {CLOCK_50}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {Pixel_Clk}] -rise_to [get_clocks {Pixel_Clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {Pixel_Clk}] -fall_to [get_clocks {Pixel_Clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {Pixel_Clk}] -rise_to [get_clocks {CLOCK_50}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {Pixel_Clk}] -fall_to [get_clocks {CLOCK_50}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {CLOCK_50}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {CLOCK_50}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {CLOCK_50}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {CLOCK_50}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {CLOCK_50}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {CLOCK_50}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {CLOCK_50}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {vga_clk_instance|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {CLOCK_50}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {PS2_KBCLK}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {PS2_KBCLK}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {Pixel_Clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {Pixel_Clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {PS2_KBCLK}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {PS2_KBCLK}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {Pixel_Clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {Pixel_Clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

