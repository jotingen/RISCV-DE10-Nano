// ADC.v

// Generated using ACDS version 18.1 625

`timescale 1 ps / 1 ps
module ADC (
		input  wire        CLOCK,    //                clk.clk
		output wire        ADC_SCLK, // external_interface.SCLK
		output wire        ADC_CS_N, //                   .CS_N
		input  wire        ADC_DOUT, //                   .DOUT
		output wire        ADC_DIN,  //                   .DIN
		output wire [11:0] CH0,      //           readings.CH0
		output wire [11:0] CH1,      //                   .CH1
		output wire [11:0] CH2,      //                   .CH2
		output wire [11:0] CH3,      //                   .CH3
		output wire [11:0] CH4,      //                   .CH4
		output wire [11:0] CH5,      //                   .CH5
		output wire [11:0] CH6,      //                   .CH6
		output wire [11:0] CH7,      //                   .CH7
		input  wire        RESET     //              reset.reset
	);

	ADC_adc_mega_0 #(
		.board          ("DE10-Standard"),
		.board_rev      ("Autodetect"),
		.tsclk          (4),
		.numch          (5),
		.max10pllmultby (1),
		.max10plldivby  (1)
	) adc_mega_0 (
		.CLOCK    (CLOCK),    //                clk.clk
		.RESET    (RESET),    //              reset.reset
		.CH0      (CH0),      //           readings.export
		.CH1      (CH1),      //                   .export
		.CH2      (CH2),      //                   .export
		.CH3      (CH3),      //                   .export
		.CH4      (CH4),      //                   .export
		.CH5      (CH5),      //                   .export
		.CH6      (CH6),      //                   .export
		.CH7      (CH7),      //                   .export
		.ADC_SCLK (ADC_SCLK), // external_interface.export
		.ADC_CS_N (ADC_CS_N), //                   .export
		.ADC_DOUT (ADC_DOUT), //                   .export
		.ADC_DIN  (ADC_DIN)   //                   .export
	);

endmodule
