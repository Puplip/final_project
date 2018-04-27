typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module final_top_level (
	input logic CLOCK_50,
	input logic [3:0] KEY,
	output logic [7:0] VGA_R, VGA_G, VGA_B,      
	output logic VGA_CLK, VGA_SYNC_N, VGA_BLANK_N, VGA_VS, VGA_HS
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

logic reset_clk, collide, WritePixel;
vector spherepos, lookray;
color colorout;
color [3:0] spherecol;
logic [9:0] DrawX, DrawY, WriteX, WriteY;

fixed_real dPhi, dTheta, tbest, tbest_n, tcurr;

logic [1:0] next_sphere, best_in, best_in_n, curr_sphere;

logic click, hit;
logic [1:0] hit_index;

assign click = 1'b0;


/*sphere_reg firstsph(.Frame_Clk(VGA_VS), .nextcol({8'hff, 8'hff, 8'hff}), .nextpos({64'd0, 64'd304 << 32, 64'd0}),
	.currentpos(sphere1pos), .currentcol(sphere1col));*/
	
sphere_reg_4 sph4(.Clk(CLOCK_50),.Frame_Clk(VGA_VS),.Reset(~KEY[0]),.Hit(hit),.Hit_index(hit_index),.Read_index(next_sphere),.Sphere_pos(spherepos),.Sphere_col(spherecol),.curr_index(curr_sphere));
	
color_mapper colmap(.is_ball(tbest != 64'hefffffffffffffff), .DrawX(WriteX), .DrawY(WriteY), .colin(spherecol[best_in]), .col(colorout));

collision_detection cd(.sphere(spherepos), .ray(lookray), .tbest(tbest), .tnew(tcurr), .collide(collide));

VGA_controller vga(.Clk(CLOCK_50), .Reset(~KEY[0]), .*);

frame_buffer fb(.Clk(CLOCK_50), .Write(WritePixel), .*, .WriteColor(colorout), .ReadColor({VGA_B, VGA_G, VGA_R}));

increment_write iw(.Clk(reset_clk), .Reset(~KEY[0]), .*);

ang_lut al(.Clk(CLOCK_50), .WriteY(WriteY), .WriteX(WriteX),.dTheta(dTheta), .dPhi(dPhi));

ray_lut rl(.Clk(CLOCK_50), .theta((64'd90 << 32) + dTheta), .phi((64'd90 << 32) + dPhi), .ray(lookray));

vga_clk vga_clk_instance(.inclk0(CLOCK_50), .c0(VGA_CLK));

hit_detection hd(.*,.Clk(CLOCK_50),.frame_clk(VGA_VS));

always_ff @ (posedge CLOCK_50 or negedge KEY[0]) begin
	if(~KEY[0])begin
		State = Setup0;
	end else begin
		State = State_n;
		case (State_n)
			Setup0: reset_clk <= 1'b1;
			Setup1: reset_clk <= 1'b01;
			Sphere0_0: reset_clk <= 1'b0;
			Sphere0_1: reset_clk <= 1'b0;
			Sphere1_0: reset_clk <= 1'b0;
			Sphere1_1: reset_clk <= 1'b0;
			Sphere2_0: reset_clk <= 1'b0;
			Sphere2_1: reset_clk <= 1'b0;
			Sphere3_0: reset_clk <= 1'b0;
			Sphere3_1: reset_clk <= 1'b0;
			Write: reset_clk <= 1'b0;
		endcase
		case (State_n)
			Setup0: tbest <= 64'hefffffffffffffff;
			Sphere1_0: tbest <= tbest_n;
			Sphere2_0: tbest <= tbest_n;
			Sphere3_0: tbest <= tbest_n;
			Write: tbest <= tbest_n;
		endcase
		case (State_n)
			Setup0: best_in <= 2'b0;
			Sphere1_0: best_in <= best_in_n;
			Sphere2_1: best_in <= best_in_n;
			Sphere3_1: best_in <= best_in_n;
			Write: best_in <= best_in_n;
		endcase
	end
end

always_comb begin
	State_n = State;
	WritePixel = 0;
	case (State)
		Setup0: begin
			State_n = Setup1;
			next_sphere = 2'd0;
		end
		Setup1: begin
			State_n = Sphere0_0;
			next_sphere = 2'd0;
		end
		Sphere0_0: begin
			State_n = Sphere0_1;
			next_sphere = 2'd0;
		end
		Sphere0_1: begin
			State_n = Sphere1_0;
			next_sphere = 2'd1;
		end
		Sphere1_0: begin
			State_n = Sphere1_1;
			next_sphere = 2'd1;
		end
		Sphere1_1: begin
			State_n = Sphere2_0;
			next_sphere = 2'd2;
		end
		Sphere2_0: begin
			State_n = Sphere2_1;
			next_sphere = 2'd2;
		end
		Sphere2_1: begin
			State_n = Sphere3_0;
			next_sphere = 2'd3;
		end
		Sphere3_0: begin
			State_n = Sphere3_1;
			next_sphere = 2'd3;
		end
		Sphere3_1: begin
			State_n = Write;
			next_sphere = 2'd0;
		end
		Write: begin
			State_n = Setup0;
			WritePixel = 1;
			next_sphere = 2'd0;
		end
	endcase

	if(tbest > tcurr && collide)	begin
		tbest_n = tcurr;
		best_in_n = curr_sphere;
	end
	else begin
		tbest_n = tbest;
		best_in_n = best_in;
	end
end

endmodule
