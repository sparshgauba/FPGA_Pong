`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:25 03/19/2013 
// Design Name: 
// Module Name:    NERP_demo_top 
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
module NERP_demo_top(
	input wire clk,			//master clock = 50MHz
	input wire btns,			//right-most pushbutton for reset
	output wire [7:0] seg,	//7-segment display LEDs
	output wire [3:0] an,	//7-segment display anode enable
	output wire dp,			//7-segment display decimal point
	output wire [2:0] vgaRed,	//red vga output - 3 bits
	output wire [2:0] vgaGreen,//green vga output - 3 bits
	output wire [2:1] vgaBlue,	//blue vga output - 2 bits
	output wire Hsync,		//horizontal sync out
	output wire Vsync			//vertical sync out
	);

// 7-segment clock interconnect
wire segclk;

// VGA display clock interconnect
wire dclk;
wire speed3;
wire speed2;
wire speed1;

// disable the 7-segment decimal points
assign dp = 1;

// generate 7-segment clock & display clock
clockdiv U1(
	.clk(clk),
	.clr(btns),
	.segclk(segclk),
	.dclk(dclk),
	.speed3(speed3),
	.speed2(speed2),
	.speed1(speed1)
	);

// 7-segment display controller
segdisplay U2(
	.segclk(segclk),
	.clr(btns),
	.seg(seg),
	.an(an)
	);

reg [7:0] dummy_cntr = 8'b0;

always @ (posedge speed1)
begin
	dummy_cntr = dummy_cntr + 1;
end

wire input_up;
wire input_down;
assign input_up = dummy_cntr[6];
assign input_down = ~dummy_cntr[6];

//Gameplay Controller
gameplay U3(
	.dclk(dclk),
	.clr(btns),
	.speed3(speed3),
	.speed2(speed2),
	.speed1(speed1),
	.input_up(input_up),
	.input_down(input_down),
	.hsync(Hsync),
	.vsync(Vsync),
	.red(vgaRed),
	.green(vgaGreen),
	.blue(vgaBlue)
	);

// VGA controller
/*vga640x480 U3(
	.dclk(dclk),
	.clr(btns),
	.hsync(Hsync),
	.vsync(Vsync),
	.red(vgaRed),
	.green(vgaGreen),
	.blue(vgaBlue)
	);*/

endmodule
