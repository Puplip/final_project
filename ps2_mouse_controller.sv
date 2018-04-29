//http://www.parthmehta.in/pdfs/PS2_Mouse_Interface.pdf
//we used this website as inspiration although most all the
//code is original (for example we used a state machine to 
//init the mouse)

module ps2_mouse_controller(
 input logic Clk, Reset,
 inout PS2_MSCLK,
 inout PS2_MSDAT,
 output logic Mouse_LeftClick, Mouse_RightClick,
 output logic [8:0] Mouse_dx, Mouse_dy,
 output logic [3:0] hex,
 output logic packetReceived
);

 logic [7:0] Count, Count_n;
 logic firstTime = 1'b1;

 logic [7:0] X_Move, Y_Move;
 logic [8:0] X_Move_Signed, Y_Move_Signed;
 logic Y_Overflow,X_Overflow,Y_Sign,X_Sign;
 logic Mouse3,Mouse2,Mouse1;
 
 
 enum logic[7:0] {
 Wait=8'd0,
 One=8'd1,
 Two=8'd2,
 Four=8'd3,
 Six=8'd5,
 Seven=8'd6,
 Nine=8'd7,
 TenEleven=8'd8,
 Read=8'd10,
 Twelve=8'd12
 } next_state, curr_state;
 
 logic[27:0] count, count_n;
 logic[8:0] send_data = 9'b011110100;
 logic seld, selc, psd;
 
assign PS2_MSCLK = selc ? 1'b0 : 1'bz;
assign PS2_MSDAT = seld ? psd : 1'bz;
 
logic [5:0] bcount = 6'd10;
logic [32:0] Bytes;

 
 always_ff @ (posedge Clk) begin

	if (firstTime) begin
		firstTime = 1'b0;
		curr_state = One;
		next_state = One;
		selc = 1'b0;
		seld = 1'b0;
		psd = 1'b0;
		count = 27'd0;
	end else begin
  case (curr_state)
   One: begin
    selc = 1'b1;
    count = count + 27'd1;
    if (count == 27'd1000000) begin 
     next_state = Two;
	  psd = 0;
     seld = 1'b1;
     count = 27'd0;
     selc = 1'b0;
    end
    
   end
	Two: begin
		if (PS2_MSCLK == 1'b1)
			next_state = Four;
	end
   Four: begin
    if (PS2_MSCLK == 1'b0) begin
     next_state = Six;
    end
   end
   Six: begin
    psd = send_data[count];
    if (PS2_MSCLK == 1'b1) begin
	  next_state = Four;
     if (count == 27'd8) begin 
      next_state = Seven;
      count = 27'd0;
     end else begin
      count = count + 27'd1;
     end
    end
   end
   Seven: begin
    if (PS2_MSCLK == 1'b0) next_state = Nine;
    
   end
   Nine: begin
    seld = 0;
    next_state = TenEleven;
    
   end
   TenEleven: begin
    if (PS2_MSDAT == 1'b0)
		next_state = Twelve;
    
   end
	Twelve: begin
		if (PS2_MSCLK == 1'b0)
			next_state = Read;
	end
  endcase
  
  if (Reset) begin
   curr_state = One;
	next_state = One;
   selc = 1'b0;
   seld = 1'b0;
   psd = 1'b0;
   count = 27'd0;
  end else begin
   curr_state = next_state;
  end
  end
  
 end
 
 
 always_ff @ (negedge PS2_MSCLK or posedge Reset) begin

  if (Reset) begin
		bcount = 6'd10;
	end else if (curr_state == Read) begin
		packetReceived = 1'b0;
		Bytes[bcount] = PS2_MSDAT;
		bcount = bcount + 1'b1;
		
		if(bcount == 6'd33)
		begin
			bcount = 0;
			packetReceived = 1'b1;
			Mouse1 = Bytes[23];
			Mouse2 = Bytes[24];
			Mouse3 = Bytes[25];
			X_Sign = Bytes[27];
			Y_Sign = Bytes[28];
			X_Overflow = Bytes[29];
			Y_Overflow = Bytes[30];
			X_Move = Bytes[8:1];
			Y_Move = Bytes[19:12];
		end
		
	end
 end
 
assign X_Move_Signed = {X_Move[7],X_Move};
assign Y_Move_Signed = {Y_Move[7],Y_Move};
 
assign Mouse_dx = (X_Overflow)?(9'b0):X_Move_Signed;
assign Mouse_dy = (Y_Overflow)?(9'b0):Y_Move_Signed;

//mouse buttons
assign Mouse_LeftClick = Mouse1;
assign Mouse_RightClick = Mouse2;
 
endmodule 