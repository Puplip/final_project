module ps2m(input clk,input reset, inout ps2c, inout ps2d,
output dummyc, output dummyd, output reg x,output reg y, output logic [3:0] hex, hex1);
reg [12:0]counter = 0;
reg flag = 0;
reg psd = 0;
reg selc = 0;
reg seld = 1'b0;
reg [8:0] dataout = 9'b011110100; // parity is put as one.
reg negold = 0,negnew = 0;
reg [3:0] dcount = 4'b0000 ;
reg [5:0] bcount=6'b000000;
reg initialised = 1'b0;
reg [32:0] data_in;
reg [5:0] init_count = 6'b000000;
always@(posedge clk)
begin
negnew <= ps2c; // for detecting -ve edge
negold <= negnew;
counter = counter + 1;
if((flag == 1) && (counter == 13'b1001110001000))
begin
flag = 0;
selc = 0; //give clk control to mouse
seld = 1'b1; // this makes the ps2d as zero and after this we start to txthe word
end
if(reset == 1'b1)// one or zero
begin
flag = 1;
selc = 1;
counter = 0;
psd = 0;
end
if((selc == 0) && (negold == 1) && (negnew == 0))
begin
if(dcount < 9)
begin
psd = dataout[dcount];
end
else
begin
seld = 0; //give data control to mouse
end
dcount = dcount + 1;
end
end // end always
// initiall y give control to moise. then make seld1 for fpga
// when psd is 0 give control to mouse
assign ps2c = selc ? 1'b0 : 1'bz;
assign ps2d = seld ? psd : 1'bz;
assign dummyc = ps2c;
assign dummyd = ps2d;
always @ (negedge ps2c)
begin
if(init_count == 46)
begin
initialised = 1;
end
init_count = init_count + 1;
if(initialised == 1'b1)
begin
data_in[bcount] = ps2d;
bcount = bcount + 1;
if(bcount == 33)
begin
bcount =0;
x = data_in[24];
y = data_in[25];
hex = data_in[3:0];
hex1 = data_in[7:4];
end
end
end // end always
// end
endmodule












/**
module ps2_mouse_controller(
 input logic Clk, Reset,
 inout wire PS2_MSCLK,
 inout wire PS2_MSDAT,
 output logic Mouse_LeftClick, Mouse_RightClick,
 output logic [8:0] Mouse_dx, Mouse_dy,
 output logic Data_Out,
 output logic [3:0] hex, hex1
);

 logic [32:0] Bytes,Bytes_n;
 logic PSCLK_OLD,PSCLK_NEW;
 logic PS_FALL;
 logic [7:0] Count, Count_n;
 
 logic Mouse_LeftClick_n, Mouse_RightClick_n;
 logic [15:0] Mouse_dx_n, Mouse_dy_n;
 logic Data_Out_n;

 logic [8:0] X_Move, Y_Move;
 logic [15:0] X_Move_Signed, Y_Move_Signed;
 logic Y_Overflow,X_Overflow,Y_Sign,X_Sign;
 logic Mouse3,Mouse2,Mouse1;
 
 
 enum logic[7:0] {
 Wait=8'd0,
 One=8'd1,
 TwoThree=8'd2,
 Four=8'd3,
 Five=8'd4,
 Six=8'd5,
 Seven=8'd6,
 Nine=8'd7,
 TenEleven=8'd8,
 Twelve=8'd9,
 Read=8'd10
 } next_state, curr_state;
 
 logic[27:0] count, count_n;
 logic[8:0] send_data = 9'h0F4;
 logic seld, selc, psd;
 
 assign PS2_MSCLK = selc ? 1'b0 : 1'bz;
 assign PS2_MSDAT = seld ? psd : 1'bz;

 
 always_ff @ (posedge Clk) begin
  
  //next_state = curr_state;
  //count_n = count;
  //PS2_MSDAT = 1'bZ;
  //PS2_MSCLK = 1'bZ;
  
  hex = curr_state[3:0];
  hex1 = count[3:0];
  

  
  case (curr_state)
   Wait: begin
    if (PS2_MSCLK & PS2_MSDAT) next_state = One;
   end
   One: begin
    selc = 1'b1;
    count = count + 1;
    if (count == 27'd100000000) begin 
     next_state = Four;
     count = 16'd0;
     selc = 0;
     seld = 1'b1;
    end
    
   end
   TwoThree: begin
    next_state = Four;
    
   end
   Four: begin
    if (PS2_MSCLK == 0) begin
     next_state = Six;
    end
   end
   Six: begin
    psd = send_data[count];
   
    next_state = Four;
    
    if (PS2_MSCLK == 1'b1) begin
     if (count == 16'd9) begin 
      next_state = Seven;
      //count = 16'd0;
     end else begin
      count = count + 1;
     end
    end else
     next_state = Six;
   end
   Seven: begin
    if (PS2_MSCLK == 1'b0) next_state = Nine;
    
   end
   Nine: begin
    seld = 0;
    next_state = TenEleven;
    
   end
   TenEleven: begin
    if (PS2_MSCLK == 1'b0 & PS2_MSDAT == 1'b0)
     next_state = Twelve;
    
   end
   Twelve: begin
    //if (PS2_MSCLK == 1'b1 & PS2_MSDAT == 1'b1)
     next_state = Read;
    
   end
  endcase
  
  if (Reset) begin
   curr_state = Wait;
   selc = 1'b0;
   seld = 0;
   psd = 0;
   count = 0;
  end else begin
   curr_state = next_state;
  end
 end
 
 
 always_ff @ (posedge Clk or posedge Reset) begin
  if(Reset)begin
   //the PS/2 Clk is basically an active low signal as data is only valid when the Clk is low.
   PSCLK_NEW = 1'b1;
   PSCLK_OLD = 1'b1;
   
   //next values
   Bytes = 0;
   Count = 0;
   Mouse_LeftClick = Mouse_LeftClick_n;
   Mouse_RightClick = Mouse_RightClick_n;
   Mouse_dx = Mouse_dx_n;
   Mouse_dy = Mouse_dy_n;
   Data_Out = Data_Out_n;
  end else begin
   //sample the PS2 Clock
   PSCLK_NEW = PS2_MSCLK;
   PSCLK_OLD = PSCLK_NEW;
   
   //next values
   Bytes = Bytes_n;
   
   //reset the clock
   Count = (Count == 8'd33)?0:Count_n;
  end
 end
 
 //detect the falling edge
 assign PS_FALL = PSCLK_OLD & (~PSCLK_NEW);
 
 //signals for mouse data from packet
 assign Mouse1 = Bytes[24];
 assign Mouse2 = Bytes[25];
 assign Mouse3 = Bytes[26];
 assign X_Sign = Bytes[28];
 assign Y_Sign = Bytes[29];
 assign X_Overflow = Bytes[30];
 assign Y_Overflow = Bytes[31];
 assign X_Move = Bytes[20:13];
 assign Y_Move = Bytes[9:2];
 
 //appropriatly sign the magnitudes
 assign X_Move_Signed = (X_Sign)?(~{1'b0,X_Move})+1:{1'b0,X_Move};
 assign Y_Move_Signed = (Y_Sign)?(~{1'b0,Y_Move})+1:{1'b0,Y_Move};
 
 always_comb begin
 //defaults
 Bytes_n = Bytes;
 Count_n = Count;
 Mouse_dx_n = 0;
 Mouse_dy_n = 0;
 Mouse_LeftClick_n = 0;
 Mouse_RightClick_n = 0;
 Data_Out_n = 0;
 if(curr_state == Read) begin
  
  //on the falling edge, read the data and count the bits
  if(PS_FALL) begin
   Bytes_n = {Bytes << 1,PS2_MSDAT};
   Count_n = Count+1;
  end
  
  //when 33 bits have been recieved, output the data
  if(Count == 8'd33) begin
   //if it overflows, ignore the data
   Mouse_dx_n = (X_Overflow)?(0):X_Move_Signed;
   Mouse_dy_n = (Y_Overflow)?(0):Y_Move_Signed;
   
   //mouse buttons
   Mouse_LeftClick_n = Mouse1;
   Mouse_RightClick_n = Mouse2;
   
   //this bit tells the outside world to read the data
   Data_Out_n = 1'b1;
  end
 end
 end
endmodule
**/