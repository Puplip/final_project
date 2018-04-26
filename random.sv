typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;


module rand_lut (
	input logic Clk, Reset,
	output fixed_real random
);
fixed_real counter;
logic [3:0] out [15:0];

always_ff @ (posedge Clk) begin
	if(Reset) begin
		//counter <= 64'b0;
	end
	else begin
		counter <= counter + random;
	end
end

assign random = {out[15],out[14],out[13],out[12],out[11],out[10],out[9],out[8],out[7],out[6],out[5],out[4],out[3],out[2],out[1],out[0]};

random_0 r0(.seed(counter[4:0]),.out(out[00]));
random_1 r1(.seed({counter[6'd48 + out[00]],counter[6'd32 + out[00]],counter[6'd16 + out[00]],counter[out[00]]}),.out(out[01]));
random_2 r2(.seed({counter[6'd48 + out[01]],counter[6'd32 + out[01]],counter[6'd16 + out[01]],counter[out[01]]}),.out(out[02]));
random_3 r3(.seed({counter[6'd48 + out[02]],counter[6'd32 + out[02]],counter[6'd16 + out[02]],counter[out[02]]}),.out(out[03]));
random_4 r4(.seed({counter[6'd48 + out[03]],counter[6'd32 + out[03]],counter[6'd16 + out[03]],counter[out[03]]}),.out(out[04]));
random_5 r5(.seed({counter[6'd48 + out[04]],counter[6'd32 + out[04]],counter[6'd16 + out[04]],counter[out[04]]}),.out(out[05]));
random_6 r6(.seed({counter[6'd48 + out[05]],counter[6'd32 + out[05]],counter[6'd16 + out[05]],counter[out[05]]}),.out(out[06]));
random_7 r7(.seed({counter[6'd48 + out[06]],counter[6'd32 + out[06]],counter[6'd16 + out[06]],counter[out[06]]}),.out(out[07]));
random_8 r8(.seed({counter[6'd48 + out[07]],counter[6'd32 + out[07]],counter[6'd16 + out[07]],counter[out[07]]}),.out(out[08]));
random_9 r9(.seed({counter[6'd48 + out[08]],counter[6'd32 + out[08]],counter[6'd16 + out[08]],counter[out[08]]}),.out(out[09]));
random_10 r10(.seed({counter[6'd48 + out[09]],counter[6'd32 + out[09]],counter[6'd16 + out[09]],counter[out[09]]}),.out(out[10]));
random_11 r11(.seed({counter[6'd48 + out[10]],counter[6'd32 + out[10]],counter[6'd16 + out[10]],counter[out[10]]}),.out(out[11]));
random_12 r12(.seed({counter[6'd48 + out[11]],counter[6'd32 + out[11]],counter[6'd16 + out[11]],counter[out[11]]}),.out(out[12]));
random_13 r13(.seed({counter[6'd48 + out[12]],counter[6'd32 + out[12]],counter[6'd16 + out[12]],counter[out[12]]}),.out(out[13]));
random_14 r14(.seed({counter[6'd48 + out[13]],counter[6'd32 + out[13]],counter[6'd16 + out[13]],counter[out[13]]}),.out(out[14]));
random_15 r15(.seed({counter[6'd48 + out[14]],counter[6'd32 + out[14]],counter[6'd16 + out[14]],counter[out[14]]}),.out(out[15]));

endmodule

/*
var out = "";
for(var i = 0; i < 16; i++){
out += "module random_" + i + " (\n\tinput logic [3:0] seed,\n\toutput logic [3:0] out\n);\n\n";
out += "always_comb begin\n\tcase (seed)\n\t\t";
for(var j = 0; j < 16; j++){
out += "4'd" + j + ": out = 4'b" + Math.floor(Math.random() * 16).toString(2) + ";\n\t";
}
out += "endcase\nend\nendmodule\n";
}
console.log(out);
*/
module random_0 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b10;
	4'd1: out = 4'b1101;
	4'd2: out = 4'b1011;
	4'd3: out = 4'b101;
	4'd4: out = 4'b1010;
	4'd5: out = 4'b1000;
	4'd6: out = 4'b1111;
	4'd7: out = 4'b101;
	4'd8: out = 4'b1111;
	4'd9: out = 4'b1100;
	4'd10: out = 4'b110;
	4'd11: out = 4'b1100;
	4'd12: out = 4'b100;
	4'd13: out = 4'b100;
	4'd14: out = 4'b1011;
	4'd15: out = 4'b1001;
	endcase
end
endmodule
module random_1 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b1011;
	4'd1: out = 4'b111;
	4'd2: out = 4'b0;
	4'd3: out = 4'b1111;
	4'd4: out = 4'b1000;
	4'd5: out = 4'b1101;
	4'd6: out = 4'b10;
	4'd7: out = 4'b1101;
	4'd8: out = 4'b1000;
	4'd9: out = 4'b101;
	4'd10: out = 4'b100;
	4'd11: out = 4'b1010;
	4'd12: out = 4'b1011;
	4'd13: out = 4'b101;
	4'd14: out = 4'b110;
	4'd15: out = 4'b1101;
	endcase
end
endmodule
module random_2 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b1;
	4'd1: out = 4'b1101;
	4'd2: out = 4'b110;
	4'd3: out = 4'b100;
	4'd4: out = 4'b111;
	4'd5: out = 4'b1111;
	4'd6: out = 4'b10;
	4'd7: out = 4'b11;
	4'd8: out = 4'b0;
	4'd9: out = 4'b1100;
	4'd10: out = 4'b1011;
	4'd11: out = 4'b1111;
	4'd12: out = 4'b110;
	4'd13: out = 4'b100;
	4'd14: out = 4'b1001;
	4'd15: out = 4'b1001;
	endcase
end
endmodule
module random_3 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b111;
	4'd1: out = 4'b0;
	4'd2: out = 4'b101;
	4'd3: out = 4'b1011;
	4'd4: out = 4'b1111;
	4'd5: out = 4'b110;
	4'd6: out = 4'b1000;
	4'd7: out = 4'b1001;
	4'd8: out = 4'b1100;
	4'd9: out = 4'b10;
	4'd10: out = 4'b1111;
	4'd11: out = 4'b1;
	4'd12: out = 4'b1;
	4'd13: out = 4'b1010;
	4'd14: out = 4'b100;
	4'd15: out = 4'b101;
	endcase
end
endmodule
module random_4 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b1011;
	4'd1: out = 4'b1011;
	4'd2: out = 4'b11;
	4'd3: out = 4'b1;
	4'd4: out = 4'b11;
	4'd5: out = 4'b1001;
	4'd6: out = 4'b1110;
	4'd7: out = 4'b101;
	4'd8: out = 4'b1111;
	4'd9: out = 4'b111;
	4'd10: out = 4'b1001;
	4'd11: out = 4'b1011;
	4'd12: out = 4'b10;
	4'd13: out = 4'b1000;
	4'd14: out = 4'b101;
	4'd15: out = 4'b110;
	endcase
end
endmodule
module random_5 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b10;
	4'd1: out = 4'b1100;
	4'd2: out = 4'b1010;
	4'd3: out = 4'b1;
	4'd4: out = 4'b1110;
	4'd5: out = 4'b1011;
	4'd6: out = 4'b1110;
	4'd7: out = 4'b11;
	4'd8: out = 4'b101;
	4'd9: out = 4'b0;
	4'd10: out = 4'b0;
	4'd11: out = 4'b1111;
	4'd12: out = 4'b1;
	4'd13: out = 4'b1101;
	4'd14: out = 4'b111;
	4'd15: out = 4'b1011;
	endcase
end
endmodule
module random_6 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b111;
	4'd1: out = 4'b1011;
	4'd2: out = 4'b1011;
	4'd3: out = 4'b111;
	4'd4: out = 4'b1001;
	4'd5: out = 4'b1001;
	4'd6: out = 4'b101;
	4'd7: out = 4'b1100;
	4'd8: out = 4'b1;
	4'd9: out = 4'b1111;
	4'd10: out = 4'b1000;
	4'd11: out = 4'b101;
	4'd12: out = 4'b1100;
	4'd13: out = 4'b1110;
	4'd14: out = 4'b101;
	4'd15: out = 4'b0;
	endcase
end
endmodule
module random_7 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b1000;
	4'd1: out = 4'b1011;
	4'd2: out = 4'b1101;
	4'd3: out = 4'b1101;
	4'd4: out = 4'b1001;
	4'd5: out = 4'b1110;
	4'd6: out = 4'b0;
	4'd7: out = 4'b1;
	4'd8: out = 4'b1010;
	4'd9: out = 4'b101;
	4'd10: out = 4'b1111;
	4'd11: out = 4'b1;
	4'd12: out = 4'b1111;
	4'd13: out = 4'b1010;
	4'd14: out = 4'b1;
	4'd15: out = 4'b1100;
	endcase
end
endmodule
module random_8 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b110;
	4'd1: out = 4'b110;
	4'd2: out = 4'b1001;
	4'd3: out = 4'b100;
	4'd4: out = 4'b1001;
	4'd5: out = 4'b1100;
	4'd6: out = 4'b1011;
	4'd7: out = 4'b11;
	4'd8: out = 4'b1010;
	4'd9: out = 4'b110;
	4'd10: out = 4'b110;
	4'd11: out = 4'b101;
	4'd12: out = 4'b1100;
	4'd13: out = 4'b1000;
	4'd14: out = 4'b1010;
	4'd15: out = 4'b111;
	endcase
end
endmodule
module random_9 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b111;
	4'd1: out = 4'b1010;
	4'd2: out = 4'b111;
	4'd3: out = 4'b1000;
	4'd4: out = 4'b100;
	4'd5: out = 4'b10;
	4'd6: out = 4'b1011;
	4'd7: out = 4'b1000;
	4'd8: out = 4'b1101;
	4'd9: out = 4'b1110;
	4'd10: out = 4'b1101;
	4'd11: out = 4'b11;
	4'd12: out = 4'b1110;
	4'd13: out = 4'b1;
	4'd14: out = 4'b100;
	4'd15: out = 4'b101;
	endcase
end
endmodule
module random_10 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b101;
	4'd1: out = 4'b1111;
	4'd2: out = 4'b1001;
	4'd3: out = 4'b1010;
	4'd4: out = 4'b1100;
	4'd5: out = 4'b1101;
	4'd6: out = 4'b101;
	4'd7: out = 4'b1010;
	4'd8: out = 4'b100;
	4'd9: out = 4'b1111;
	4'd10: out = 4'b1001;
	4'd11: out = 4'b101;
	4'd12: out = 4'b1101;
	4'd13: out = 4'b0;
	4'd14: out = 4'b0;
	4'd15: out = 4'b1001;
	endcase
end
endmodule
module random_11 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b1110;
	4'd1: out = 4'b0;
	4'd2: out = 4'b100;
	4'd3: out = 4'b1101;
	4'd4: out = 4'b1000;
	4'd5: out = 4'b11;
	4'd6: out = 4'b1111;
	4'd7: out = 4'b111;
	4'd8: out = 4'b110;
	4'd9: out = 4'b1010;
	4'd10: out = 4'b11;
	4'd11: out = 4'b1010;
	4'd12: out = 4'b10;
	4'd13: out = 4'b1001;
	4'd14: out = 4'b1100;
	4'd15: out = 4'b1011;
	endcase
end
endmodule
module random_12 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b0;
	4'd1: out = 4'b11;
	4'd2: out = 4'b11;
	4'd3: out = 4'b111;
	4'd4: out = 4'b1101;
	4'd5: out = 4'b100;
	4'd6: out = 4'b110;
	4'd7: out = 4'b111;
	4'd8: out = 4'b1001;
	4'd9: out = 4'b101;
	4'd10: out = 4'b1100;
	4'd11: out = 4'b1101;
	4'd12: out = 4'b10;
	4'd13: out = 4'b1001;
	4'd14: out = 4'b1000;
	4'd15: out = 4'b11;
	endcase
end
endmodule
module random_13 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b1101;
	4'd1: out = 4'b0;
	4'd2: out = 4'b1101;
	4'd3: out = 4'b1001;
	4'd4: out = 4'b1000;
	4'd5: out = 4'b110;
	4'd6: out = 4'b1111;
	4'd7: out = 4'b1101;
	4'd8: out = 4'b101;
	4'd9: out = 4'b1001;
	4'd10: out = 4'b1100;
	4'd11: out = 4'b101;
	4'd12: out = 4'b110;
	4'd13: out = 4'b100;
	4'd14: out = 4'b1011;
	4'd15: out = 4'b1111;
	endcase
end
endmodule
module random_14 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b1011;
	4'd1: out = 4'b1100;
	4'd2: out = 4'b1111;
	4'd3: out = 4'b1111;
	4'd4: out = 4'b1000;
	4'd5: out = 4'b1010;
	4'd6: out = 4'b101;
	4'd7: out = 4'b1010;
	4'd8: out = 4'b1010;
	4'd9: out = 4'b1101;
	4'd10: out = 4'b1011;
	4'd11: out = 4'b0;
	4'd12: out = 4'b10;
	4'd13: out = 4'b111;
	4'd14: out = 4'b1011;
	4'd15: out = 4'b1001;
	endcase
end
endmodule
module random_15 (
	input logic [3:0] seed,
	output logic [3:0] out
);

always_comb begin
	case (seed)
		4'd0: out = 4'b111;
	4'd1: out = 4'b1110;
	4'd2: out = 4'b10;
	4'd3: out = 4'b0;
	4'd4: out = 4'b1111;
	4'd5: out = 4'b10;
	4'd6: out = 4'b1011;
	4'd7: out = 4'b1110;
	4'd8: out = 4'b1100;
	4'd9: out = 4'b1001;
	4'd10: out = 4'b10;
	4'd11: out = 4'b100;
	4'd12: out = 4'b1101;
	4'd13: out = 4'b10;
	4'd14: out = 4'b0;
	4'd15: out = 4'b110;
	endcase
end
endmodule