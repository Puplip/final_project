module increment_write(
	input logic Clk, Reset,
	output logic [9:0] WriteX, WriteY,
	output logic Frame_Clk
);

parameter [9:0] H_TOTAL = 10'd640;
parameter [9:0] V_TOTAL = 10'd480;

logic [9:0] h_counter_in, v_counter_in, h_counter, v_counter;

logic Frame_Clk_in;

assign WriteX = h_counter;
assign WriteY = v_counter;

 always_ff @ (posedge Clk or posedge Reset)
 begin
	  if (Reset)
	  begin
			h_counter <= 10'd0;
			v_counter <= 10'd0;
			Frame_Clk <= 1'b0;
	  end
	  else
	  begin
			h_counter <= h_counter_in;
			v_counter <= v_counter_in;
			Frame_Clk <= Frame_Clk_in;
	  end
 end

always_comb begin

	h_counter_in = h_counter + 10'd1;
   v_counter_in = v_counter;
	Frame_Clk_in = Frame_Clk;
   if(h_counter + 10'd1 == H_TOTAL)
   begin
	 	h_counter_in = 10'd0;
		Frame_Clk_in = 1'b0;
		if(v_counter + 10'd1 == V_TOTAL) begin
			 v_counter_in = 10'd0;
			 Frame_Clk_in = 1'b1;
		end
		else
			 v_counter_in = v_counter + 10'd1;
   end

end

endmodule 