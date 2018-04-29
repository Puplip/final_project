typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module sphere_reg_4 (
	input logic Clk, Frame_Clk, Reset,
	input logic Hit,
	input logic [1:0] Hit_index, Read_index,
	output vector Sphere_pos,
	output color [3:0] Sphere_col,
	output logic [1:0] curr_index
);

vector [3:0] pos;
color [3:0] col;
vector [3:0] vel;
vector [3:0] acc;
vector [3:0] velacc;
vector [3:0] posvelacc;

vector [3:0] pos_n;
vector [3:0] vel_n;
color [3:0] col_n;

vector [3:0] pos_rand;
vector [3:0] pos_reset;
vector [3:0] vel_rand;
vector [3:0] vel_reset;
color [3:0] col_rand;
fixed_real random;
logic Frame_Clk_old, posedge_frame_clk;

vector gravity;
assign gravity = {~(64'd4 << 32) + 64'd1,64'd0,64'd0};

assign acc[0] = 192'd0;
assign acc[1] = 192'd0;
assign acc[2] = 192'd0;
assign acc[3] = 192'd0;

/*assign pos_rand[0] = {~(64'd2400 << 32) + 64'd1,64'd2880 << 32 + {19'b0,random[63:60],9'b0,32'b0},{{20{random[47]}},random[43:40],8'b0,32'b0}};
assign pos_rand[1] = {~(64'd2400 << 32) + 64'd1,64'd2880 << 32 + {19'b0,random[59:56],9'b0,32'b0},{{20{random[46]}},random[39:36],8'b0,32'b0}};
assign pos_rand[2] = {~(64'd2400 << 32) + 64'd1,64'd2880 << 32 + {19'b0,random[55:52],9'b0,32'b0},{{20{random[45]}},random[35:32],8'b0,32'b0}};
assign pos_rand[3] = {~(64'd2400 << 32) + 64'd1,64'd2880 << 32 + {19'b0,random[51:48],9'b0,32'b0},{{20{random[44]}},random[31:28],8'b0,32'b0}};

assign pos_reset[0] = {64'd30720 << 32,~(64'd4800 << 32)+64'd1,64'd0 << 32};
assign pos_reset[1] = {64'd69120 << 32,~(64'd4800 << 32)+64'd1,64'd0 << 32};
assign pos_reset[2] = {64'd122880 << 32,~(64'd4800 << 32)+64'd1,64'd0 << 32};
assign pos_reset[3] = {64'd192000 << 32,~(64'd4800 << 32)+64'd1,64'd0 << 32};

assign vel_reset[0] = 192'b0;
assign vel_reset[1] = 192'b0;
assign vel_reset[2] = 192'b0;
assign vel_reset[3] = 192'b0;

assign vel_rand[0] = {64'd200 << 32,{28{random[0]}},random[47:32],20'd0,{28{random[1]}},random[31:16],20'd0};
assign vel_rand[1] = {64'd200 << 32,{28{random[2]}},random[62:47],20'd0,{28{random[3]}},random[46:31],20'd0};
assign vel_rand[2] = {64'd200 << 32,{28{random[4]}},random[61:46],20'd0,{28{random[5]}},random[45:30],20'd0};
assign vel_rand[3] = {64'd200 << 32,{28{random[6]}},random[60:45],20'd0,{28{random[7]}},random[44:29],20'd0};
*/
assign pos_rand[0] = {~(64'd2400 << 32) + 64'd1,64'd4800 << 32,~(64'd2400 << 32) + 64'd1};
assign pos_rand[1] = {~(64'd2400 << 32) + 64'd1,64'd4800 << 32,64'd2400};
assign pos_rand[2] = {~(64'd2400 << 32) + 64'd1,64'd9600 << 32,~(64'd2400 << 32) + 64'd1};
assign pos_rand[3] = {~(64'd2400 << 32) + 64'd1,64'd9600 << 32,64'd2400};

assign pos_reset[0] = {~(64'd2400 << 32) + 64'd1,64'd4800 << 32,~(64'd2400 << 32) + 64'd1};
assign pos_reset[1] = {~(64'd2400 << 32) + 64'd1,64'd4800 << 32,64'd2400 << 32};
assign pos_reset[2] = {~(64'd2400 << 32) + 64'd1,64'd9600 << 32,~(64'd2400 << 32) + 64'd1};
assign pos_reset[3] = {~(64'd2400 << 32) + 64'd1,64'd9600 << 32,64'd2400 << 32};

assign vel_reset[0] = 192'b0;
assign vel_reset[1] = 192'b0;
assign vel_reset[2] = 192'b0;
assign vel_reset[3] = 192'b0;

assign vel_rand[0] = 192'b0;
assign vel_rand[1] = 192'b0;
assign vel_rand[2] = 192'b0;
assign vel_rand[3] = 192'b0;

assign col_rand[0] = {random[63:56],random[55:48],random[47:40]};
assign col_rand[1] = {random[39:32],random[31:24],random[23:16]};
assign col_rand[2] = {random[15:8],random[7:0],random[62:55]};
assign col_rand[3] = {random[54:47],random[46:39],random[38:31]};

add_vector va0(.a(vel[0]),.b(acc[0]),.c(velacc[0]));
add_vector va1(.a(vel[1]),.b(acc[1]),.c(velacc[1]));
add_vector va2(.a(vel[2]),.b(acc[2]),.c(velacc[2]));
add_vector va3(.a(vel[3]),.b(acc[3]),.c(velacc[3]));

add_vector pva0(.a(pos[0]),.b(velacc[0]),.c(posvelacc[0]));
add_vector pva1(.a(pos[1]),.b(velacc[1]),.c(posvelacc[1]));
add_vector pva2(.a(pos[2]),.b(velacc[2]),.c(posvelacc[2]));
add_vector pva3(.a(pos[3]),.b(velacc[3]),.c(posvelacc[3]));

rand_lut rl(.*);

assign posedge_frame_clk = ~Frame_Clk_old && Frame_Clk;

assign Sphere_col = col;

always_ff @ (posedge Clk or posedge Reset) begin
	if(Reset) begin
		pos <= pos_reset;
		col <= col_rand;
		vel <= vel_reset;
	end
	else begin
		if(posedge_frame_clk) begin
			pos <= pos_n;
			vel <= vel_n;
			col <= col_n;
		end
		else begin
			pos <= pos;
			vel <= vel;
			col <= col;
		end
		Frame_Clk_old <= Frame_Clk;
	end
end

always_ff @ (posedge Clk) begin
	Sphere_pos <= pos[Read_index];
	curr_index <= Read_index;
end

always_comb begin
	pos_n = posvelacc;
	vel_n = velacc;
	col_n = col;
	
	if((pos[0][2][63]) && (~pos[0][2] + 64'b1 > (64'd2880 << 32))) begin
		pos_n[0] = pos_rand[0];
		vel_n[0] = vel_rand[0];
		col_n[0] = col_rand[0];
	end
	if((pos[1][2][63]) && (~pos[1][2] + 64'b1 > (64'd2880 << 32))) begin
		pos_n[1] = pos_rand[1];
		vel_n[1] = vel_rand[1];
		col_n[1] = col_rand[1];
	end
	if((pos[2][2][63]) && (~pos[2][2] + 64'b1 > (64'd2880 << 32))) begin
		pos_n[2] = pos_rand[2];
		vel_n[2] = vel_rand[2];
		col_n[2] = col_rand[2];
	end
	if((pos[3][2][63]) && (~pos[3][2] + 64'b1 > (64'd2880 << 32))) begin
		pos_n[3] = pos_rand[3];
		vel_n[3] = vel_rand[3];
		col_n[3] = col_rand[3];
	end
	
end


endmodule

