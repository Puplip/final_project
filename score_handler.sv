module score_handler (
	input logic Clk, Frame_Clk, Reset,
	input logic Hit,
	input logic [3:0] Dropped,
	output logic [15:0] Score,
	output logic [15:0] Lives
);

logic [15:0] Score_n, Lives_n, Dropped_Count;
logic Frame_Clk_old, Frame_Clk_posedge;

assign Dropped_Count = {15'd0,Dropped[0]} + {15'd0,Dropped[1]} + {15'd0,Dropped[2]} + {15'd0,Dropped[3]};

assign Frame_Clk_posedge = ~Frame_Clk_old && Frame_Clk;

always_ff @ (posedge Clk) begin
	if(Reset) begin
		Score <= 16'd0;
		Lives <= 16'd10;
		Frame_Clk_old <= 1'b1;
	end else begin
		Score <= Score_n;
		Lives <= Lives_n;
		Frame_Clk_old <= Frame_Clk;
	end
end

always_comb begin
	Score_n = Score;
	Lives_n = Lives;
	if(Frame_Clk_posedge) begin
		if(Hit) begin
			Score_n = Score + 16'd1;
		end
		if(Dropped_Count != 16'b0) begin
			Lives_n = Lives - Dropped_Count;
		end
	end
end

endmodule
