typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module ang_lut (
	input logic Clk,
	input logic [9:0] WriteX, WriteY,
	output fixed_real dTheta, dPhi
);

logic [9:0] inx_0,iny_0;
logic [8:0] inx, iny;
logic [31:0] dTheta_raw, y_scaler_raw, y_raw;
fixed_real y_scaler, y, dPhi_unsigned, dTheta_unsigned;

assign inx_0 = (WriteX >= 10'd320)?WriteX-10'd320:10'd320-WriteX;
assign inx = inx_0[8:0];
assign iny_0 = (WriteY >= 10'd240)?WriteY-10'd240:10'd240-WriteY;
assign iny = iny_0[8:0];
assign dTheta_unsigned = {26'd0,dTheta_raw,6'd0};
assign dTheta = (WriteX >= 10'd320)?dTheta_unsigned:(~dTheta_unsigned) + 64'd1;
assign y_scaler = {31'd0,y_scaler_raw,1'b0};
assign y = {26'd0,y_raw,6'b0};
assign dPhi = (WriteY >= 10'd240)?dPhi_unsigned:(~dPhi_unsigned) + 64'd1;

mult_real m(.a(y_scaler),.b(y),.c(dPhi_unsigned));

/*
function tobin(a){
	var str = Math.round(a * Math.pow(2,26));
	return str.toString(16);
}

var out = "always_ff @ (negedge Clk) begin\ncase (in)\n";
for(var i = 0; i <= 320; i++) {
		out += "9'd" + (i) + ": dTheta_raw <= 32'h"+tobin(Math.atan(i/240)/Math.PI*180)+";    ";
		if(!(i % 3)){
			out += "\n";
		}
}
out += "\nendcase\nend\n";
console.log(out);
*/
always_ff @ (negedge Clk) begin
case (inx)
9'd0: dTheta_raw <= 32'h0;    
9'd1: dTheta_raw <= 32'hf475e8;    9'd2: dTheta_raw <= 32'h1e8e9a5;    9'd3: dTheta_raw <= 32'h2dd5908;    
9'd4: dTheta_raw <= 32'h3d1c1e8;    9'd5: dTheta_raw <= 32'h4c62217;    9'd6: dTheta_raw <= 32'h5ba776c;    
9'd7: dTheta_raw <= 32'h6aebfbb;    9'd8: dTheta_raw <= 32'h7a2f8db;    9'd9: dTheta_raw <= 32'h89720a2;    
9'd10: dTheta_raw <= 32'h98b34e9;    9'd11: dTheta_raw <= 32'ha7f3389;    9'd12: dTheta_raw <= 32'hb731a5b;    
9'd13: dTheta_raw <= 32'hc66e73b;    9'd14: dTheta_raw <= 32'hd5a9806;    9'd15: dTheta_raw <= 32'he4e2a99;    
9'd16: dTheta_raw <= 32'hf419cd5;    9'd17: dTheta_raw <= 32'h1034ec9c;    9'd18: dTheta_raw <= 32'h112817cf;    
9'd19: dTheta_raw <= 32'h121b1c56;    9'd20: dTheta_raw <= 32'h130df816;    9'd21: dTheta_raw <= 32'h1400a8fa;    
9'd22: dTheta_raw <= 32'h14f32ced;    9'd23: dTheta_raw <= 32'h15e581dd;    9'd24: dTheta_raw <= 32'h16d7a5ba;    
9'd25: dTheta_raw <= 32'h17c99678;    9'd26: dTheta_raw <= 32'h18bb520c;    9'd27: dTheta_raw <= 32'h19acd66e;    
9'd28: dTheta_raw <= 32'h1a9e2199;    9'd29: dTheta_raw <= 32'h1b8f318d;    9'd30: dTheta_raw <= 32'h1c800449;    
9'd31: dTheta_raw <= 32'h1d7097d3;    9'd32: dTheta_raw <= 32'h1e60ea31;    9'd33: dTheta_raw <= 32'h1f50f96f;    
9'd34: dTheta_raw <= 32'h2040c39a;    9'd35: dTheta_raw <= 32'h213046c5;    9'd36: dTheta_raw <= 32'h221f8105;    
9'd37: dTheta_raw <= 32'h230e7073;    9'd38: dTheta_raw <= 32'h23fd132a;    9'd39: dTheta_raw <= 32'h24eb674d;    
9'd40: dTheta_raw <= 32'h25d96afe;    9'd41: dTheta_raw <= 32'h26c71c67;    9'd42: dTheta_raw <= 32'h27b479b4;    
9'd43: dTheta_raw <= 32'h28a18115;    9'd44: dTheta_raw <= 32'h298e30be;    9'd45: dTheta_raw <= 32'h2a7a86ea;    
9'd46: dTheta_raw <= 32'h2b6681d4;    9'd47: dTheta_raw <= 32'h2c521fbf;    9'd48: dTheta_raw <= 32'h2d3d5ef0;    
9'd49: dTheta_raw <= 32'h2e283db3;    9'd50: dTheta_raw <= 32'h2f12ba55;    9'd51: dTheta_raw <= 32'h2ffcd32c;    
9'd52: dTheta_raw <= 32'h30e6868f;    9'd53: dTheta_raw <= 32'h31cfd2db;    9'd54: dTheta_raw <= 32'h32b8b673;    
9'd55: dTheta_raw <= 32'h33a12fbd;    9'd56: dTheta_raw <= 32'h34893d25;    9'd57: dTheta_raw <= 32'h3570dd1b;    
9'd58: dTheta_raw <= 32'h36580e14;    9'd59: dTheta_raw <= 32'h373ece8c;    9'd60: dTheta_raw <= 32'h38251d02;    
9'd61: dTheta_raw <= 32'h390af7fa;    9'd62: dTheta_raw <= 32'h39f05dff;    9'd63: dTheta_raw <= 32'h3ad54d9e;    
9'd64: dTheta_raw <= 32'h3bb9c56d;    9'd65: dTheta_raw <= 32'h3c9dc404;    9'd66: dTheta_raw <= 32'h3d814802;    
9'd67: dTheta_raw <= 32'h3e64500b;    9'd68: dTheta_raw <= 32'h3f46dac7;    9'd69: dTheta_raw <= 32'h4028e6e6;    
9'd70: dTheta_raw <= 32'h410a731a;    9'd71: dTheta_raw <= 32'h41eb7e1e;    9'd72: dTheta_raw <= 32'h42cc06ae;    
9'd73: dTheta_raw <= 32'h43ac0b90;    9'd74: dTheta_raw <= 32'h448b8b8b;    9'd75: dTheta_raw <= 32'h456a856f;    
9'd76: dTheta_raw <= 32'h4648f810;    9'd77: dTheta_raw <= 32'h4726e246;    9'd78: dTheta_raw <= 32'h480442f1;    
9'd79: dTheta_raw <= 32'h48e118f4;    9'd80: dTheta_raw <= 32'h49bd6339;    9'd81: dTheta_raw <= 32'h4a9920b0;    
9'd82: dTheta_raw <= 32'h4b74504c;    9'd83: dTheta_raw <= 32'h4c4ef107;    9'd84: dTheta_raw <= 32'h4d2901e0;    
9'd85: dTheta_raw <= 32'h4e0281dd;    9'd86: dTheta_raw <= 32'h4edb7005;    9'd87: dTheta_raw <= 32'h4fb3cb6b;    
9'd88: dTheta_raw <= 32'h508b9320;    9'd89: dTheta_raw <= 32'h5162c641;    9'd90: dTheta_raw <= 32'h523963eb;    
9'd91: dTheta_raw <= 32'h530f6b44;    9'd92: dTheta_raw <= 32'h53e4db76;    9'd93: dTheta_raw <= 32'h54b9b3af;    
9'd94: dTheta_raw <= 32'h558df324;    9'd95: dTheta_raw <= 32'h56619910;    9'd96: dTheta_raw <= 32'h5734a4b0;    
9'd97: dTheta_raw <= 32'h58071549;    9'd98: dTheta_raw <= 32'h58d8ea25;    9'd99: dTheta_raw <= 32'h59aa2291;    
9'd100: dTheta_raw <= 32'h5a7abde0;    9'd101: dTheta_raw <= 32'h5b4abb6d;    9'd102: dTheta_raw <= 32'h5c1a1a94;    
9'd103: dTheta_raw <= 32'h5ce8dab7;    9'd104: dTheta_raw <= 32'h5db6fb3f;    9'd105: dTheta_raw <= 32'h5e847b99;    
9'd106: dTheta_raw <= 32'h5f515b34;    9'd107: dTheta_raw <= 32'h601d9989;    9'd108: dTheta_raw <= 32'h60e93612;    
9'd109: dTheta_raw <= 32'h61b4304f;    9'd110: dTheta_raw <= 32'h627e87c4;    9'd111: dTheta_raw <= 32'h63483bfd;    
9'd112: dTheta_raw <= 32'h64114c86;    9'd113: dTheta_raw <= 32'h64d9b8f3;    9'd114: dTheta_raw <= 32'h65a180db;    
9'd115: dTheta_raw <= 32'h6668a3da;    9'd116: dTheta_raw <= 32'h672f2192;    9'd117: dTheta_raw <= 32'h67f4f9a6;    
9'd118: dTheta_raw <= 32'h68ba2bc1;    9'd119: dTheta_raw <= 32'h697eb790;    9'd120: dTheta_raw <= 32'h6a429cc7;    
9'd121: dTheta_raw <= 32'h6b05db1a;    9'd122: dTheta_raw <= 32'h6bc87247;    9'd123: dTheta_raw <= 32'h6c8a620b;    
9'd124: dTheta_raw <= 32'h6d4baa29;    9'd125: dTheta_raw <= 32'h6e0c4a6a;    9'd126: dTheta_raw <= 32'h6ecc429a;    
9'd127: dTheta_raw <= 32'h6f8b9286;    9'd128: dTheta_raw <= 32'h704a3a04;    9'd129: dTheta_raw <= 32'h710838ea;    
9'd130: dTheta_raw <= 32'h71c58f15;    9'd131: dTheta_raw <= 32'h72823c63;    9'd132: dTheta_raw <= 32'h733e40b7;    
9'd133: dTheta_raw <= 32'h73f99bf9;    9'd134: dTheta_raw <= 32'h74b44e12;    9'd135: dTheta_raw <= 32'h756e56f2;    
9'd136: dTheta_raw <= 32'h7627b689;    9'd137: dTheta_raw <= 32'h76e06cce;    9'd138: dTheta_raw <= 32'h779879b9;    
9'd139: dTheta_raw <= 32'h784fdd47;    9'd140: dTheta_raw <= 32'h79069777;    9'd141: dTheta_raw <= 32'h79bca84c;    
9'd142: dTheta_raw <= 32'h7a720fcd;    9'd143: dTheta_raw <= 32'h7b26ce04;    9'd144: dTheta_raw <= 32'h7bdae2fe;    
9'd145: dTheta_raw <= 32'h7c8e4eca;    9'd146: dTheta_raw <= 32'h7d41117d;    9'd147: dTheta_raw <= 32'h7df32b2b;    
9'd148: dTheta_raw <= 32'h7ea49bef;    9'd149: dTheta_raw <= 32'h7f5563e6;    9'd150: dTheta_raw <= 32'h8005832d;    
9'd151: dTheta_raw <= 32'h80b4f9e8;    9'd152: dTheta_raw <= 32'h8163c83b;    9'd153: dTheta_raw <= 32'h8211ee4d;    
9'd154: dTheta_raw <= 32'h82bf6c4b;    9'd155: dTheta_raw <= 32'h836c4260;    9'd156: dTheta_raw <= 32'h841870bd;    
9'd157: dTheta_raw <= 32'h84c3f793;    9'd158: dTheta_raw <= 32'h856ed718;    9'd159: dTheta_raw <= 32'h86190f84;    
9'd160: dTheta_raw <= 32'h86c2a110;    9'd161: dTheta_raw <= 32'h876b8bf8;    9'd162: dTheta_raw <= 32'h8813d07c;    
9'd163: dTheta_raw <= 32'h88bb6edc;    9'd164: dTheta_raw <= 32'h8962675b;    9'd165: dTheta_raw <= 32'h8a08ba40;    
9'd166: dTheta_raw <= 32'h8aae67d2;    9'd167: dTheta_raw <= 32'h8b53705a;    9'd168: dTheta_raw <= 32'h8bf7d425;    
9'd169: dTheta_raw <= 32'h8c9b9380;    9'd170: dTheta_raw <= 32'h8d3eaebc;    9'd171: dTheta_raw <= 32'h8de1262b;    
9'd172: dTheta_raw <= 32'h8e82fa21;    9'd173: dTheta_raw <= 32'h8f242af3;    9'd174: dTheta_raw <= 32'h8fc4b8f9;    
9'd175: dTheta_raw <= 32'h9064a48d;    9'd176: dTheta_raw <= 32'h9103ee0a;    9'd177: dTheta_raw <= 32'h91a295cd;    
9'd178: dTheta_raw <= 32'h92409c34;    9'd179: dTheta_raw <= 32'h92de01a0;    9'd180: dTheta_raw <= 32'h937ac673;    
9'd181: dTheta_raw <= 32'h9416eb10;    9'd182: dTheta_raw <= 32'h94b26fdc;    9'd183: dTheta_raw <= 32'h954d553e;    
9'd184: dTheta_raw <= 32'h95e79b9d;    9'd185: dTheta_raw <= 32'h96814364;    9'd186: dTheta_raw <= 32'h971a4cfd;    
9'd187: dTheta_raw <= 32'h97b2b8d3;    9'd188: dTheta_raw <= 32'h984a8755;    9'd189: dTheta_raw <= 32'h98e1b8f1;    
9'd190: dTheta_raw <= 32'h99784e17;    9'd191: dTheta_raw <= 32'h9a0e4738;    9'd192: dTheta_raw <= 32'h9aa3a4c6;    
9'd193: dTheta_raw <= 32'h9b386736;    9'd194: dTheta_raw <= 32'h9bcc8efb;    9'd195: dTheta_raw <= 32'h9c601c8b;    
9'd196: dTheta_raw <= 32'h9cf3105d;    9'd197: dTheta_raw <= 32'h9d856ae9;    9'd198: dTheta_raw <= 32'h9e172ca7;    
9'd199: dTheta_raw <= 32'h9ea85611;    9'd200: dTheta_raw <= 32'h9f38e7a1;    9'd201: dTheta_raw <= 32'h9fc8e1d3;    
9'd202: dTheta_raw <= 32'ha0584523;    9'd203: dTheta_raw <= 32'ha0e7120f;    9'd204: dTheta_raw <= 32'ha1754913;    
9'd205: dTheta_raw <= 32'ha202eab0;    9'd206: dTheta_raw <= 32'ha28ff764;    9'd207: dTheta_raw <= 32'ha31c6faf;    
9'd208: dTheta_raw <= 32'ha3a85413;    9'd209: dTheta_raw <= 32'ha433a511;    9'd210: dTheta_raw <= 32'ha4be632b;    
9'd211: dTheta_raw <= 32'ha5488ee3;    9'd212: dTheta_raw <= 32'ha5d228be;    9'd213: dTheta_raw <= 32'ha65b313f;    
9'd214: dTheta_raw <= 32'ha6e3a8ea;    9'd215: dTheta_raw <= 32'ha76b9045;    9'd216: dTheta_raw <= 32'ha7f2e7d5;    
9'd217: dTheta_raw <= 32'ha879b020;    9'd218: dTheta_raw <= 32'ha8ffe9ac;    9'd219: dTheta_raw <= 32'ha9859500;    
9'd220: dTheta_raw <= 32'haa0ab2a4;    9'd221: dTheta_raw <= 32'haa8f431e;    9'd222: dTheta_raw <= 32'hab1346f7;    
9'd223: dTheta_raw <= 32'hab96beb7;    9'd224: dTheta_raw <= 32'hac19aae6;    9'd225: dTheta_raw <= 32'hac9c0c0e;    
9'd226: dTheta_raw <= 32'had1de2b7;    9'd227: dTheta_raw <= 32'had9f2f6c;    9'd228: dTheta_raw <= 32'hae1ff2b5;    
9'd229: dTheta_raw <= 32'haea02d1c;    9'd230: dTheta_raw <= 32'haf1fdf2c;    9'd231: dTheta_raw <= 32'haf9f096e;    
9'd232: dTheta_raw <= 32'hb01dac6d;    9'd233: dTheta_raw <= 32'hb09bc8b4;    9'd234: dTheta_raw <= 32'hb1195ecd;    
9'd235: dTheta_raw <= 32'hb1966f43;    9'd236: dTheta_raw <= 32'hb212faa1;    9'd237: dTheta_raw <= 32'hb28f0171;    
9'd238: dTheta_raw <= 32'hb30a843f;    9'd239: dTheta_raw <= 32'hb3858396;    9'd240: dTheta_raw <= 32'hb4000000;    
9'd241: dTheta_raw <= 32'hb479fa09;    9'd242: dTheta_raw <= 32'hb4f3723c;    9'd243: dTheta_raw <= 32'hb56c6924;    
9'd244: dTheta_raw <= 32'hb5e4df4c;    9'd245: dTheta_raw <= 32'hb65cd53f;    9'd246: dTheta_raw <= 32'hb6d44b87;    
9'd247: dTheta_raw <= 32'hb74b42b1;    9'd248: dTheta_raw <= 32'hb7c1bb45;    9'd249: dTheta_raw <= 32'hb837b5d0;    
9'd250: dTheta_raw <= 32'hb8ad32dc;    9'd251: dTheta_raw <= 32'hb92232f3;    9'd252: dTheta_raw <= 32'hb996b6a0;    
9'd253: dTheta_raw <= 32'hba0abe6c;    9'd254: dTheta_raw <= 32'hba7e4ae2;    9'd255: dTheta_raw <= 32'hbaf15c8b;    
9'd256: dTheta_raw <= 32'hbb63f3f2;    9'd257: dTheta_raw <= 32'hbbd611a0;    9'd258: dTheta_raw <= 32'hbc47b61e;    
9'd259: dTheta_raw <= 32'hbcb8e1f5;    9'd260: dTheta_raw <= 32'hbd2995ae;    9'd261: dTheta_raw <= 32'hbd99d1d2;    
9'd262: dTheta_raw <= 32'hbe0996e9;    9'd263: dTheta_raw <= 32'hbe78e57c;    9'd264: dTheta_raw <= 32'hbee7be12;    
9'd265: dTheta_raw <= 32'hbf562133;    9'd266: dTheta_raw <= 32'hbfc40f66;    9'd267: dTheta_raw <= 32'hc0318933;    
9'd268: dTheta_raw <= 32'hc09e8f21;    9'd269: dTheta_raw <= 32'hc10b21b5;    9'd270: dTheta_raw <= 32'hc1774177;    
9'd271: dTheta_raw <= 32'hc1e2eeec;    9'd272: dTheta_raw <= 32'hc24e2a99;    9'd273: dTheta_raw <= 32'hc2b8f505;    
9'd274: dTheta_raw <= 32'hc3234eb4;    9'd275: dTheta_raw <= 32'hc38d382a;    9'd276: dTheta_raw <= 32'hc3f6b1ec;    
9'd277: dTheta_raw <= 32'hc45fbc7f;    9'd278: dTheta_raw <= 32'hc4c85865;    9'd279: dTheta_raw <= 32'hc5308621;    
9'd280: dTheta_raw <= 32'hc5984637;    9'd281: dTheta_raw <= 32'hc5ff992a;    9'd282: dTheta_raw <= 32'hc6667f7a;    
9'd283: dTheta_raw <= 32'hc6ccf9ab;    9'd284: dTheta_raw <= 32'hc733083d;    9'd285: dTheta_raw <= 32'hc798abb1;    
9'd286: dTheta_raw <= 32'hc7fde488;    9'd287: dTheta_raw <= 32'hc862b342;    9'd288: dTheta_raw <= 32'hc8c7185f;    
9'd289: dTheta_raw <= 32'hc92b145e;    9'd290: dTheta_raw <= 32'hc98ea7be;    9'd291: dTheta_raw <= 32'hc9f1d2fd;    
9'd292: dTheta_raw <= 32'hca54969a;    9'd293: dTheta_raw <= 32'hcab6f313;    9'd294: dTheta_raw <= 32'hcb18e8e4;    
9'd295: dTheta_raw <= 32'hcb7a788a;    9'd296: dTheta_raw <= 32'hcbdba282;    9'd297: dTheta_raw <= 32'hcc3c6747;    
9'd298: dTheta_raw <= 32'hcc9cc756;    9'd299: dTheta_raw <= 32'hccfcc328;    9'd300: dTheta_raw <= 32'hcd5c5b3a;    
9'd301: dTheta_raw <= 32'hcdbb9004;    9'd302: dTheta_raw <= 32'hce1a6200;    9'd303: dTheta_raw <= 32'hce78d1a9;    
9'd304: dTheta_raw <= 32'hced6df76;    9'd305: dTheta_raw <= 32'hcf348be0;    9'd306: dTheta_raw <= 32'hcf91d75e;    
9'd307: dTheta_raw <= 32'hcfeec268;    9'd308: dTheta_raw <= 32'hd04b4d76;    9'd309: dTheta_raw <= 32'hd0a778fd;    
9'd310: dTheta_raw <= 32'hd1034573;    9'd311: dTheta_raw <= 32'hd15eb34e;    9'd312: dTheta_raw <= 32'hd1b9c303;    
9'd313: dTheta_raw <= 32'hd2147506;    9'd314: dTheta_raw <= 32'hd26ec9cc;    9'd315: dTheta_raw <= 32'hd2c8c1c8;    
9'd316: dTheta_raw <= 32'hd3225d6e;    9'd317: dTheta_raw <= 32'hd37b9d2f;    9'd318: dTheta_raw <= 32'hd3d4817e;    
9'd319: dTheta_raw <= 32'hd42d0acd;    9'd320: dTheta_raw <= 32'hd485398d;    
endcase
end


/*
function tobin(a){
	var str = Math.round(a * Math.pow(2,31));
	return str.toString(16);
}

var out = "always_ff @ (negedge Clk) begin\ncase (in)\n";
for(var i = 0; i <= 320; i++) {
		out += "9'd" + (i) + ": y_scaler_raw <= 32'h"+tobin(Math.atan(240/Math.sqrt(i*i+240*240))/Math.PI*4)+";    ";
		if(!(i % 5)){
			out += "\n";
		}
}
out += "\nendcase\nend\n";
console.log(out);
*/
always_ff @ (negedge Clk) begin
case (inx)
9'd0: y_scaler_raw <= 32'h80000000;    
9'd1: y_scaler_raw <= 32'h7fffd1a5;    9'd2: y_scaler_raw <= 32'h7fff4694;    9'd3: y_scaler_raw <= 32'h7ffe5ed1;    9'd4: y_scaler_raw <= 32'h7ffd1a63;    9'd5: y_scaler_raw <= 32'h7ffb7952;    
9'd6: y_scaler_raw <= 32'h7ff97ba9;    9'd7: y_scaler_raw <= 32'h7ff72176;    9'd8: y_scaler_raw <= 32'h7ff46ac9;    9'd9: y_scaler_raw <= 32'h7ff157b4;    9'd10: y_scaler_raw <= 32'h7fede84c;    
9'd11: y_scaler_raw <= 32'h7fea1ca9;    9'd12: y_scaler_raw <= 32'h7fe5f4e4;    9'd13: y_scaler_raw <= 32'h7fe1711a;    9'd14: y_scaler_raw <= 32'h7fdc9169;    9'd15: y_scaler_raw <= 32'h7fd755f2;    
9'd16: y_scaler_raw <= 32'h7fd1beda;    9'd17: y_scaler_raw <= 32'h7fcbcc45;    9'd18: y_scaler_raw <= 32'h7fc57e5c;    9'd19: y_scaler_raw <= 32'h7fbed54a;    9'd20: y_scaler_raw <= 32'h7fb7d13b;    
9'd21: y_scaler_raw <= 32'h7fb0725f;    9'd22: y_scaler_raw <= 32'h7fa8b8e7;    9'd23: y_scaler_raw <= 32'h7fa0a508;    9'd24: y_scaler_raw <= 32'h7f9836f7;    9'd25: y_scaler_raw <= 32'h7f8f6eee;    
9'd26: y_scaler_raw <= 32'h7f864d26;    9'd27: y_scaler_raw <= 32'h7f7cd1dd;    9'd28: y_scaler_raw <= 32'h7f72fd52;    9'd29: y_scaler_raw <= 32'h7f68cfc7;    9'd30: y_scaler_raw <= 32'h7f5e497f;    
9'd31: y_scaler_raw <= 32'h7f536abf;    9'd32: y_scaler_raw <= 32'h7f4833d1;    9'd33: y_scaler_raw <= 32'h7f3ca4fe;    9'd34: y_scaler_raw <= 32'h7f30be92;    9'd35: y_scaler_raw <= 32'h7f2480db;    
9'd36: y_scaler_raw <= 32'h7f17ec2a;    9'd37: y_scaler_raw <= 32'h7f0b00d1;    9'd38: y_scaler_raw <= 32'h7efdbf25;    9'd39: y_scaler_raw <= 32'h7ef0277c;    9'd40: y_scaler_raw <= 32'h7ee23a2e;    
9'd41: y_scaler_raw <= 32'h7ed3f796;    9'd42: y_scaler_raw <= 32'h7ec56010;    9'd43: y_scaler_raw <= 32'h7eb673fa;    9'd44: y_scaler_raw <= 32'h7ea733b3;    9'd45: y_scaler_raw <= 32'h7e979f9f;    
9'd46: y_scaler_raw <= 32'h7e87b81f;    9'd47: y_scaler_raw <= 32'h7e777d9b;    9'd48: y_scaler_raw <= 32'h7e66f079;    9'd49: y_scaler_raw <= 32'h7e561121;    9'd50: y_scaler_raw <= 32'h7e44dfff;    
9'd51: y_scaler_raw <= 32'h7e335d7f;    9'd52: y_scaler_raw <= 32'h7e218a0f;    9'd53: y_scaler_raw <= 32'h7e0f661e;    9'd54: y_scaler_raw <= 32'h7dfcf21d;    9'd55: y_scaler_raw <= 32'h7dea2e7f;    
9'd56: y_scaler_raw <= 32'h7dd71bb9;    9'd57: y_scaler_raw <= 32'h7dc3ba40;    9'd58: y_scaler_raw <= 32'h7db00a8b;    9'd59: y_scaler_raw <= 32'h7d9c0d13;    9'd60: y_scaler_raw <= 32'h7d87c252;    
9'd61: y_scaler_raw <= 32'h7d732ac4;    9'd62: y_scaler_raw <= 32'h7d5e46e4;    9'd63: y_scaler_raw <= 32'h7d491732;    9'd64: y_scaler_raw <= 32'h7d339c2c;    9'd65: y_scaler_raw <= 32'h7d1dd653;    
9'd66: y_scaler_raw <= 32'h7d07c629;    9'd67: y_scaler_raw <= 32'h7cf16c30;    9'd68: y_scaler_raw <= 32'h7cdac8ee;    9'd69: y_scaler_raw <= 32'h7cc3dce7;    9'd70: y_scaler_raw <= 32'h7caca8a2;    
9'd71: y_scaler_raw <= 32'h7c952ca6;    9'd72: y_scaler_raw <= 32'h7c7d697b;    9'd73: y_scaler_raw <= 32'h7c655fac;    9'd74: y_scaler_raw <= 32'h7c4d0fc2;    9'd75: y_scaler_raw <= 32'h7c347a49;    
9'd76: y_scaler_raw <= 32'h7c1b9fcd;    9'd77: y_scaler_raw <= 32'h7c0280db;    9'd78: y_scaler_raw <= 32'h7be91e02;    9'd79: y_scaler_raw <= 32'h7bcf77cf;    9'd80: y_scaler_raw <= 32'h7bb58ed3;    
9'd81: y_scaler_raw <= 32'h7b9b639e;    9'd82: y_scaler_raw <= 32'h7b80f6c1;    9'd83: y_scaler_raw <= 32'h7b6648cd;    9'd84: y_scaler_raw <= 32'h7b4b5a56;    9'd85: y_scaler_raw <= 32'h7b302bed;    
9'd86: y_scaler_raw <= 32'h7b14be27;    9'd87: y_scaler_raw <= 32'h7af91198;    9'd88: y_scaler_raw <= 32'h7add26d4;    9'd89: y_scaler_raw <= 32'h7ac0fe71;    9'd90: y_scaler_raw <= 32'h7aa49903;    
9'd91: y_scaler_raw <= 32'h7a87f722;    9'd92: y_scaler_raw <= 32'h7a6b1964;    9'd93: y_scaler_raw <= 32'h7a4e0060;    9'd94: y_scaler_raw <= 32'h7a30acac;    9'd95: y_scaler_raw <= 32'h7a131ee2;    
9'd96: y_scaler_raw <= 32'h79f55797;    9'd97: y_scaler_raw <= 32'h79d75765;    9'd98: y_scaler_raw <= 32'h79b91ee4;    9'd99: y_scaler_raw <= 32'h799aaeac;    9'd100: y_scaler_raw <= 32'h797c0757;    
9'd101: y_scaler_raw <= 32'h795d297d;    9'd102: y_scaler_raw <= 32'h793e15b7;    9'd103: y_scaler_raw <= 32'h791ecc9f;    9'd104: y_scaler_raw <= 32'h78ff4ece;    9'd105: y_scaler_raw <= 32'h78df9cdc;    
9'd106: y_scaler_raw <= 32'h78bfb764;    9'd107: y_scaler_raw <= 32'h789f9f00;    9'd108: y_scaler_raw <= 32'h787f5447;    9'd109: y_scaler_raw <= 32'h785ed7d4;    9'd110: y_scaler_raw <= 32'h783e2a3f;    
9'd111: y_scaler_raw <= 32'h781d4c22;    9'd112: y_scaler_raw <= 32'h77fc3e17;    9'd113: y_scaler_raw <= 32'h77db00b5;    9'd114: y_scaler_raw <= 32'h77b99495;    9'd115: y_scaler_raw <= 32'h7797fa50;    
9'd116: y_scaler_raw <= 32'h7776327f;    9'd117: y_scaler_raw <= 32'h77543db9;    9'd118: y_scaler_raw <= 32'h77321c97;    9'd119: y_scaler_raw <= 32'h770fcfaf;    9'd120: y_scaler_raw <= 32'h76ed579a;    
9'd121: y_scaler_raw <= 32'h76cab4ed;    9'd122: y_scaler_raw <= 32'h76a7e841;    9'd123: y_scaler_raw <= 32'h7684f22a;    9'd124: y_scaler_raw <= 32'h7661d33f;    9'd125: y_scaler_raw <= 32'h763e8c16;    
9'd126: y_scaler_raw <= 32'h761b1d43;    9'd127: y_scaler_raw <= 32'h75f7875c;    9'd128: y_scaler_raw <= 32'h75d3caf4;    9'd129: y_scaler_raw <= 32'h75afe89f;    9'd130: y_scaler_raw <= 32'h758be0f1;    
9'd131: y_scaler_raw <= 32'h7567b47c;    9'd132: y_scaler_raw <= 32'h754363d3;    9'd133: y_scaler_raw <= 32'h751eef87;    9'd134: y_scaler_raw <= 32'h74fa582a;    9'd135: y_scaler_raw <= 32'h74d59e4c;    
9'd136: y_scaler_raw <= 32'h74b0c27d;    9'd137: y_scaler_raw <= 32'h748bc54d;    9'd138: y_scaler_raw <= 32'h7466a74b;    9'd139: y_scaler_raw <= 32'h74416905;    9'd140: y_scaler_raw <= 32'h741c0b08;    
9'd141: y_scaler_raw <= 32'h73f68de2;    9'd142: y_scaler_raw <= 32'h73d0f21e;    9'd143: y_scaler_raw <= 32'h73ab3849;    9'd144: y_scaler_raw <= 32'h738560ee;    9'd145: y_scaler_raw <= 32'h735f6c96;    
9'd146: y_scaler_raw <= 32'h73395bcc;    9'd147: y_scaler_raw <= 32'h73132f18;    9'd148: y_scaler_raw <= 32'h72ece702;    9'd149: y_scaler_raw <= 32'h72c68411;    9'd150: y_scaler_raw <= 32'h72a006cd;    
9'd151: y_scaler_raw <= 32'h72796fbb;    9'd152: y_scaler_raw <= 32'h7252bf61;    9'd153: y_scaler_raw <= 32'h722bf642;    9'd154: y_scaler_raw <= 32'h720514e2;    9'd155: y_scaler_raw <= 32'h71de1bc4;    
9'd156: y_scaler_raw <= 32'h71b70b6a;    9'd157: y_scaler_raw <= 32'h718fe455;    9'd158: y_scaler_raw <= 32'h7168a705;    9'd159: y_scaler_raw <= 32'h714153fa;    9'd160: y_scaler_raw <= 32'h7119ebb2;    
9'd161: y_scaler_raw <= 32'h70f26eac;    9'd162: y_scaler_raw <= 32'h70cadd64;    9'd163: y_scaler_raw <= 32'h70a33856;    9'd164: y_scaler_raw <= 32'h707b7ffe;    9'd165: y_scaler_raw <= 32'h7053b4d6;    
9'd166: y_scaler_raw <= 32'h702bd758;    9'd167: y_scaler_raw <= 32'h7003e7fb;    9'd168: y_scaler_raw <= 32'h6fdbe739;    9'd169: y_scaler_raw <= 32'h6fb3d588;    9'd170: y_scaler_raw <= 32'h6f8bb35d;    
9'd171: y_scaler_raw <= 32'h6f63812f;    9'd172: y_scaler_raw <= 32'h6f3b3f70;    9'd173: y_scaler_raw <= 32'h6f12ee96;    9'd174: y_scaler_raw <= 32'h6eea8f11;    9'd175: y_scaler_raw <= 32'h6ec22154;    
9'd176: y_scaler_raw <= 32'h6e99a5cf;    9'd177: y_scaler_raw <= 32'h6e711cf2;    9'd178: y_scaler_raw <= 32'h6e48872b;    9'd179: y_scaler_raw <= 32'h6e1fe4e9;    9'd180: y_scaler_raw <= 32'h6df73698;    
9'd181: y_scaler_raw <= 32'h6dce7ca5;    9'd182: y_scaler_raw <= 32'h6da5b77b;    9'd183: y_scaler_raw <= 32'h6d7ce783;    9'd184: y_scaler_raw <= 32'h6d540d28;    9'd185: y_scaler_raw <= 32'h6d2b28d0;    
9'd186: y_scaler_raw <= 32'h6d023ae5;    9'd187: y_scaler_raw <= 32'h6cd943cc;    9'd188: y_scaler_raw <= 32'h6cb043ec;    9'd189: y_scaler_raw <= 32'h6c873ba8;    9'd190: y_scaler_raw <= 32'h6c5e2b64;    
9'd191: y_scaler_raw <= 32'h6c351383;    9'd192: y_scaler_raw <= 32'h6c0bf468;    9'd193: y_scaler_raw <= 32'h6be2ce73;    9'd194: y_scaler_raw <= 32'h6bb9a204;    9'd195: y_scaler_raw <= 32'h6b906f7a;    
9'd196: y_scaler_raw <= 32'h6b673734;    9'd197: y_scaler_raw <= 32'h6b3df98f;    9'd198: y_scaler_raw <= 32'h6b14b6e7;    9'd199: y_scaler_raw <= 32'h6aeb6f97;    9'd200: y_scaler_raw <= 32'h6ac223fb;    
9'd201: y_scaler_raw <= 32'h6a98d46c;    9'd202: y_scaler_raw <= 32'h6a6f8142;    9'd203: y_scaler_raw <= 32'h6a462ad6;    9'd204: y_scaler_raw <= 32'h6a1cd17f;    9'd205: y_scaler_raw <= 32'h69f37591;    
9'd206: y_scaler_raw <= 32'h69ca1764;    9'd207: y_scaler_raw <= 32'h69a0b74a;    9'd208: y_scaler_raw <= 32'h69775598;    9'd209: y_scaler_raw <= 32'h694df29f;    9'd210: y_scaler_raw <= 32'h69248eb1;    
9'd211: y_scaler_raw <= 32'h68fb2a1f;    9'd212: y_scaler_raw <= 32'h68d1c539;    9'd213: y_scaler_raw <= 32'h68a8604d;    9'd214: y_scaler_raw <= 32'h687efbab;    9'd215: y_scaler_raw <= 32'h6855979e;    
9'd216: y_scaler_raw <= 32'h682c3473;    9'd217: y_scaler_raw <= 32'h6802d275;    9'd218: y_scaler_raw <= 32'h67d971f0;    9'd219: y_scaler_raw <= 32'h67b0132d;    9'd220: y_scaler_raw <= 32'h6786b675;    
9'd221: y_scaler_raw <= 32'h675d5c10;    9'd222: y_scaler_raw <= 32'h67340444;    9'd223: y_scaler_raw <= 32'h670aaf59;    9'd224: y_scaler_raw <= 32'h66e15d95;    9'd225: y_scaler_raw <= 32'h66b80f3a;    
9'd226: y_scaler_raw <= 32'h668ec48f;    9'd227: y_scaler_raw <= 32'h66657dd4;    9'd228: y_scaler_raw <= 32'h663c3b4e;    9'd229: y_scaler_raw <= 32'h6612fd3d;    9'd230: y_scaler_raw <= 32'h65e9c3e2;    
9'd231: y_scaler_raw <= 32'h65c08f7c;    9'd232: y_scaler_raw <= 32'h6597604b;    9'd233: y_scaler_raw <= 32'h656e368d;    9'd234: y_scaler_raw <= 32'h65451280;    9'd235: y_scaler_raw <= 32'h651bf45f;    
9'd236: y_scaler_raw <= 32'h64f2dc67;    9'd237: y_scaler_raw <= 32'h64c9cad3;    9'd238: y_scaler_raw <= 32'h64a0bfde;    9'd239: y_scaler_raw <= 32'h6477bbc0;    9'd240: y_scaler_raw <= 32'h644ebeb3;    
9'd241: y_scaler_raw <= 32'h6425c8ee;    9'd242: y_scaler_raw <= 32'h63fcdaaa;    9'd243: y_scaler_raw <= 32'h63d3f41c;    9'd244: y_scaler_raw <= 32'h63ab157b;    9'd245: y_scaler_raw <= 32'h63823efb;    
9'd246: y_scaler_raw <= 32'h635970d1;    9'd247: y_scaler_raw <= 32'h6330ab31;    9'd248: y_scaler_raw <= 32'h6307ee4e;    9'd249: y_scaler_raw <= 32'h62df3a59;    9'd250: y_scaler_raw <= 32'h62b68f84;    
9'd251: y_scaler_raw <= 32'h628dee00;    9'd252: y_scaler_raw <= 32'h626555fe;    9'd253: y_scaler_raw <= 32'h623cc7ac;    9'd254: y_scaler_raw <= 32'h6214433a;    9'd255: y_scaler_raw <= 32'h61ebc8d5;    
9'd256: y_scaler_raw <= 32'h61c358ab;    9'd257: y_scaler_raw <= 32'h619af2e9;    9'd258: y_scaler_raw <= 32'h617297ba;    9'd259: y_scaler_raw <= 32'h614a474b;    9'd260: y_scaler_raw <= 32'h612201c5;    
9'd261: y_scaler_raw <= 32'h60f9c754;    9'd262: y_scaler_raw <= 32'h60d19820;    9'd263: y_scaler_raw <= 32'h60a97452;    9'd264: y_scaler_raw <= 32'h60815c13;    9'd265: y_scaler_raw <= 32'h60594f8b;    
9'd266: y_scaler_raw <= 32'h60314edf;    9'd267: y_scaler_raw <= 32'h60095a37;    9'd268: y_scaler_raw <= 32'h5fe171b8;    9'd269: y_scaler_raw <= 32'h5fb99588;    9'd270: y_scaler_raw <= 32'h5f91c5cb;    
9'd271: y_scaler_raw <= 32'h5f6a02a4;    9'd272: y_scaler_raw <= 32'h5f424c39;    9'd273: y_scaler_raw <= 32'h5f1aa2aa;    9'd274: y_scaler_raw <= 32'h5ef3061a;    9'd275: y_scaler_raw <= 32'h5ecb76ac;    
9'd276: y_scaler_raw <= 32'h5ea3f480;    9'd277: y_scaler_raw <= 32'h5e7c7fb7;    9'd278: y_scaler_raw <= 32'h5e551870;    9'd279: y_scaler_raw <= 32'h5e2dbecc;    9'd280: y_scaler_raw <= 32'h5e0672e8;    
9'd281: y_scaler_raw <= 32'h5ddf34e4;    9'd282: y_scaler_raw <= 32'h5db804dd;    9'd283: y_scaler_raw <= 32'h5d90e2f0;    9'd284: y_scaler_raw <= 32'h5d69cf3b;    9'd285: y_scaler_raw <= 32'h5d42c9d9;    
9'd286: y_scaler_raw <= 32'h5d1bd2e6;    9'd287: y_scaler_raw <= 32'h5cf4ea7e;    9'd288: y_scaler_raw <= 32'h5cce10bb;    9'd289: y_scaler_raw <= 32'h5ca745b8;    9'd290: y_scaler_raw <= 32'h5c80898e;    
9'd291: y_scaler_raw <= 32'h5c59dc56;    9'd292: y_scaler_raw <= 32'h5c333e29;    9'd293: y_scaler_raw <= 32'h5c0caf20;    9'd294: y_scaler_raw <= 32'h5be62f52;    9'd295: y_scaler_raw <= 32'h5bbfbed7;    
9'd296: y_scaler_raw <= 32'h5b995dc5;    9'd297: y_scaler_raw <= 32'h5b730c34;    9'd298: y_scaler_raw <= 32'h5b4cca38;    9'd299: y_scaler_raw <= 32'h5b2697e8;    9'd300: y_scaler_raw <= 32'h5b007559;    
9'd301: y_scaler_raw <= 32'h5ada629f;    9'd302: y_scaler_raw <= 32'h5ab45fce;    9'd303: y_scaler_raw <= 32'h5a8e6cfb;    9'd304: y_scaler_raw <= 32'h5a688a39;    9'd305: y_scaler_raw <= 32'h5a42b79a;    
9'd306: y_scaler_raw <= 32'h5a1cf532;    9'd307: y_scaler_raw <= 32'h59f74312;    9'd308: y_scaler_raw <= 32'h59d1a14b;    9'd309: y_scaler_raw <= 32'h59ac0ff1;    9'd310: y_scaler_raw <= 32'h59868f12;    
9'd311: y_scaler_raw <= 32'h59611ec1;    9'd312: y_scaler_raw <= 32'h593bbf0c;    9'd313: y_scaler_raw <= 32'h59167005;    9'd314: y_scaler_raw <= 32'h58f131b9;    9'd315: y_scaler_raw <= 32'h58cc0439;    
9'd316: y_scaler_raw <= 32'h58a6e792;    9'd317: y_scaler_raw <= 32'h5881dbd4;    9'd318: y_scaler_raw <= 32'h585ce10b;    9'd319: y_scaler_raw <= 32'h5837f747;    9'd320: y_scaler_raw <= 32'h58131e93;   
endcase
end

/*
function tobin(a){
	var str = Math.round(a * Math.pow(2,26));
	return str.toString(16);
}

var out = "always_ff @ (negedge Clk) begin\ncase (in)\n";
for(var i = 0; i <= 240; i++) {
		out += "9'd" + (i) + ": y_raw <= 32'h"+tobin(Math.atan(i/240)/Math.PI*180)+";    ";
		if(!(i % 5)){
			out += "\n";
		}
}
out += "\nendcase\nend\n";
console.log(out);
*/
always_ff @ (negedge Clk) begin
case (iny)
9'd0: y_raw <= 32'h0;    
9'd1: y_raw <= 32'hf475e8;    9'd2: y_raw <= 32'h1e8e9a5;    9'd3: y_raw <= 32'h2dd5908;    9'd4: y_raw <= 32'h3d1c1e8;    9'd5: y_raw <= 32'h4c62217;    
9'd6: y_raw <= 32'h5ba776c;    9'd7: y_raw <= 32'h6aebfbb;    9'd8: y_raw <= 32'h7a2f8db;    9'd9: y_raw <= 32'h89720a2;    9'd10: y_raw <= 32'h98b34e9;    
9'd11: y_raw <= 32'ha7f3389;    9'd12: y_raw <= 32'hb731a5b;    9'd13: y_raw <= 32'hc66e73b;    9'd14: y_raw <= 32'hd5a9806;    9'd15: y_raw <= 32'he4e2a99;    
9'd16: y_raw <= 32'hf419cd5;    9'd17: y_raw <= 32'h1034ec9c;    9'd18: y_raw <= 32'h112817cf;    9'd19: y_raw <= 32'h121b1c56;    9'd20: y_raw <= 32'h130df816;    
9'd21: y_raw <= 32'h1400a8fa;    9'd22: y_raw <= 32'h14f32ced;    9'd23: y_raw <= 32'h15e581dd;    9'd24: y_raw <= 32'h16d7a5ba;    9'd25: y_raw <= 32'h17c99678;    
9'd26: y_raw <= 32'h18bb520c;    9'd27: y_raw <= 32'h19acd66e;    9'd28: y_raw <= 32'h1a9e2199;    9'd29: y_raw <= 32'h1b8f318d;    9'd30: y_raw <= 32'h1c800449;    
9'd31: y_raw <= 32'h1d7097d3;    9'd32: y_raw <= 32'h1e60ea31;    9'd33: y_raw <= 32'h1f50f96f;    9'd34: y_raw <= 32'h2040c39a;    9'd35: y_raw <= 32'h213046c5;    
9'd36: y_raw <= 32'h221f8105;    9'd37: y_raw <= 32'h230e7073;    9'd38: y_raw <= 32'h23fd132a;    9'd39: y_raw <= 32'h24eb674d;    9'd40: y_raw <= 32'h25d96afe;    
9'd41: y_raw <= 32'h26c71c67;    9'd42: y_raw <= 32'h27b479b4;    9'd43: y_raw <= 32'h28a18115;    9'd44: y_raw <= 32'h298e30be;    9'd45: y_raw <= 32'h2a7a86ea;    
9'd46: y_raw <= 32'h2b6681d4;    9'd47: y_raw <= 32'h2c521fbf;    9'd48: y_raw <= 32'h2d3d5ef0;    9'd49: y_raw <= 32'h2e283db3;    9'd50: y_raw <= 32'h2f12ba55;    
9'd51: y_raw <= 32'h2ffcd32c;    9'd52: y_raw <= 32'h30e6868f;    9'd53: y_raw <= 32'h31cfd2db;    9'd54: y_raw <= 32'h32b8b673;    9'd55: y_raw <= 32'h33a12fbd;    
9'd56: y_raw <= 32'h34893d25;    9'd57: y_raw <= 32'h3570dd1b;    9'd58: y_raw <= 32'h36580e14;    9'd59: y_raw <= 32'h373ece8c;    9'd60: y_raw <= 32'h38251d02;    
9'd61: y_raw <= 32'h390af7fa;    9'd62: y_raw <= 32'h39f05dff;    9'd63: y_raw <= 32'h3ad54d9e;    9'd64: y_raw <= 32'h3bb9c56d;    9'd65: y_raw <= 32'h3c9dc404;    
9'd66: y_raw <= 32'h3d814802;    9'd67: y_raw <= 32'h3e64500b;    9'd68: y_raw <= 32'h3f46dac7;    9'd69: y_raw <= 32'h4028e6e6;    9'd70: y_raw <= 32'h410a731a;    
9'd71: y_raw <= 32'h41eb7e1e;    9'd72: y_raw <= 32'h42cc06ae;    9'd73: y_raw <= 32'h43ac0b90;    9'd74: y_raw <= 32'h448b8b8b;    9'd75: y_raw <= 32'h456a856f;    
9'd76: y_raw <= 32'h4648f810;    9'd77: y_raw <= 32'h4726e246;    9'd78: y_raw <= 32'h480442f1;    9'd79: y_raw <= 32'h48e118f4;    9'd80: y_raw <= 32'h49bd6339;    
9'd81: y_raw <= 32'h4a9920b0;    9'd82: y_raw <= 32'h4b74504c;    9'd83: y_raw <= 32'h4c4ef107;    9'd84: y_raw <= 32'h4d2901e0;    9'd85: y_raw <= 32'h4e0281dd;    
9'd86: y_raw <= 32'h4edb7005;    9'd87: y_raw <= 32'h4fb3cb6b;    9'd88: y_raw <= 32'h508b9320;    9'd89: y_raw <= 32'h5162c641;    9'd90: y_raw <= 32'h523963eb;    
9'd91: y_raw <= 32'h530f6b44;    9'd92: y_raw <= 32'h53e4db76;    9'd93: y_raw <= 32'h54b9b3af;    9'd94: y_raw <= 32'h558df324;    9'd95: y_raw <= 32'h56619910;    
9'd96: y_raw <= 32'h5734a4b0;    9'd97: y_raw <= 32'h58071549;    9'd98: y_raw <= 32'h58d8ea25;    9'd99: y_raw <= 32'h59aa2291;    9'd100: y_raw <= 32'h5a7abde0;    
9'd101: y_raw <= 32'h5b4abb6d;    9'd102: y_raw <= 32'h5c1a1a94;    9'd103: y_raw <= 32'h5ce8dab7;    9'd104: y_raw <= 32'h5db6fb3f;    9'd105: y_raw <= 32'h5e847b99;    
9'd106: y_raw <= 32'h5f515b34;    9'd107: y_raw <= 32'h601d9989;    9'd108: y_raw <= 32'h60e93612;    9'd109: y_raw <= 32'h61b4304f;    9'd110: y_raw <= 32'h627e87c4;    
9'd111: y_raw <= 32'h63483bfd;    9'd112: y_raw <= 32'h64114c86;    9'd113: y_raw <= 32'h64d9b8f3;    9'd114: y_raw <= 32'h65a180db;    9'd115: y_raw <= 32'h6668a3da;    
9'd116: y_raw <= 32'h672f2192;    9'd117: y_raw <= 32'h67f4f9a6;    9'd118: y_raw <= 32'h68ba2bc1;    9'd119: y_raw <= 32'h697eb790;    9'd120: y_raw <= 32'h6a429cc7;    
9'd121: y_raw <= 32'h6b05db1a;    9'd122: y_raw <= 32'h6bc87247;    9'd123: y_raw <= 32'h6c8a620b;    9'd124: y_raw <= 32'h6d4baa29;    9'd125: y_raw <= 32'h6e0c4a6a;    
9'd126: y_raw <= 32'h6ecc429a;    9'd127: y_raw <= 32'h6f8b9286;    9'd128: y_raw <= 32'h704a3a04;    9'd129: y_raw <= 32'h710838ea;    9'd130: y_raw <= 32'h71c58f15;    
9'd131: y_raw <= 32'h72823c63;    9'd132: y_raw <= 32'h733e40b7;    9'd133: y_raw <= 32'h73f99bf9;    9'd134: y_raw <= 32'h74b44e12;    9'd135: y_raw <= 32'h756e56f2;    
9'd136: y_raw <= 32'h7627b689;    9'd137: y_raw <= 32'h76e06cce;    9'd138: y_raw <= 32'h779879b9;    9'd139: y_raw <= 32'h784fdd47;    9'd140: y_raw <= 32'h79069777;    
9'd141: y_raw <= 32'h79bca84c;    9'd142: y_raw <= 32'h7a720fcd;    9'd143: y_raw <= 32'h7b26ce04;    9'd144: y_raw <= 32'h7bdae2fe;    9'd145: y_raw <= 32'h7c8e4eca;    
9'd146: y_raw <= 32'h7d41117d;    9'd147: y_raw <= 32'h7df32b2b;    9'd148: y_raw <= 32'h7ea49bef;    9'd149: y_raw <= 32'h7f5563e6;    9'd150: y_raw <= 32'h8005832d;    
9'd151: y_raw <= 32'h80b4f9e8;    9'd152: y_raw <= 32'h8163c83b;    9'd153: y_raw <= 32'h8211ee4d;    9'd154: y_raw <= 32'h82bf6c4b;    9'd155: y_raw <= 32'h836c4260;    
9'd156: y_raw <= 32'h841870bd;    9'd157: y_raw <= 32'h84c3f793;    9'd158: y_raw <= 32'h856ed718;    9'd159: y_raw <= 32'h86190f84;    9'd160: y_raw <= 32'h86c2a110;    
9'd161: y_raw <= 32'h876b8bf8;    9'd162: y_raw <= 32'h8813d07c;    9'd163: y_raw <= 32'h88bb6edc;    9'd164: y_raw <= 32'h8962675b;    9'd165: y_raw <= 32'h8a08ba40;    
9'd166: y_raw <= 32'h8aae67d2;    9'd167: y_raw <= 32'h8b53705a;    9'd168: y_raw <= 32'h8bf7d425;    9'd169: y_raw <= 32'h8c9b9380;    9'd170: y_raw <= 32'h8d3eaebc;    
9'd171: y_raw <= 32'h8de1262b;    9'd172: y_raw <= 32'h8e82fa21;    9'd173: y_raw <= 32'h8f242af3;    9'd174: y_raw <= 32'h8fc4b8f9;    9'd175: y_raw <= 32'h9064a48d;    
9'd176: y_raw <= 32'h9103ee0a;    9'd177: y_raw <= 32'h91a295cd;    9'd178: y_raw <= 32'h92409c34;    9'd179: y_raw <= 32'h92de01a0;    9'd180: y_raw <= 32'h937ac673;    
9'd181: y_raw <= 32'h9416eb10;    9'd182: y_raw <= 32'h94b26fdc;    9'd183: y_raw <= 32'h954d553e;    9'd184: y_raw <= 32'h95e79b9d;    9'd185: y_raw <= 32'h96814364;    
9'd186: y_raw <= 32'h971a4cfd;    9'd187: y_raw <= 32'h97b2b8d3;    9'd188: y_raw <= 32'h984a8755;    9'd189: y_raw <= 32'h98e1b8f1;    9'd190: y_raw <= 32'h99784e17;    
9'd191: y_raw <= 32'h9a0e4738;    9'd192: y_raw <= 32'h9aa3a4c6;    9'd193: y_raw <= 32'h9b386736;    9'd194: y_raw <= 32'h9bcc8efb;    9'd195: y_raw <= 32'h9c601c8b;    
9'd196: y_raw <= 32'h9cf3105d;    9'd197: y_raw <= 32'h9d856ae9;    9'd198: y_raw <= 32'h9e172ca7;    9'd199: y_raw <= 32'h9ea85611;    9'd200: y_raw <= 32'h9f38e7a1;    
9'd201: y_raw <= 32'h9fc8e1d3;    9'd202: y_raw <= 32'ha0584523;    9'd203: y_raw <= 32'ha0e7120f;    9'd204: y_raw <= 32'ha1754913;    9'd205: y_raw <= 32'ha202eab0;    
9'd206: y_raw <= 32'ha28ff764;    9'd207: y_raw <= 32'ha31c6faf;    9'd208: y_raw <= 32'ha3a85413;    9'd209: y_raw <= 32'ha433a511;    9'd210: y_raw <= 32'ha4be632b;    
9'd211: y_raw <= 32'ha5488ee3;    9'd212: y_raw <= 32'ha5d228be;    9'd213: y_raw <= 32'ha65b313f;    9'd214: y_raw <= 32'ha6e3a8ea;    9'd215: y_raw <= 32'ha76b9045;    
9'd216: y_raw <= 32'ha7f2e7d5;    9'd217: y_raw <= 32'ha879b020;    9'd218: y_raw <= 32'ha8ffe9ac;    9'd219: y_raw <= 32'ha9859500;    9'd220: y_raw <= 32'haa0ab2a4;    
9'd221: y_raw <= 32'haa8f431e;    9'd222: y_raw <= 32'hab1346f7;    9'd223: y_raw <= 32'hab96beb7;    9'd224: y_raw <= 32'hac19aae6;    9'd225: y_raw <= 32'hac9c0c0e;    
9'd226: y_raw <= 32'had1de2b7;    9'd227: y_raw <= 32'had9f2f6c;    9'd228: y_raw <= 32'hae1ff2b5;    9'd229: y_raw <= 32'haea02d1c;    9'd230: y_raw <= 32'haf1fdf2c;    
9'd231: y_raw <= 32'haf9f096e;    9'd232: y_raw <= 32'hb01dac6d;    9'd233: y_raw <= 32'hb09bc8b4;    9'd234: y_raw <= 32'hb1195ecd;    9'd235: y_raw <= 32'hb1966f43;    
9'd236: y_raw <= 32'hb212faa1;    9'd237: y_raw <= 32'hb28f0171;    9'd238: y_raw <= 32'hb30a843f;    9'd239: y_raw <= 32'hb3858396;    9'd240: y_raw <= 32'hb4000000;    

endcase
end




endmodule
