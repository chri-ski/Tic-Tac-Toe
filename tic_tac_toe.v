`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:34:06 02/22/2022 
// Design Name: 
// Module Name:    tic_tac_toe 
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
module tic_tac_toe(
    input clk,
	 input btnu, // buttons
	 input btns,
	 input [7:0] JA, // keypad
	 output [7:0] seg, // seven seg display
	 output [4:0] an,
	 // output [7:0] Led, // LED
	 output [2:0] red, // vga display
	 output [2:0] green,
	 output [1:0] blue,
	 output hsync,
	 output vsync
	 );

	wire [8:0] x;
	wire [8:0] o;
	wire [3:0] d0, d1, d2, d3;
	wire vga_clk, display_clk;

	assign x = 9'b111101111;
	assign o = 9'b000010000;
	assign d0 = 4'b0001;

	vga_display screen(
		.vga_clk(vga_clk),
		.rst(btnu), // debounce
		.x(x),
		.o(o),
		.hsync(hsync),
		.vsync(vsync),
		.vgaRed(red),
		.vgaGreen(green),
		.vgaBlue(blue)
	);
	
	clock_gen generator(
		.clk(clk),
		.vga_clk(vga_clk),
		.display_clk(display_clk)
	);
	
	seven_seg_display scoreboard(
		.display_clk(display_clk),
		.d0(d0),
		.d1(d1),
		.d2(d2),
		.d3(d3),
		.seg(seg),
		.an(an)
	);

endmodule


module debouncing(
	 input btnu, // buttons
	 input btns,
	 input [7:0] JA // keypad
);

module game_logic(
	input [8:0] x_in,
	input [8:0] o_in,
	output [8:0] x,
	output [8:0] o
);
endmodule


// adapted from sample code
module vga_display(
	input vga_clk,
	input rst,
	input [8:0] x,
	input [8:0] o,
	output hsync,
	output vsync,
	output reg [2:0] vgaRed,
	output reg [2:0] vgaGreen,
	output reg [1:0] vgaBlue
);

	parameter hpixels = 800;
	parameter vlines = 521;
	parameter hpulse = 96;
	parameter vpulse = 2;
	parameter hbp = 240;
	parameter hfp = 720;
	parameter vbp = 31;
	parameter vfp = 511;
	// active horizontal is 720 - 240 = 480
	// active vertical is 511 - 31 = 480
	
	// dividers for grid
	parameter hline1 = vbp + 160;
	parameter hline2 = vfp - 160;
	parameter vline1 = hbp + 160;
	parameter vline2 = hfp - 160;
	parameter lineWidth = 3;
	parameter letterHeight = 60; // half the height of an X/O
	
	parameter cx0 = hbp + 80;
	parameter cx1 = hbp + 240;
	parameter cx2 = hbp + 400;
	parameter cy0 = vbp + 80;
	parameter cy1 = vbp + 240;
	parameter cy2 = vbp + 400;

	// current location on the screen
	reg [9:0] hc;
	reg [9:0] vc;


// not working?
//	function drawX;
//		input cx, cy;
//		
//		begin
//			if (cx - letterHeight <= hc && hc <= cx + letterHeight &&
//				cy - letterHeight <= vc && vc <= cy + letterHeight &&
//				-lineWidth <= (hc - cx) - (vc - cy) && 
//				(hc - cx) - (vc - cy) <= lineWidth 
//				) begin
//				
//				vgaRed = 3'b111;
//				vgaGreen = 3'b111;
//				vgaBlue = 2'b11;
//				drawX = 1'b1;
//			end
//			else begin
//				vgaRed = 3'b111;
//				vgaGreen = 3'b111;
//				vgaBlue = 2'b11;
//				drawX = 1'b0;
//			end
//		end
//	endfunction
	
	always @(posedge vga_clk or posedge rst)
	begin
		if (rst) begin
			hc <= 0;
			vc <= 0;
		end
		else begin
			if (hc < hpixels - 1)
				hc <= hc + 1;
			else begin
				hc <= 0;
				if (vc < vlines - 1)
					vc <= vc + 1;
				else
					vc <= 0;
			end
		end
	end

	assign hsync = (hc < hpulse) ? 0: 1;
	assign vsync = (vc < vpulse) ? 0: 1;
	
	always @(vc or hc) begin
		if ((hline1 - lineWidth <= vc && vc <= hline1 + lineWidth) ||
			(hline2 - lineWidth <= vc && vc <= hline2 + lineWidth) ||
			(vline1 - lineWidth <= hc && hc <= vline1 + lineWidth) ||
			(vline2 - lineWidth <= hc && hc <= vline2 + lineWidth) 
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;			
		end
		else if (x[0] && cx0 - letterHeight <= hc && hc <= cx0 + letterHeight &&
			cy0 - letterHeight <= vc && vc <= cy0 + letterHeight &&
			(((vc - cy0) - (hc - cx0) >= lineWidth && (hc - cx0) - (vc - cy0) <= lineWidth) ||
			((vc - cy0) + (hc - cx0) + lineWidth >= 0  && (hc - cx0) + (vc - cy0) <= lineWidth))
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		// add stuff
		else if (x[4] && cx1 - letterHeight <= hc && hc <= cx1 + letterHeight &&
			cy1 - letterHeight <= vc && vc <= cy1 + letterHeight &&
			(((vc - cy1) - (hc - cx1) >= lineWidth && (hc - cx1) - (vc - cy1) <= lineWidth) ||
			((vc - cy1) + (hc - cx1) + lineWidth >= 0  && (hc - cx1) + (vc - cy1) <= lineWidth))
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end


		else if (o[4] && cx1 - letterHeight <= hc && hc <= cx1 + letterHeight &&
			cy1 - letterHeight <= vc && vc <= cy1 + letterHeight &&
			!(cx1 - letterHeight + lineWidth <= hc && hc <= cx1 + letterHeight - lineWidth &&
			cy1 - letterHeight + lineWidth <= vc && vc <= cy1 + letterHeight - lineWidth)
			
			
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end

		else begin
			vgaRed = 3'b000;
			vgaGreen = 3'b000;
			vgaBlue = 2'b00;
		end
		
	end

endmodule


module clock_gen(
	input clk, // 100 MHz
	output reg vga_clk, // 25 MHz
	output reg display_clk // 50 - 700 Hz
);
	reg [1:0] vga_counter;
	reg [18:0] display_counter;
	
	always @ (posedge clk) begin
		if (vga_counter == 2'b0) begin
			vga_clk <= 1'b1;
		end
		else if (vga_counter == 2'b1) begin
			vga_clk <= 1'b0;
		end
		
		vga_counter <= vga_counter + 2'b1;
	end

	always @ (posedge clk) begin			
		if (display_counter == 19'b0) begin
			display_clk <= 1;
		end
		else if (display_counter == 19'b1) begin
			display_clk <= 0;
		end
		
		display_counter <= display_counter + 19'b1;
		if (display_counter == 400000)
			display_counter <= 19'b0;
	end

endmodule



// 7 segment codes for each digits
`define ZERO 8'b11000000
`define ONE 8'b11111001
`define TWO 8'b10100100
`define THREE 8'b10110000
`define FOUR 8'b10011001
`define FIVE 8'b10010010
`define SIX 8'b10000010
`define SEVEN 8'b11111000
`define EIGHT 8'b10000000
`define NINE 8'b10010000
`define BLANK 8'b11111111

