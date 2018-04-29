typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module  color_mapper (
	input is_ball,
	input fixed_real phi,
   input [9:0] DrawX, DrawY,
	input color colin,
	output color col
);

logic [7:0] shade;
fixed_real subt;

always_comb begin
	shade = 8'd0;
	subt = 64'd0;
	  if ((DrawX == 10'd320 & (DrawY < 10'd244 & DrawY > 10'd236)) ||
			(DrawY == 10'd240 & (DrawX < 10'd324 & DrawX > 10'd316))) begin
			col[2] = 8'hFF;
			col[1] = 8'h00;
			col[0] = 8'h00;
	  end else if (is_ball == 1'b1) 
	  begin
			col[2] = colin[2];
			col[1] = colin[1];
			col[0] = colin[0];
	  end else if (phi > {64'd90 << 32})
	  begin
			subt = phi - {32'd90 << 32};
			shade = subt[39:32];
			shade = shade << 2;
			col[2] = shade;
			col[1] = shade;
			col[0] = shade;
	  end else 
	  begin
			col[2] = 8'h00; 
			col[1] = 8'h00;
			col[0] = 8'h00;
	  end
	end 

endmodule 