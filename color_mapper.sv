typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module  color_mapper (
	input is_ball,
	input fixed_real zcomp,
   input [9:0] DrawX, DrawY,
	input color colin,
	output color col
);

fixed_real zcompfixed;
logic [7:0] shade;

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
		/*
		end else if (zcomp[63] == 1'b0) begin
			distance = 64'h0000000600000000 / zcomp;
			//distance = 64'h0000000600000000 / ((~zcomp) + 1'b1);
			
			ovdist = distance[15:0];
			ovrand = {13'd0, random[4:0]};
			
			mult = ovdist * ovrand;
			
			if (mult > 16'h01FE)
				mult = 16'h01FE;
			
			col[2] = {8'hFF - mult[8:1]};
			col[1] = {8'hFF - mult[8:1]};
			col[0] = {8'hFF - mult[8:1]};
		end else
		begin
			col[2] = 8'h00;
			col[1] = 8'h00;
			col[0] = 8'h00;
		end
		*/
		
		if ((DrawX == 10'd320 & (DrawY < 10'd244 & DrawY > 10'd236)) ||
			(DrawY == 10'd240 & (DrawX < 10'd324 & DrawX > 10'd316)))
		begin
			col[2] = ~col[2];
			col[1] = ~col[1];
			col[0] = ~col[0];
		end
end
endmodule 