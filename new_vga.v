`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:30:38 03/19/2013 
// Design Name: 
// Module Name:    vga640x480 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga640x480(
	input wire dclk,			//pixel clock: 25MHz
	input wire clr,			//asynchronous reset
	input wire [6:0] score_l,
	input wire [6:0] score_r,
	input wire [9:0] ballx,
	input wire [9:0] bally,
	input wire [9:0] r_pos,
	input wire [9:0] l_pos,
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output reg [2:0] red,	//red vga output
	output reg [2:0] green, //green vga output
	output reg [1:0] blue	//blue vga output
	);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk or posedge clr)
begin
	// reset condition
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

// display 100% saturation colorbars
// ------------------------
// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =


/*
reg [1:0]number_rep = 2'b11;
reg [9:0] cnt = vbp + 43;
reg [18:0]diver = 19'b0;
reg [9:0] ballx = hbp+320;
reg [9:0] bally = vbp+240;
reg b_clock = 1'b0;
integer rise = 1;
integer run = 1;



always @(posedge dclk)
begin
	if (diver == 19'b1001100010010110100)
	begin
		diver = 19'b0;
		cnt = cnt + 1;
		b_clock = ~b_clock;
	end

	else if (cnt == vbp+339)
	begin
		cnt = vbp+43;
	end
	else 
		diver = diver + 1;
		
		
end

always @(b_clock)
begin
	if (ballx < hbp + 585 && ballx > hbp + 75 && bally < vbp+425 && bally > vbp+55)
	begin
		ballx = ballx + run;
		bally = bally + rise;
	end
	if (ballx == hbp+585 || ballx == hbp+75 && bally < vbp+425 && bally > vbp+55)
	begin 
		run = -run;
		ballx = ballx + run;
		bally = bally + rise;
	end
	if (ballx < hbp+585 && ballx > hbp+75 && bally == vbp+425 || bally == vbp+55)
	begin
		rise = -rise;
		ballx = ballx + run;
		bally = bally + rise;
	end
end
*/
always @(*)
begin
	// first check if we're within vertical active video range

	if (vc >= vbp && vc < vfp)
	begin
		/*--------BORDER-----------*/
		//left wall
		if ( hc >= hbp + 40 && hc < (50 + hbp) && vc >= vbp+40 && vc < vbp+440)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		//right wall
		else if (hc >= (hbp+590) && hc < (hbp+600) && vc >= vbp+40 && vc < vbp+440)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		
		//top wall
		else if (vc >= vbp+40 && vc < vbp+50 && hc >= (hbp+50) && hc < (hbp+590))
		begin 
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		//bottomwall
		else if (vc >= (vbp+430) && vc < (vbp+440) && hc >= (hbp+50) && hc < (hbp+590))
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		///////////////////////////////////////
		// 7-SEGMENT FOR LEFT SIDE
		///////////////////////////////////////
		// top segment [0]
		else if (vc >= vbp+8 && vc < vbp+14 && hc >= (hbp+236) && hc < (hbp+249) && score_l[0] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		// top right segment[1]
		else if (vc >= vbp+8 && vc < vbp+23 && hc >= (hbp+249)  && hc < (hbp+255) && score_l[1] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		// Top left segment[5]
		else if (vc >= vbp+8 && vc < vbp+23 && hc >= (hbp+230)  && hc < (hbp+236) && score_l[5] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		// mid segment [6]
		else if (vc >= vbp+20 && vc < vbp+26 && hc >= (hbp+236) && hc < (hbp+249) && score_l[6] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		// Bottom right segment[2]
		else if (vc >= vbp+23 && vc < vbp+38 && hc >= (hbp+249) && hc < (hbp+255) && score_l[2] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		// Bottom left segment[4]
		else if (vc >= vbp+23 && vc < vbp+38 && hc >= (hbp+230) && hc < (hbp+236) && score_l[4] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		// bottom segment[3]
		else if (vc >= vbp+32 && vc < vbp+38 && hc >= (hbp+236) && hc < (hbp+249) && score_l[3] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		
		///////////////////////////////////////
		// 7-SEGMENT FOR RIGHT SIDE
		///////////////////////////////////////
		// top segment [0]
		else if (vc >= vbp+8 && vc < vbp+14 && hc >= (hbp+392) && hc < (hbp+405) && score_r[0] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		// top right segment [1]
		else if (vc >= vbp+8 && vc < vbp+23 && hc >= (hbp+405) && hc < (hbp+411) && score_r[1] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		// Top left segment [5]
		else if (vc >= vbp+8 && vc < vbp+23 && hc >= (hbp+386) && hc < (hbp+392) && score_r[5] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		// mid segment [6]
		else if (vc >= vbp+20 && vc < vbp+26 && hc >= (hbp+392) && hc < (hbp+405) && score_r[6] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		// Bottom right segment [2]
		else if (vc >= vbp+23 && vc < vbp+38 && hc >= (hbp+405) && hc < (hbp+411) && score_r[2] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		// Bottom left segment [4]
		else if (vc >= vbp+23 && vc < vbp+38 && hc >= (hbp+386) && hc < (hbp+392) && score_r[4] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		// bottom segment [3]
		else if (vc >= vbp+32 && vc < vbp+38 && hc >= (hbp+392) && hc < (hbp+405) && score_r[3] == 1)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		
		///////////////////////////////////
		// Left Bar
		///////////////////////////////////
		else if (vc >= l_pos && vc < l_pos+100 && hc >= hbp+55 && hc < hbp+70)
		begin
			red = 3'b111;
			green = 3'b001;
			blue = 2'b01;
		end

		///////////////////////////////////
		// Right Bar
		///////////////////////////////////
		else if (vc >= r_pos && vc < r_pos+100 && hc >= hbp+575 && hc < hbp+590)
		begin
			red = 3'b001;
			green = 3'b111;
			blue = 2'b01;
		end

		// ball
		else if (vc > bally-5 && vc <=bally+5 && hc > ballx-5 && hc <= ballx+5)
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		else
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
	end
	// we're outside active vertical range so display black
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
end

endmodule