// copied from lab3
module seven_seg_display(
	input display_clk,
	input [3:0] d0,
	input [3:0] d1,
	input [3:0] d2, 
	input [3:0] d3,
	output reg [7:0] seg,
	output reg [3:0] an
);

	reg [1:0] digitUpdate;
	
	always @(posedge display_clk) begin
		case (digitUpdate) // cycle through which digit to update
			2'b00: begin
				an <= 4'b1110;
				case (d0)
					4'b0000: seg <= `ZERO;
					4'b0001: seg <= `ONE;
					4'b0010: seg <= `TWO;
					4'b0011: seg <= `THREE;
					4'b0100: seg <= `FOUR;
					4'b0101: seg <= `FIVE;
					4'b0110: seg <= `SIX;
					4'b0111: seg <= `SEVEN;
					4'b1000: seg <= `EIGHT;
					4'b1001: seg <= `NINE;
					4'b1010: seg <= `BLANK;
					default: seg <= `ZERO;
				endcase
			end
			2'b01: begin
				an <= 4'b1101;
				case (d1)
					4'b0000: seg <= `ZERO;
					4'b0001: seg <= `ONE;
					4'b0010: seg <= `TWO;
					4'b0011: seg <= `THREE;
					4'b0100: seg <= `FOUR;
					4'b0101: seg <= `FIVE;
					4'b1010: seg <= `BLANK;
					default: seg <= `ZERO;
				endcase
			end
			2'b10: begin
				an <= 4'b1011;
				case (d2)
					4'b0000: seg <= `ZERO;
					4'b0001: seg <= `ONE;
					4'b0010: seg <= `TWO;
					4'b0011: seg <= `THREE;
					4'b0100: seg <= `FOUR;
					4'b0101: seg <= `FIVE;
					4'b0110: seg <= `SIX;
					4'b0111: seg <= `SEVEN;
					4'b1000: seg <= `EIGHT;
					4'b1001: seg <= `NINE;
					4'b1010: seg <= `BLANK;
					default: seg <= `ZERO;
				endcase
			end
			2'b11: begin
				an <= 4'b0111;
				case (d3)
					4'b0000: seg <= `ZERO;
					4'b0001: seg <= `ONE;
					4'b0010: seg <= `TWO;
					4'b0011: seg <= `THREE;
					4'b0100: seg <= `FOUR;
					4'b0101: seg <= `FIVE;
					4'b1010: seg <= `BLANK;
					default: seg <= `ZERO;
				endcase
			end
		endcase
		
		digitUpdate <= digitUpdate + 2'b01;
	end

endmodule
