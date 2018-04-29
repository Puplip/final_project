typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module final_top_level (
	input logic CLOCK_50,
	input logic [3:0] KEY,
	inout wire PS2_KBCLK, PS2_KBDAT,
	output logic [7:0] VGA_R, VGA_G, VGA_B,      
	output logic VGA_CLK, VGA_SYNC_N, VGA_BLANK_N, VGA_VS, VGA_HS,
	output logic [17:0] LEDR,
	output logic [7:0] LEDG
);

enum logic [7:0] {
	Setup0,
	Setup1,
	Sphere0_0,
	Sphere0_1,
	Sphere1_0,
	Sphere1_1,
	Sphere2_0,
	Sphere2_1,
	Sphere3_0,
	Sphere3_1,
	Write} State, State_n;

logic Pixel_Clk, Collision, WritePixel, Frame_Clk;
vector Curr_Sphere_pos, Cast_Ray;
color Write_col;
color [3:0] Sphere_col;
logic [9:0] DrawX, DrawY, WriteX, WriteY;

fixed_real dPhi, dTheta, Best_Dist, Best_Dist_n, Curr_Dist, Theta, Phi;

logic [1:0] Read_Sphere_in, Best_in, Best_in_n, Curr_Sphere_in;

logic Click, Hit;
logic [1:0] Hit_in;
	
sphere_reg_4 sph4(.Clk(CLOCK_50),.Frame_Clk(Frame_Clk),.Reset(~KEY[0]),.Hit(Hit),.Hit_index(Hit_in),.Read_index(Read_Sphere_in),.Sphere_pos(Curr_Sphere_pos),.Sphere_col(Sphere_col),.curr_index(Curr_Sphere_in));
	
color_mapper colmap(.is_ball(Best_Dist != 64'hefffffffffffffff), .DrawX(WriteX), .DrawY(WriteY), .colin(Sphere_col[Best_in]), .col(Write_col));

collision_detection cd(.sphere(Curr_Sphere_pos), .ray(Cast_Ray), .tbest(Best_Dist), .tnew(Curr_Dist), .Collision(Collision));

VGA_controller vga(.Clk(CLOCK_50), .Reset(~KEY[0]), .*);

frame_buffer fb(.Clk(CLOCK_50), .Write(WritePixel), .*, .WriteColor(Write_col), .ReadColor({VGA_B, VGA_G, VGA_R}));

increment_write iw(.Clk(Pixel_Clk), .Reset(~KEY[0]), .*);

ang_lut al(.Clk(CLOCK_50), .WriteY(WriteY), .WriteX(WriteX),.dTheta(dTheta), .dPhi(dPhi));

ray_lut rl(.Clk(CLOCK_50), .theta(Theta + dTheta), .phi(Phi + dPhi), .ray(Cast_Ray));

vga_clk vga_clk_instance(.inclk0(CLOCK_50), .c0(VGA_CLK));

hit_detection hd(.*,.Clk(CLOCK_50));

logic [8:0] mouse_dx, mouse_dy;
logic mouse_m1, mouse_packet;
logic [7:0] test_state;

ps2_mouse_controller ps2m(.Clk(CLOCK_50), .Reset(~KEY[0]),.PS2_MSCLK(PS2_KBCLK),.PS2_MSDAT(PS2_KBDAT),.Mouse_LeftClick(mouse_m1),.Mouse_dx(mouse_dx),.Mouse_dy(mouse_dy),.packetReceived(mouse_packet));

input_handler ih(.*,.Reset(~KEY[0]),.Clk(CLOCK_50),.m1(mouse_m1),.m2(),.m3(),.dx(mouse_dx),.dy(mouse_dy),.new_data(mouse_packet));

assign LEDG[2] = 1'b1;
assign LEDG[0] = mouse_m1;
assign LEDG[1] = mouse_packet;
assign LEDR[17:9] = mouse_dx;
assign LEDR[7:0] = test_state;


always_ff @ (posedge CLOCK_50 or negedge KEY[0]) begin
	if(~KEY[0])begin
		State = Setup0;
	end else begin
		State = State_n;
		case (State_n)
			Setup0: Pixel_Clk <= 1'b1;
			Setup1: Pixel_Clk <= 1'b01;
			Sphere0_0: Pixel_Clk <= 1'b0;
			Sphere0_1: Pixel_Clk <= 1'b0;
			Sphere1_0: Pixel_Clk <= 1'b0;
			Sphere1_1: Pixel_Clk <= 1'b0;
			Sphere2_0: Pixel_Clk <= 1'b0;
			Sphere2_1: Pixel_Clk <= 1'b0;
			Sphere3_0: Pixel_Clk <= 1'b0;
			Sphere3_1: Pixel_Clk <= 1'b0;
			Write: Pixel_Clk <= 1'b0;
		endcase
		case (State_n)
			Setup0: Best_Dist <= 64'hefffffffffffffff;
			Sphere1_0: Best_Dist <= Best_Dist_n;
			Sphere2_0: Best_Dist <= Best_Dist_n;
			Sphere3_0: Best_Dist <= Best_Dist_n;
			Write: Best_Dist <= Best_Dist_n;
		endcase
		case (State_n)
			Setup0: Best_in <= 2'b0;
			Sphere1_0: Best_in <= Best_in_n;
			Sphere2_1: Best_in <= Best_in_n;
			Sphere3_1: Best_in <= Best_in_n;
			Write: Best_in <= Best_in_n;
		endcase
	end
end

always_comb begin
	State_n = State;
	WritePixel = 0;
	case (State)
		Setup0: begin
			State_n = Setup1;
			Read_Sphere_in = 2'd0;
		end
		Setup1: begin
			State_n = Sphere0_0;
			Read_Sphere_in = 2'd0;
		end
		Sphere0_0: begin
			State_n = Sphere0_1;
			Read_Sphere_in = 2'd0;
		end
		Sphere0_1: begin
			State_n = Sphere1_0;
			Read_Sphere_in = 2'd1;
		end
		Sphere1_0: begin
			State_n = Sphere1_1;
			Read_Sphere_in = 2'd1;
		end
		Sphere1_1: begin
			State_n = Sphere2_0;
			Read_Sphere_in = 2'd2;
		end
		Sphere2_0: begin
			State_n = Sphere2_1;
			Read_Sphere_in = 2'd2;
		end
		Sphere2_1: begin
			State_n = Sphere3_0;
			Read_Sphere_in = 2'd3;
		end
		Sphere3_0: begin
			State_n = Sphere3_1;
			Read_Sphere_in = 2'd3;
		end
		Sphere3_1: begin
			State_n = Write;
			Read_Sphere_in = 2'd0;
		end
		Write: begin
			State_n = Setup0;
			WritePixel = 1;
			Read_Sphere_in = 2'd0;
		end
	endcase

	if(Best_Dist > Curr_Dist && Collision)	begin
		Best_Dist_n = Curr_Dist;
		Best_in_n = Curr_Sphere_in;
	end
	else begin
		Best_Dist_n = Best_Dist;
		Best_in_n = Best_in;
	end
end

endmodule
