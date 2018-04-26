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
	Reset,
	Sphere1} State, State_n;

logic reset_clk, collide, WritePixel;
vector sphere1pos, lookray;
color sphere1col, colorout;
logic [9:0] DrawX, DrawY, WriteX, WriteY;

fixed_real dPhi, dTheta;

/*sphere_reg firstsph(.Frame_Clk(VGA_VS), .nextcol({8'hff, 8'hff, 8'hff}), .nextpos({64'd0, 64'd304 << 32, 64'd0}),
	.currentpos(sphere1pos), .currentcol(sphere1col));*/
	
sphere_reg_4 sph4(.Clk(CLOCK_50),.Frame_Clk(VGA_VS),.Reset(~KEY[0]),.Hit(1'b0),.Hit_index(2'b00),.Read_index(2'b01),.Sphere_pos(sphere1pos),.Sphere_col(sphere1col));
	
color_mapper colmap(.is_ball(collide), .DrawX(WriteX), .DrawY(WriteY), .colin(sphere1col), .col(colorout));

collision_detection cd(.sphere(sphere1pos), .ray(lookray), .tbest(64'h8FFFFFFF00000000), .tnew(), .collide(collide));

VGA_controller vga(.Clk(VGA_CLK), .Reset(~KEY[0]), .*);

frame_buffer fb(.Clk(CLOCK_50), .Write(WritePixel), .*, .WriteColor(colorout), .ReadColor({VGA_B, VGA_G, VGA_R}));

increment_write iw(.Clk(reset_clk), .Reset(~KEY[0]), .*);

y_ang_lut yang(.Clk(CLOCK_50), .WriteY(WriteY), .dPhi(dPhi));
x_ang_lut xang(.Clk(CLOCK_50), .WriteX(WriteX), .dTheta(dTheta));

ray_lut rl(.Clk(CLOCK_50), .theta((64'd90 << 32) + dTheta), .phi((64'd90 << 32) + dPhi), .ray(lookray));

vga_clk vga_clk_instance(.inclk0(CLOCK_50), .c0(VGA_CLK));

always_ff @ (posedge CLOCK_50 or negedge KEY[0]) begin
	if(~KEY[0])begin
		State = Reset;
	end else begin
		State = State_n;
		case (State_n)
			Reset: reset_clk <= 1'b1;
			Sphere1: reset_clk <= 1'b0;
		endcase
	end
end

always_comb begin
State_n = State;
WritePixel = 0;
case (State)
	Reset: begin
		State_n = Sphere1;
	end
	Sphere1: begin
		State_n = Reset;
		WritePixel = 1;
	end
endcase

end

endmodule
