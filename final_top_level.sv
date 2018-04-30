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
	input logic [7:0] SW
);

enum logic [7:0] {
	Setup0,
	Setup1,
	Setup2,
	Sphere0_0,
	Sphere0_1,
	Sphere1_0,
	Sphere1_1,
	Sphere2_0,
	Sphere2_1,
	Sphere3_0,
	Sphere3_1,
	Write} State, State_n;

logic Collision, WritePixel, Frame_Clk, Frame_Clk_n;
vector Curr_Sphere_pos, Cast_Ray;
color Write_col;
color Sphere_col;
logic [9:0] DrawX, DrawY, WriteX, WriteY, WriteX_n, WriteY_n, WriteX_inc, WriteY_inc;

fixed_real dPhi, dTheta, Best_Dist, Best_Dist_n, Curr_Dist, Theta, Phi;

logic [1:0] Read_Sphere_in, Best_in, Best_in_n, Curr_Sphere_in;

color Best_col, Best_col_n;

logic Click, Hit;
logic [1:0] Hit_in;
	
sphere_reg_4 sph4(.Clk(CLOCK_50),.Frame_Clk(Frame_Clk),.Reset(~KEY[0]),.Hit(Hit),.Hit_index(Hit_in),.Read_index(Read_Sphere_in),.Sphere_pos(Curr_Sphere_pos),.Sphere_col(Sphere_col),.curr_index(Curr_Sphere_in));
	
color_mapper colmap(.is_ball(Best_Dist != 64'hefffffffffffffff), .DrawX(WriteX), .DrawY(WriteY), .colin(Best_col), .col(Write_col), .phi(Phi + dPhi));

collision_detection cd(.sphere(Curr_Sphere_pos), .ray(Cast_Ray), .tbest(Best_Dist), .tnew(Curr_Dist), .Collision(Collision));

VGA_controller vga(.Clk(CLOCK_50), .Reset(~KEY[0]), .*);

frame_buffer fb(.Clk(CLOCK_50), .Write(WritePixel), .*, .WriteColor(Write_col), .ReadColor({VGA_B, VGA_G, VGA_R}));

increment_write iw(.*);

ang_lut al(.Clk(CLOCK_50), .WriteY(WriteY), .WriteX(WriteX),.dTheta(dTheta), .dPhi(dPhi));

ray_lut rl(.Clk(CLOCK_50), .theta(Theta + dTheta), .phi(Phi + dPhi), .ray(Cast_Ray));

vga_clk vga_clk_instance(.inclk0(CLOCK_50), .c0(VGA_CLK));

hit_detection hd(.*,.Clk(CLOCK_50));

logic [8:0] mouse_dx, mouse_dy;
logic mouse_m1, mouse_packet;
logic [7:0] test_state;

ps2_mouse_controller ps2m(.Clk(CLOCK_50), .Reset(~KEY[0]),.PS2_MSCLK(PS2_KBCLK),.PS2_MSDAT(PS2_KBDAT),.Mouse_LeftClick(mouse_m1),.Mouse_dx(mouse_dx),.Mouse_dy(mouse_dy),.packetReceived(mouse_packet));

input_handler ih(.*,.Reset(~KEY[0]),.Clk(CLOCK_50),.m1(mouse_m1),.m2(),.m3(),.dx(mouse_dx),.dy(mouse_dy),.new_data(mouse_packet),.sensitivity({24'd0,SW,32'd0}));

assign LEDG[2] = 1'b1;
assign LEDG[0] = mouse_m1;
assign LEDG[1] = mouse_packet;
assign LEDR[17:9] = mouse_dx;
assign LEDR[8:0] = mouse_dy;


always_ff @ (posedge CLOCK_50 or negedge KEY[0]) begin
	if(~KEY[0])begin
		State <= Setup0;
		Best_Dist <= 64'hefffffffffffffff;
		Best_col <= 24'h000000;
		Best_in <= 2'b00;
		WriteX <= 10'd0;
		WriteY <= 10'd0;
		Frame_Clk <= 1'b1;
	end else begin
		State <= State_n;
		Best_Dist <= Best_Dist_n;
		Best_col <= Best_col_n;
		Best_in <= Best_in_n;
		WriteX <= WriteX_n;
		WriteY <= WriteY_n;
		Frame_Clk <= Frame_Clk_n;
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
	Frame_Clk_n = 1'b0;
	case (State)
		Setup0: begin
			State_n = Setup1;
		end
		Setup1: begin
			State_n = Setup2;
		end
		Setup2: begin
			State_n = Sphere0_0;
			Read_Sphere_in = 2'b00;
		end
		Sphere0_0: begin
			State_n = Sphere0_1;
			Read_Sphere_in = 2'b00;
			Best_Dist_n = 64'hefffffffffffffff;
		end
		Sphere0_1: begin
			State_n = Sphere1_0;
			Read_Sphere_in = 2'b01;
			if(Collision && ~Curr_Dist[63] && Curr_Dist < Best_Dist) begin
				Best_Dist_n = Curr_Dist;
				Best_col_n = Sphere_col;
				Best_in_n = Curr_Sphere_in;
			end
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
			State_n = Write;
			if(Collision && ~Curr_Dist[63] && Curr_Dist < Best_Dist) begin
				Best_Dist_n = Curr_Dist;
				Best_col_n = Sphere_col;
				Best_in_n = Curr_Sphere_in;
			end
		end
		Write: begin
			State_n = Setup0;
			WritePixel = 1'b1;
			WriteX_n = WriteX_inc;
			WriteY_n = WriteY_inc;
		end
	endcase
	if(WriteX_inc == 10'b0 && WriteY_inc == 10'b0) begin
		Frame_Clk_n = 1'b1;
	end
end

endmodule
