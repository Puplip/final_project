typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module input_handler (
	input logic Frame_Clk, Clk, Reset,
	input logic new_data,
	input logic [8:0] dx, dy,
	input logic m1, m2, m3,
	input fixed_real sensitivity,
	input logic gameOver,
	output fixed_real Theta, Phi,
	output logic Click, Pause,
	output vector CameraX, CameraY, Camera_Ray
);

	enum logic [7:0] {
		Cam0,
		Cam1,
		Cam2,
		Cam3,
		Cam4
	} State, State_n;

	vector CameraX_n, CameraY_n, Camera_Ray_n;
	
	logic ClickRight, ClickRight_n;
	
	logic old_frame_clk, frame_clk_rising_edge, new_data_rising_edge, old_new_data, old_m1, old_m1_n, old_m2, old_m2_n, Click_n;
	logic [31:0] x_buffer, y_buffer, x_buffer_n, y_buffer_n, x_buffer_fix, y_buffer_fix, x_buffer_mag, y_buffer_mag;
	fixed_real Phi_n, Theta_n, x_buffer_scaled, y_buffer_scaled, Phi_n_raw, Theta_n_raw, Theta_temp_n, Phi_temp_n, Phi_temp, Theta_temp, Theta_temp_n_pre, Phi_temp_n_pre;
	fixed_real x_buffer_shifted, y_buffer_shifted;
	
	assign x_buffer_shifted = ~{{6{x_buffer_fix[31]}},x_buffer_fix,26'b0} + 64'd1;
	assign y_buffer_shifted = ~{{6{y_buffer_fix[31]}},y_buffer_fix,26'b0} + 64'd1;
	
	assign x_buffer_mag = x_buffer[31]?(~x_buffer) + 32'd1:x_buffer;
	assign y_buffer_mag = y_buffer[31]?(~y_buffer) + 32'd1:y_buffer;
	
	assign x_buffer_fix = (x_buffer_mag > 32'b111111)?32'b0:x_buffer;
	assign y_buffer_fix = (y_buffer_mag > 32'b111111)?32'b0:y_buffer;
	
	mult_real mx(.a(x_buffer_shifted),.b(sensitivity),.c(x_buffer_scaled));
	mult_real my(.a(y_buffer_shifted),.b(sensitivity),.c(y_buffer_scaled));	
	
	vector Ray_lut_out, Camera_Ray_raw, Camera_Ray_raw_n, Camera_Ray_fix, CameraX_raw_n, CameraX_raw, CameraY_raw_n, CameraY_raw;
	
	fixed_real Theta_lut_in, Phi_lut_in, dTheta, dPhi, dTheta_mag, dPhi_mag;
	
	ray_lut rl0(.Clk(Clk), .theta(Theta_lut_in), .phi(Phi_lut_in), .ray(Ray_lut_out));
	
	dot_product_scale dps0(.a(Camera_Ray_raw),.b({3{64'd240 << 32}}),.s(Camera_Ray_fix));
	
	assign Theta_n_raw = x_buffer_scaled + Theta;
	assign Phi_n_raw = y_buffer_scaled + Phi;
	
	logic frame_clk_falling_edge;
	
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
			old_m2 <= 1'b1;
			old_frame_clk <= 1'b1;
			old_new_data <= 1'b1;
			CameraX <= 192'b0;
			CameraY <= 192'b0;
			Camera_Ray <= 192'b0;
			Phi_temp <= 64'd90 << 32;
			Theta_temp <= 64'd90 << 32;
			State <= Cam4;
			CameraX_raw <= 192'b0;
			CameraY_raw <= 192'b0;
			Camera_Ray_raw <= 192'b0;
			ClickRight <= 1'b0;
			Pause = 1'b0;
		end
		else begin
			x_buffer <= x_buffer_n;
			y_buffer <= y_buffer_n;
			Theta <= Theta_n;
			Phi <= Phi_n;
			Click <= Click_n;
			old_m1 <= old_m1_n;
			old_m2 <= old_m2_n;
			old_frame_clk <= Frame_Clk;
			old_new_data <= new_data;
			CameraX <= CameraX_n;
			CameraY <= CameraY_n;
			Camera_Ray <= Camera_Ray_n;
			Theta_temp = Theta_temp_n;
			Phi_temp = Phi_temp_n;
			State = State_n;
			CameraX_raw <= CameraX_raw_n;
			CameraY_raw <= CameraY_raw_n;
			Camera_Ray_raw <= Camera_Ray_raw_n;
			ClickRight = ClickRight_n;
			Pause = Pause_n;
		end
	end
	
	logic Pause_n;
	fixed_real Phi_temp_n_fin, Theta_temp_n_fin;
	
	always_comb begin
		if(Phi_n_raw[63]) Phi_temp_n_pre = 64'd0;
		else if(Phi_n_raw > (64'd150 << 32)) Phi_temp_n_pre = 64'd150 << 32;
		else if(Phi_n_raw < (64'd30 << 32)) Phi_temp_n_pre = 64'd30 << 32;
		else Phi_temp_n_pre = Phi_n_raw;
		if(Theta_n_raw[63]) Theta_temp_n_pre = 64'd0;
		else if(Theta_n_raw > (64'd179 << 32)) Theta_temp_n_pre = 64'd179 << 32;
		else if(Theta_n_raw < (64'd1 << 32)) Theta_temp_n_pre = 64'd1 << 32;
		else Theta_temp_n_pre = Theta_n_raw;
	end
	
	always_comb begin
		State_n = State;
		x_buffer_n = x_buffer;
		y_buffer_n = y_buffer;
		Theta_n = Theta;
		Phi_n = Phi;
		Click_n = Click;
		ClickRight_n = ClickRight;
		old_m1_n = old_m1;
		old_m2_n = old_m2;
		CameraX_n = CameraX;
		CameraY_n = CameraY;
		Camera_Ray_n = Camera_Ray;
		Theta_temp_n = Theta_temp;
		Phi_temp_n = Phi_temp;
		Theta_lut_in = 64'b0;
		Phi_lut_in = 64'b0;
		CameraX_raw_n = CameraX_raw;
		CameraY_raw_n = CameraY_raw;
		Camera_Ray_raw_n = Camera_Ray_raw;
		State_n = State;
		Pause_n = Pause;
		if(frame_clk_rising_edge) begin
			Theta_temp_n = Theta_temp_n_pre;
			Phi_temp_n = Phi_temp_n_pre;
			Click_n = 1'b0;
			ClickRight_n = 1'b0;
			x_buffer_n = 32'b0;
			y_buffer_n = 32'b0;
			State_n = Cam0;
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
			old_m2_n = m2;
			if( m1 && ~old_m1 && ~gameOver) begin
				Click_n = 1'b1;
			end
			if(m2 && ~old_m2 && ~gameOver) begin
				ClickRight_n = 1'b1;
				Pause_n = ~Pause;
			end
		end
		case(State)
			Cam0: begin
				Theta_lut_in = Theta_temp;
				Phi_lut_in = Phi_temp;
				State_n = Cam1;
			end
			Cam1: begin
				Theta_lut_in = Theta_temp - (64'd90 << 32);
				Phi_lut_in = 64'd90 << 32;
				Camera_Ray_raw_n = Ray_lut_out;
				State_n = Cam2;
			end
			Cam2: begin
				Phi_lut_in = Phi_temp + (64'd90 << 32);
				Theta_lut_in = Theta_temp;
				CameraX_raw_n = Ray_lut_out;
				State_n = Cam3;
			end
			Cam3: begin
				CameraY_raw_n = Ray_lut_out;
				State_n = Cam4;
			end
			Cam4: begin
				
			end
		endcase
	end
endmodule
