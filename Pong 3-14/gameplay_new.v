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
					input wire speed0,
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

reg [9:0] r_lpos = vbp + 140;
reg [9:0] r_rpos = vbp + 140;

reg [3:0] lScore = 4'b0000;
reg [3:0] rScore = 4'b0000;
reg [6:0] r_score_l = 7'b0;
reg [6:0] r_score_r = 7'b0;

reg [9:0] ballx = hbp+320;
reg [9:0] bally = vbp+240;

integer rise = 1;
integer run = -1;
integer clk_choose;

assign score_l = r_score_l;
assign score_r = r_score_r;

assign l_pos = r_lpos;
assign r_pos = r_rpos;


///////////////////////////////////// \ | /
// Clock multiplexing for levels       \|/
/////////////////////////////////////   V

wire b_clock;

wire [2:0] clocks;

assign clocks[2] = speed3;
assign clocks[1] = speed2;
assign clocks[0] = speed1;

assign b_clock = clocks[clk_choose];



wire e_clock;

wire [2:0] clocka;

assign clocka[2] = speed3;
assign clocka[1] = speed1;
assign clocka[0] = speed0;

assign e_clock = clocka[clk_choose];

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

always @(posedge b_clock)
begin
	
	if (clr == 1)
	begin
		lScore = 4'b0000;
		rScore = 4'b0000;
		ballx = hbp + 320;
		bally = vbp + 240;
	end

	if (lScore == 4'b1010 || rScore == 4'b1010 || clr == 1)
	begin
		lScore = 4'b0000;
		rScore = 4'b0000;
		ballx = hbp + 320;
		bally = vbp + 240;
	end
	
	if (ballx < hbp + 585 && ballx > hbp + 55 && bally < vbp+425 && bally > vbp+55)
	begin
		if (ballx <= hbp+70 && bally >= r_lpos && bally < r_lpos+100)
		begin
			if (bally < r_lpos+20)
				rise = -2;
			else if (bally >= r_lpos+20 && bally < r_lpos+40)
				rise = -1;
			else if (bally >= r_lpos+20 && bally < r_lpos+60)
				rise = 0;
			else if (bally >= r_lpos+20 && bally < r_lpos+80)
				rise = 1;
			else if (bally >= r_lpos+80 && bally < r_lpos+100)
				rise = 2;
			
			run = -run;
			ballx = ballx + run;
			bally = bally + rise;
		end
		else if (ballx >= hbp+570 && bally >= r_rpos && bally < r_rpos+100)
		begin
			
			if (bally < r_rpos+20)
				rise = -2;
			else if (bally >= r_rpos+20 && bally < r_rpos+40)
				rise = -1;
			else if (bally >= r_rpos+20 && bally < r_rpos+60)
				rise = 0;
			else if (bally >= r_rpos+20 && bally < r_rpos+80)
				rise = 1;
			else if (bally >= r_rpos+80 && bally < r_rpos+100)
				rise = 2;
			
			run = -run;
			ballx = ballx + run;
			bally = bally + rise;
		end
		else
		begin
			ballx = ballx + run;
			bally = bally + rise;
		end
		
	end
	else if (ballx >= hbp+585 && bally < vbp+425 && bally > vbp+55)
	begin 
		lScore = lScore + 1;
		run = -1;
		rise = 0;
		ballx = hbp + 320;
		bally = vbp + 240;
	end
	else if (ballx <= hbp+55 && bally < vbp+425 && bally > vbp+55)
	begin 
		rScore = rScore + 1;
		run = 1;
		rise = 0;
		ballx = hbp + 320;
		bally = vbp + 240;
	end
	else if (ballx < hbp+585 && ballx >= hbp+55 && (bally >= vbp+425 || bally <= vbp+55))
	begin
		rise = -rise;
		ballx = ballx + run;
		bally = bally + rise;
	end
end

always @ (posedge speed2)
begin
    if (lScore == 4'b1010 || rScore == 4'b1010 || clr == 1)
        r_rpos = vbp + 140;

	if (input_up == 1 && r_rpos >= vbp+50)
	begin
		r_rpos = r_rpos - 1;
	end
	if (input_down == 1 && r_rpos < vbp+330)
	begin
		r_rpos = r_rpos + 1;
	end
end

// Enemy AI
always @ (posedge e_clock)
begin
    if (lScore == 4'b1010 || rScore == 4'b1010 || clr == 1)
        r_lpos = vbp + 140;
        
	if (r_lpos >= vbp+50 && r_lpos < vbp+330 && run == -1)
	begin
		if (bally > r_lpos+50)
			r_lpos = r_lpos + 1;
		else
			r_lpos = r_lpos - 1;
	end
	
	if (r_lpos == vbp+49)
	begin
		r_lpos = r_lpos + 1;
	end
	
	if(r_lpos == vbp+330)
	begin
		r_lpos = r_lpos - 1;
	end
end






vga640x480 disp(
	.dclk(dclk),
	.clr(clr),
	.score_l(score_l),
	.score_r(score_r),
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
















