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
	output wire Vsync,			//vertical sync out

	//JOYSTICK SHIT
	output wire MISO, //Master In Slave Out, Pin 3, Port JA
	output wire SS, //slave selet, Pin 1, Port JA
    output MOSI,
    output wire SCLK //serial clock, pin 4, Port JA
	);

// 7-segment clock interconnect
wire segclk;

// VGA display clock interconnect
wire dclk;

// disable the 7-segment decimal points
assign dp = 1;

// generate 7-segment clock & display clock
clockdiv U1(
	.clk(clk),
	.clr(btns),
	.segclk(segclk),
	.dclk(dclk)
	);

// 7-segment display controller
segdisplay U2(
	.segclk(segclk),
	.clr(btns),
	.seg(seg),
	.an(an)
	);

// VGA controller
vga640x480 U3(
	.dclk(dclk),
	.clr(btns),
	.hsync(Hsync),
	.vsync(Vsync),
	.red(vgaRed),
	.green(vgaGreen),
	.blue(vgaBlue)
	);


//JOYSTICK SHIT

wire [7:0] sndData; //holds data to be sent to PmodJSTK
wire sndRec; //signal to send/receive data to/from JSTK
wire [39:0] jstkData; //DATA FROM JSTK
wire [9:0] posData; //SHOULD BE Y AXIS ONLY

			//JOYSTICK INTERFACE
			PmodJSTK PmodJSTK_Int(
					.CLK(CLK),
					.sndRec(sndRec),
					.DIN(sndData),
					.MISO(MISO),
					.SS(SS),
					.SCLK(SCLK),
					.MOSI(MOSI),
					.DOUT(jstkData)
			);

			//INSTEAD OF THIS, JUST USE OUR CLOCK GEN
			/*
			//SEND RECEIVE GENERATOR
			ClkDiv_5Hz genSndRec(
					.CLK(CLK),
					.RST(btns),
					.CLKOUT(sndRec)
			); */

			//this should choose Y axis (could actually be [9:8], [23:16])
			assign posData = {jstkData[25:34], jstkData[39:32]};

			// Data to be sent to PmodJSTK, lower two bits will turn on leds on PmodJSTK
			assign sndData = {8'b100000, 0, 0 };

			if (postData > 0)
				move joystick up!



endmodule
