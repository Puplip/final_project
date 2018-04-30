module increment_write(
	input logic [9:0] WriteX, WriteY,
	output logic [9:0] WriteX_inc, WriteY_inc
);

parameter [9:0] H_TOTAL = 10'd640;
parameter [9:0] V_TOTAL = 10'd480;

logic [9:0] h_counter_in, v_counter_in, h_counter, v_counter;

logic Frame_Clk_in;

assign WriteX_inc = h_counter_in;
assign WriteY_inc = v_counter_in;

assign h_counter = WriteX;
assign v_counter = WriteY;

always_comb begin
	h_counter_in = h_counter + 10'd1;
   v_counter_in = v_counter;
   if(h_counter + 10'd1 == H_TOTAL)
   begin
	 	h_counter_in = 10'd0;
		if(v_counter + 10'd1 == V_TOTAL) begin
			 v_counter_in = 10'd0;
		end
		else
			 v_counter_in = v_counter + 10'd1;
   end

end

endmodule 