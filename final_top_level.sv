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
	output logic [7:0] LEDG,
	input logic [7:0] SW,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

enum logic [7:0] {
	Sphere0_0,
	Sphere0_1,
	Sphere1_0,
	Sphere1_1,
	Sphere2_0,
	Sphere2_1,
	Sphere3_0,
	Sphere3_1,
	Map_col,
	Write} State, State_n;

logic Collision, WritePixel, Frame_Clk, Frame_Clk_n;
vector Curr_Sphere_pos, Cast_Ray, Cast_Ray_n;
color Write_col;
color Sphere_col;
logic [9:0] DrawX, DrawY, WriteX, WriteY, WriteX_n, WriteY_n, WriteX_inc, WriteY_inc;
logic [15:0] Score, Lives;
logic [3:0] Dropped;
logic Pause, endGame;

fixed_real Best_Dist, Best_Dist_n, Curr_Dist, Theta, Phi;

logic [1:0] Read_Sphere_in, Best_in, Best_in_n, Curr_Sphere_in;

color Best_col, Best_col_n;

logic Click, Hit;
logic [1:0] Hit_in;
	
sphere_reg_4 sph4(.Clk(CLOCK_50),.Frame_Clk(Frame_Clk & ~Pause),.Reset(~KEY[0]),.Hit(Hit),.Hit_index(Hit_in),.Read_index(Read_Sphere_in),.Sphere_pos(Curr_Sphere_pos),.Sphere_col(Sphere_col),.curr_index(Curr_Sphere_in),.dropped(Dropped));
	
