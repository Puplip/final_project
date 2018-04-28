typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module  color_mapper (
	input is_ball,
   input [9:0] DrawX, DrawY,
	input color colin,
	output color col
);

always_comb begin
	  if ((DrawX == 10'd320 & (DrawY < 10d'244 & DrawY > 10d'236)) |
			(DrawY == 10'd240 & (DrawX < 10d'324 & DrawX > 10d'316))) begin
			col[2] = 8'hFF;
			col[1] = 8'h00;
			col[0] = 8'h00;
		end
	  if (is_ball == 1'b1) 
	  begin
			col[2] = colin[2];
			col[1] = colin[1];
			col[0] = colin[0];
	  end
	  else 
	  begin
			col[2] = 8'h00; 
			col[1] = 8'h00;
			col[0] = 8'h00;
	  end
	end 

endmodule 