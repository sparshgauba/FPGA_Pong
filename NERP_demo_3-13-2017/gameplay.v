`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:55:07 03/13/2017 
// Design Name: 
// Module Name:    gameplay 
//
//
//////////////////////////////////////////////////////////////////////////////////
module gameplay(
					input clk,
					output wire [9:0] ballx,
					output wire [9:0] bally,
					output wire [6:0] score_l,
					output wire [6:0] score_r,
					output wire [9:0] l_pos,
					output wire [9:0] r_pos
					
					);

parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch

reg [3:0] lScore = 3'b0;
reg [3:0] rScore = 3'b0;
reg [6:0] r_score_l = 7'b0;
reg [6:0] r_score_r = 7'b0;

reg [9:0] ballx = hbp+320;
reg [9:0] bally = vbp+240;

integer rise = 1;
integer run = 1;

assign score_l = r_score_l;
assign score_r = r_score_r;


/////////////////////////////////////
//   Convert Binary to Seven Seg
/////////////////////////////////////

always @(*)
begin
	case (lScore)
		4'b0000: r_score_l <= 7'b1111110;
		4'b0001: r_score_l <= 7'b0110000;
		4'b0010: r_score_l <= 7'b1101101;
		4'b0011: r_score_l <= 7'b1111001;
		4'b0100: r_score_l <= 7'b0110011;
		4'b0101: r_score_l <= 7'b1011011;
		4'b0110: r_score_l <= 7'b1011111;
		4'b0111: r_score_l <= 7'b1110000;
		4'b1000: r_score_l <= 7'b1111111;
		4'b1001: r_score_l <= 7'b1111011;
	endcase
	case (rScore)
		4'b0000: r_score_r <= 7'b1111110;
		4'b0001: r_score_r <= 7'b0110000;
		4'b0010: r_score_r <= 7'b1101101;
		4'b0011: r_score_r <= 7'b1111001;
		4'b0100: r_score_r <= 7'b0110011;
		4'b0101: r_score_r <= 7'b1011011;
		4'b0110: r_score_r <= 7'b1011111;
		4'b0111: r_score_r <= 7'b1110000;
		4'b1000: r_score_r <= 7'b1111111;
		4'b1001: r_score_r <= 7'b1111011;
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
				(ballx == hbp+75 && bally >= r_lpos && bally < r_lpos+100))
	begin
	end
end

always @ (bar_clk)
begin

	

end






endmodule