color_mapper colmap(.is_ball(Best_Dist != 64'hefffffffffffffff), .DrawX(WriteX), .DrawY(WriteY), .colin(Best_col), .col(Write_col), .zcomp(Cast_Ray[2]),.endGame(endGame),.Pause(Pause),.Clk(CLOCK_50));

collision_detection cd(.sphere(Curr_Sphere_pos), .ray(Cast_Ray), .tbest(Best_Dist), .tnew(Curr_Dist), .Collision(Collision));

VGA_controller vga(.Clk(CLOCK_50), .Reset(~KEY[0]), .*);

frame_buffer fb(.Clk(CLOCK_50), .Write(WritePixel), .*, .WriteColor(Write_col), .ReadColor({VGA_B, VGA_G, VGA_R}));

increment_write iw(.*);


vector dxcx, dycy, dxcy, sv_raw, sv_norm, Camera_Ray, CameraX, CameraY, dxcx_n, dycy_n, Cam_scale_out, Cam_dim;

normalize_vector nvsv(.a(sv_raw),.b(sv_norm));

fixed_real WriteX_scale, WriteY_scale, Cam_scale;

assign WriteX_scale = {22'd0,WriteX_inc,32'd0} - (64'd320 << 32);

assign WriteY_scale = {22'd0,WriteY_inc,32'd0} - (64'd240 << 32);

dot_product_scale dpsx(.a({Cam_scale,Cam_scale,Cam_scale}),.b(Cam_dim),.s(Cam_scale_out));

add_vector av0(.a(dxcx),.b(dycy),.c(dxcy));

add_vector av1(.a(dxcy),.b(Camera_Ray),.c(sv_raw));

vga_clk vga_clk_instance(.inclk0(CLOCK_50), .c0(VGA_CLK));

hit_detection hd(.*,.Clk(CLOCK_50));

score_handler sh(.Clk(CLOCK_50),.Reset(~KEY[0]),.*,.gameOver(endGame));

hexdriver h0(.In(Score[3:0]),.Out(HEX0));
hexdriver h1(.In(Score[7:4]),.Out(HEX1));
hexdriver h2(.In(Score[11:8]),.Out(HEX2));
hexdriver h3(.In(Score[15:12]),.Out(HEX3));

hexdriver h4(.In(Lives[3:0]),.Out(HEX4));
hexdriver h5(.In(Lives[7:4]),.Out(HEX5));


logic [8:0] mouse_dx, mouse_dy;
logic mouse_m1, mouse_packet, mouse_m2;
logic [7:0] test_state;

ps2_mouse_controller ps2m(.Clk(CLOCK_50), .Reset(~KEY[0] || ~KEY[1]),.PS2_MSCLK(PS2_KBCLK),.PS2_MSDAT(PS2_KBDAT),.Mouse_LeftClick(mouse_m1),.Mouse_RightClick(mouse_m2),.Mouse_dx(mouse_dx),.Mouse_dy(mouse_dy),.packetReceived(mouse_packet));

input_handler ih(.*,.Reset(~KEY[0]),.Clk(CLOCK_50),.m1(mouse_m1),.m2(mouse_m2),.m3(),.dx(mouse_dx),.dy(mouse_dy),.new_data(mouse_packet),.sensitivity({24'd0,SW,32'd0}),.gameOver(endGame));

assign LEDG[2] = 1'b1;
assign LEDG[0] = mouse_m1;
assign LEDG[1] = mouse_packet;
assign LEDR[17:9] = mouse_dx;
assign LEDR[8:0] = mouse_dy;


always_ff @ (posedge CLOCK_50 or negedge KEY[0]) begin
	if(~KEY[0])begin
		State <= Sphere0_0;
		Best_Dist <= 64'hefffffffffffffff;
		Best_col <= 24'h000000;
		Best_in <= 2'b00;
		WriteX <= 10'd0;
		WriteY <= 10'd0;
		Frame_Clk <= 1'b1;
		Cast_Ray <= 192'b0;
		dxcx <= 192'b0;
		dycy <= 192'b0;
	end else begin
		State <= State_n;
		Best_Dist <= Best_Dist_n;
		Best_col <= Best_col_n;
		Best_in <= Best_in_n;
		WriteX <= WriteX_n;
		WriteY <= WriteY_n;
		Frame_Clk <= Frame_Clk_n;
		Cast_Ray <= Cast_Ray_n;
		dxcx <= dxcx_n;
		dycy <= dycy_n;
	end
end

always_comb begin
	State_n = State;
	WriteX_n = WriteX;
	WriteY_n = WriteY;
	Best_in_n = Best_in;
	Best_col_n = Best_col;
	Best_Dist_n = Best_Dist;
	Read_Sphere_in = 2'd0;
	WritePixel = 1'b0;
	Frame_Clk_n = Frame_Clk;
	Cast_Ray_n = Cast_Ray;
	dxcx_n = dxcx;
	dycy_n = dycy;
	Cam_scale = 64'b0;
	Cam_dim = 192'b0;
	case (State)
		Sphere0_0: begin
			State_n = Sphere0_1;
			Read_Sphere_in = 2'b00;
			Best_Dist_n = 64'hefffffffffffffff;
			Cam_scale = WriteX_scale;
			Cam_dim = CameraX;
			dxcx_n = Cam_scale_out;
		end
		Sphere0_1: begin
			State_n = Sphere1_0;
			Read_Sphere_in = 2'b01;
			if(Collision && ~Curr_Dist[63] && Curr_Dist < Best_Dist) begin
				Best_Dist_n = Curr_Dist;
				Best_col_n = Sphere_col;
				Best_in_n = Curr_Sphere_in;
			end
			Cam_scale = WriteY_scale;
			Cam_dim = CameraY;
			dycy_n = Cam_scale_out;
		end
		Sphere1_0: begin
			State_n = Sphere1_1;
			Read_Sphere_in = 2'b01;
		end
		Sphere1_1: begin
			State_n = Sphere2_0;
			Read_Sphere_in = 2'b10;
			if(Collision && ~Curr_Dist[63] && Curr_Dist < Best_Dist) begin
				Best_Dist_n = Curr_Dist;
				Best_col_n = Sphere_col;
				Best_in_n = Curr_Sphere_in;
			end
		end
		Sphere2_0: begin
			State_n = Sphere2_1;
			Read_Sphere_in = 2'b10;
		end
		Sphere2_1: begin
			State_n = Sphere3_0;
			Read_Sphere_in = 2'b11;
			if(Collision && ~Curr_Dist[63] && Curr_Dist < Best_Dist) begin
				Best_Dist_n = Curr_Dist;
				Best_col_n = Sphere_col;
				Best_in_n = Curr_Sphere_in;
			end
		end
		Sphere3_0: begin
			State_n = Sphere3_1;
			Read_Sphere_in = 2'b11;
		end
		Sphere3_1: begin
			State_n = Map_col;
			if(Collision && ~Curr_Dist[63] && Curr_Dist < Best_Dist) begin
				Best_Dist_n = Curr_Dist;
				Best_col_n = Sphere_col;
				Best_in_n = Curr_Sphere_in;
			end
		end
		Map_col: begin
			State_n = Write;
		end
		Write: begin
			State_n = Sphere0_0;
			WritePixel = 1'b1;
			WriteX_n = WriteX_inc;
			WriteY_n = WriteY_inc;
			Cast_Ray_n = sv_norm;
			Read_Sphere_in = 2'b00;
			if(WriteX_inc == 10'd638 && WriteY_inc == 10'd479) begin
				Frame_Clk_n = 1'b1;
			end else begin
				Frame_Clk_n = 1'b0;
			end
		end
	endcase
	
end

endmodule
