typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module  color_mapper (
	input is_ball,
	input fixed_real zcomp,
   input [9:0] DrawX, DrawY,
	input endGame,
	input Pause,
	input Clk,
	input color colin,
	output color col
);


logic out, outpause;
fixed_real zcompfixed;
logic [7:0] shade;

pauselut pl(.*, .out(outpause), .in({2'b00, DrawX - 10'd272, 2'b00, DrawY - 10'd192}));
gameoverlut gol(.*, .in({2'b00, DrawX - 10'd272, 2'b00, DrawY - 10'd192}));

always_comb begin
	
	shade = 8'h00;
	zcompfixed = 63'd0;
		if (is_ball == 1'b1) 
		begin
			col[2] = colin[2];
			col[1] = colin[1];
			col[0] = colin[0];
		end else if (zcomp > (64'd90 << 32) && zcomp < (64'd270 << 32)) begin
			if (zcomp > 64'd180 << 32)
				zcompfixed = (64'd270 << 32) - zcomp;
			else	
				zcompfixed = zcomp - (64'd90 << 32);
				
				
			if (zcompfixed[39:32] < 64'd4)
				shade = 8'b00111111 + (8'b01000000 && {8{(DrawX[0] ^ DrawY[0])}});
			else if (zcompfixed[39:32] < 64'd12)
				shade = 8'b01111111;
			else if (zcompfixed[39:32] < 64'd21)
				shade = 8'b01111111 + (8'b01000000 && {8{(DrawX[0] ^ DrawY[0])}});
			else if (zcompfixed[39:32] < 64'd30)
				shade = 8'b10111111;
			else if (zcompfixed[39:32] < 64'd40)
				shade = 8'b10111111 + (8'b01000000 && {8{(DrawX[0] ^ DrawY[0])}});
			else
				shade = 8'b11111111;
				
			col[2] = shade;
			col[1] = shade;
			col[0] = shade;
		end else begin
			col[2] = 8'h00;
			col[1] = 8'h00;
			col[0] = 8'h00;
		end
		
		if ((DrawX == 10'd320 & (DrawY < 10'd244 & DrawY > 10'd236)) ||
			(DrawY == 10'd240 & (DrawX < 10'd324 & DrawX > 10'd316)))
		begin
			col[2] = ~col[2];
			col[1] = ~col[1];
			col[0] = ~col[0];
		end
		
		if (out && endGame) begin
			col[2] = 8'hff;
			col[1] = 8'hff;
			col[0] = 8'hff;
		end
		if (outpause && Pause) begin
			col[2] = 8'hff;
			col[1] = 8'h00;
			col[0] = 8'h00;
		end
end
endmodule 