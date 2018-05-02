typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module input_handler (
	input logic Frame_Clk, Clk, Reset,
	input logic new_data,
	input logic [8:0] dx, dy,
	input logic m1, m2, m3,
	input fixed_real sensitivity,
	output fixed_real Theta, Phi,
	output logic Click,
	output vector CameraX, CameraY, Camera_Ray
);

	vector CameraX_n, CameraY_n, Camera_Ray_n, Camera_Ray_raw, Camera_Ray_fix, CameraX_raw, CameraY_raw;
	
	logic old_frame_clk, frame_clk_rising_edge, new_data_rising_edge, old_new_data, old_m1, old_m1_n, Click_n;
	logic [31:0] x_buffer, y_buffer, x_buffer_n, y_buffer_n, x_buffer_mag, y_buffer_mag, x_buffer_fix, y_buffer_fix;
	fixed_real Phi_n, Theta_n, x_buffer_scaled, y_buffer_scaled, Phi_n_raw, Theta_n_raw, Theta_temp_n, Phi_temp_n, Phi_temp, Theta_temp;
	fixed_real x_buffer_shifted, y_buffer_shifted;
	
	
	assign x_buffer_shifted = {{6{x_buffer[31]}},x_buffer_fix,26'b0};
	assign y_buffer_shifted = ~{{6{y_buffer[31]}},y_buffer_fix,26'b0} + 64'd1;
	
	mult_real mx(.a(x_buffer_shifted),.b(sensitivity),.c(x_buffer_scaled));
	mult_real my(.a(y_buffer_shifted),.b(sensitivity),.c(y_buffer_scaled));	
	
	ray_lut rl0(.Clk(Clk), .theta(Theta_temp), .phi(Phi_temp), .ray(Camera_Ray_raw));
	ray_lut rl1(.Clk(Clk), .theta(Theta_temp - (64'd90 << 32)), .phi(Phi_temp), .ray(CameraX_raw));
	ray_lut rl2(.Clk(Clk), .theta(Theta_temp), .phi(Phi_temp + (64'd90 << 32)), .ray(CameraY_raw));
	
	dot_product_scale dps0(.a(Camera_Ray_raw),.b({3{64'd240 << 32}}),.c(Camera_Ray_fix));
	
	assign x_buffer_mag = x_buffer[31]?(~x_buffer) + 32'd1:x_buffer;
	assign y_buffer_mag = y_buffer[31]?(~y_buffer) + 32'd1:y_buffer;
	
	assign x_buffer_fix = (x_buffer_mag > 32'b011111)?32'b0:x_buffer;
	assign y_buffer_fix = (y_buffer_mag > 32'b011111)?32'b0:y_buffer;
	
	assign Theta_n_raw = x_buffer_scaled + Theta;
	assign Phi_n_raw = y_buffer_scaled + Phi;
	
	assign frame_clk_falling_edge = ~Frame_Clk && old_frame_clk;
	
	assign frame_clk_rising_edge = ~old_frame_clk && Frame_Clk;
	assign new_data_rising_edge = ~old_new_data && new_data;
	
	always_ff @ (posedge Clk) begin
		if(Reset) begin
			x_buffer <= 32'b0;
			y_buffer <= 32'b0;
			Theta <= 64'd90 << 32;
			Phi <= 64'd90 << 32;
			Click <= 1'b0;
			old_m1 <= 1'b1;
			old_frame_clk <= 1'b1;
			old_new_data <= 1'b1;
			CameraX <= 192'b0;
			CameraY <= 192'b0;
			Camera_Ray <= 192'b0;
			Phi_temp = 64'b0;
			Theta_temp = 64'b0;
		end
		else begin
			x_buffer <= x_buffer_n;
			y_buffer <= y_buffer_n;
			Theta <= Theta_n;
			Phi <= Phi_n;
			Click <= Click_n;
			old_m1 <= old_m1_n;
			old_frame_clk <= Frame_Clk;
			old_new_data <= new_data;
			CameraX <= CameraX_n;
			CameraY <= CameraY_n;
			Camera_Ray <= Camera_Ray_n;
			Theta_temp = Theta_temp_n;
			Phi_temp = Phi_temp_n;
		end
	end
	
	always_comb begin
		x_buffer_n = x_buffer;
		y_buffer_n = y_buffer;
		Theta_n = Theta;
		Phi_n = Phi;
		Click_n = Click;
		old_m1_n = old_m1;
		CameraX_n = CameraX;
		CameraY_n = CameraY;
		Camera_Ray_n = Camera_Ray;
		Theta_temp_n = Theta_temp;
		Phi_temp_n = Phi_temp;
		if(frame_clk_rising_edge) begin
			if(Phi_n_raw[63]) Phi_temp_n = 64'd0;
			else if(Phi_n_raw > (64'd180 << 32)) Phi_temp_n = 64'd180 << 32;
			else Phi_temp_n = Phi_n_raw;
			
			if(Theta_n_raw[63]) Theta_temp_n = 64'd0;
			else if(Theta_n_raw > 64'd180 << 32) Theta_temp_n = 64'd180 << 32;
			else Theta_temp_n = Theta_n_raw;
			
			Click_n = 1'b0;
			x_buffer_n = 32'b0;
			y_buffer_n = 32'b0;
		end
		else if(frame_clk_falling_edge) begin
			Theta_n = Theta_temp;
			Phi_n = Phi_temp;
			CameraX_n = CameraX_raw;
			CameraY_n = CameraY_raw;
			Camera_Ray_n = Camera_Ray_fix;
		end
		else if(new_data_rising_edge) begin
			x_buffer_n = x_buffer + {{23{dx[8]}},dx};
			y_buffer_n = y_buffer + {{23{dy[8]}},dy};
			old_m1_n = m1;
			if( m1 && ~old_m1) begin
				Click_n = 1'b1;
			end
		end
	end
endmodule
