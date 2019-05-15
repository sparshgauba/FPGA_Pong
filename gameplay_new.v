`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:55:07 03/13/2017 
// Design Name: gih
// Module Name:    gameplay 
//
//
//////////////////////////////////////////////////////////////////////////////////
module gameplay(
					input wire dclk,
					input wire clr,
					input wire speed3,
					input wire speed2,
					input wire speed1,
					//input sixty,
					input wire input_up,
					input wire input_down,
					output wire hsync,		//horizontal sync out
					output wire vsync,		//vertical sync out
					output wire [2:0] red,	//red vga output
					output wire [2:0] green, //green vga output
					output wire [1:0] blue	//blue vga output
					
					);

parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch

//wire [9:0] ballx;
//wire [9:0] bally;
wire [6:0] score_l;
wire [6:0] score_r;
wire [9:0] l_pos;
wire [9:0] r_pos;

reg r_input_up;
reg r_input_down;

reg [9:0] r_lpos;
reg [9:0] r_rpos;

reg [3:0] lScore = 3'b0;
reg [3:0] rScore = 3'b0;
reg [6:0] r_score_l = 7'b0;
reg [6:0] r_score_r = 7'b0;

reg [9:0] ballx = hbp+320;
reg [9:0] bally = vbp+240;

integer rise = 1;
integer run = 1;
integer clk_choose = 0;

assign score_l = r_score_l;
assign score_r = r_score_r;

assign l_pos = r_lpos;
assign r_pos = r_rpos;

assign input_up = r_input_up;
assign input_down = r_input_down;


///////////////////////////////////// \ | /
// Clock multiplexing for levels       \|/
/////////////////////////////////////   V

wire b_clock;

wire [2:0] clocks = 3'b0;

assign clocks[2] = speed3;
assign clocks[1] = speed2;
assign clocks[0] = speed1;

assign b_clock = clocks[clk_choose];

/////////////////////////////////////
//   Convert Binary to Seven Seg
/////////////////////////////////////
always @(*)
begin
	case (lScore)
		4'b0000: r_score_l = 7'b1111110;
		4'b0001: r_score_l = 7'b0110000;
		4'b0010: r_score_l = 7'b1101101;
		4'b0011: r_score_l = 7'b1111001;
		4'b0100: r_score_l = 7'b0110011;
		4'b0101: r_score_l = 7'b1011011;
		4'b0110: r_score_l = 7'b1011111;
		4'b0111: r_score_l = 7'b1110000;
		4'b1000: r_score_l = 7'b1111111;
		4'b1001: r_score_l = 7'b1111011;
	endcase
	case (rScore)
		4'b0000: 
				begin
					r_score_r = 7'b1111110;
					clk_choose = 0;
				end
		4'b0001: r_score_r = 7'b0110000;
		4'b0010: r_score_r = 7'b1101101;
		4'b0011: 
				begin
					r_score_r = 7'b1111001;
					clk_choose = 1;
				end
		4'b0100: r_score_r = 7'b0110011;
		4'b0101: r_score_r = 7'b1011011;
		4'b0110: 
				begin
					r_score_r = 7'b1011111;
					clk_choose = 2;
				end
		4'b0111: r_score_r = 7'b1110000;
		4'b1000: r_score_r = 7'b1111111;
		4'b1001: r_score_r = 7'b1111011;
	endcase
end

always @(b_clock)
begin
	if (ballx < hbp + 585 && ballx > hbp + 75 && bally < vbp+425 && bally > vbp+55)
	begin
		ballx = ballx + run;
		bally = bally + rise;
	end
	else if (ballx == hbp+585 && bally < vbp+425 && bally > vbp+55)
	begin 
		lScore = lScore + 1;
		run = -1;
		rise = 0;
		ballx = hbp + 320;
		bally = vbp + 240;
	end
	else if (ballx == hbp+60 && bally < vbp+425 && bally > vbp+55)
	begin 
		lScore = lScore + 1;
		run = 1;
		rise = 0;
		ballx = hbp + 320;
		bally = vbp + 240;
	end
	else if (ballx < hbp+585 && ballx > hbp+75 && bally == vbp+425 || bally == vbp+55)
	begin
		rise = -rise;
		ballx = ballx + run;
		bally = bally + rise;
	end
	else if ((ballx == hbp+75 && bally >= r_lpos && bally < r_lpos+100) || 
				(ballx == hbp+570 && bally >= r_lpos && bally < r_lpos+100))
	begin
		run = -run;
		ballx = ballx + run;
		bally = bally + rise;
	end
end

always @ (posedge speed1)
begin
	if (r_input_up == 1 && r_rpos >= vbp+40)
	begin
		r_rpos = r_rpos - 1;
	end
	if (r_input_down == 1 && r_rpos < vbp+340)
	begin
		r_rpos = r_rpos + 1;
	end
end



vga640x480 disp(
	.dclk(dclk),
	.clr(clr),
	.score_l(score_l),
	.score_r(score_l),
	.ballx(ballx),
	.bally(bally),
	.r_pos(r_pos),
	.l_pos(l_pos),
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue)
	);



endmodule

















