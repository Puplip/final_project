typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;
typedef logic [2:0] [1:0] color_small;

module frame_buffer (
	input logic Clk, Write,
	input logic [9:0] WriteX, WriteY,
	input color WriteColor,
	input logic [9:0] DrawX, DrawY,
	output logic [2:0] [7:0] ReadColor
);
	color_small buffer [307199:0];
	logic [18:0] Write_Index, Read_Index;
	color_small ReadColor_raw, WriteColor_small;
	
	assign Write_Index = (WriteY << 9) + (WriteY << 7) + WriteX;
	assign Read_Index = (DrawY << 9) + (DrawY << 7) + DrawX;

	always_ff @ (posedge Clk) begin
		if(Write) begin
			buffer[Write_Index] = WriteColor_small;
		end
		ReadColor_raw = buffer[Read_Index];
	end
	
	color_shrink shrink(.in(WriteColor),.out(WriteColor_small));
	color_expand expand(.in(ReadColor_raw),.out(ReadColor));
	
endmodule

module color_shrink (
	input color in,
	output color_small out
);
assign out[0] = in[0][1:0];
assign out[1] = in[1][1:0];
assign out[2] = in[2][1:0];

endmodule

module color_expand (
	input color_small in,
	output color out
);

assign out[0] = {6'b0,in[0]} << 6;
assign out[1] = {6'b0,in[1]} << 6;
assign out[2] = {6'b0,in[2]} << 6;

endmodule
