typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module collision_detection (
	input vector sphere, ray,
	input fixed_real tbest,
	output fixed_real tnew,
	output logic Collision
);
fixed_real v, bsqr, cdot, vsqr, disc, sqrt, tnew_n, hitz;

dot_product_scale vdxc(.a(ray), .b(sphere), .c(v), .s()); //3 mults
dot_product_scale cc(.a(sphere), .b(sphere), .c(cdot), .s()); //3 mults
mult_real vsqrmod(.a(v), .b(v), .c(vsqr)); // 1 mult
sqrt_real_32 rbsqrt(.a(disc[63:32]), .c(sqrt[55:24]));
mult_real floorq(.a(tnew_n),.b(ray[2]),.c(hitz));

assign sqrt[63:56] = 8'b0;
assign sqrt[23:0] = 24'b0;

//radius of sphere: d'32 = b'10 0000
fixed_real rad, radsq;
assign rad = 64'd480 << 32;
assign radsq = 64'd230400 << 32;

always_comb begin
	bsqr = cdot - vsqr;
	disc = radsq - bsqr;
	Collision = 0;
	tnew = tbest;
	tnew_n = v  - sqrt;
	
	//if (tbest > v - rad) begin
	bsqr = cdot - vsqr;
	if ((radsq > bsqr || bsqr[63])) begin
		tnew = tnew_n;
		Collision = 1'b1;
	end
	//end

end

endmodule 
