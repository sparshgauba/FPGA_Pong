module PmodJSTK(
	CLK,
	RST,
	sndRec,
	DIN,
	MISO,
	SS,
	SCLK,
	MOSI,
	DOUT
    );

    input CLK;
    input RST;
    input sndRec;
    input [7:0] DIN; //data to be sent to slave
    input wire MISO; //master in
    output wire SS; //slave select
    input wire SCLK; //serial clock 66.7kHz 
    output wire MOSI; //master out, slave in
    output wire [39:0] DOUT; //all data read from slave

    wire getByte; //initializes a data transfer in SPI_Int
    wire [7:0] sndData; //data to be sent to slave
    wire [7:0] RxData; //output data from SPI_Int
    wire BUSY;  //Handshake from SPI_Int to SPI_Ctrl


    //SPI CONTROLLER
    spiCtrl SPI_Ctrl(
					.CLK(SCLK),
					.RST(RST)
					.sndRec(sndRec),
					.BUSY(BUSY),
					.DIN(DIN),
					.RxData(RxData),
					.SS(SS),
					.getByte(getByte),
					.sndData(sndData),
					.DOUT(DOUT)
			);

	//SPI MODE 0
	spiMode0 SPI_Int(
				.CLK(SCLK),
				.RST(RST)
				.sndRec(getByte),
				.DIN(sndData),
				.MISO(MISO),
				.MOSI(MOSI),
				.SCLK(SCLK),
				.BUSY(BUSY),
				.DOUT(RxData)
		);


/*
		ClkDiv_66_67kHz SerialClock(
					.CLK(CLK),
					.RST(RST),
					.CLKOUT(SCLK)
			);*/
	//instead of this, just pass in SCLK 66.67kHz clock from our clock gen

endmodule




