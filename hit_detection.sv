typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module hit_detection (
	input logic Clk, Frame_Clk,
	input logic Click, WritePixel,
	input logic [1:0] Best_in,
	input logic [9:0] WriteX, WriteY,
	input fixed_real Best_Dist,
	output logic [1:0] Hit_in,
	output logic Hit
);

logic old_frame_clk, frame_clk_rising_edge;

logic save_hit, save_hit_n, save_click, save_click_n;
logic [1:0] save_hit_index, save_hit_index_n;

assign frame_clk_rising_edge = ~old_frame_clk && Frame_Clk;
assign Hit = save_hit && save_click;
assign Hit_in = save_hit_index;

always_ff @ (posedge Clk) begin
	old_frame_clk <= Frame_Clk;
	save_hit <= save_hit_n;
	save_hit_index <= save_hit_index_n;
	save_click <= save_click_n;
end

always_comb begin
	if(frame_clk_rising_edge) begin
		save_hit_index_n = 2'b0;
		save_hit_n = 1'b0;
		save_click_n = 1'b0;
	end 
	else begin
		save_hit_index_n = save_hit_index;
		save_hit_n = save_hit;
		save_click_n = save_click;
		if(WriteX == 10'd320 && WriteY == 10'd240 && WritePixel && Best_Dist != 64'hEFFFFFFFFFFFFFFF) begin
			save_hit_n = 1'b1;
			save_hit_index_n = Best_in;
		end
		if(Click) begin
			save_click_n = 1'b1;
		end
	end
end

endmodule
