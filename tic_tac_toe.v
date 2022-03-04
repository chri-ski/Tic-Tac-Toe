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
	 inout [7:0] JA, // keypad
	 output [7:0] seg, // seven seg display
	 output [3:0] an,
	 output [7:0] Led, // LED
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

	wire rst_score, rst_board;
	wire [8:0] move;
	wire inval_move, x_win, o_win, tie;

	debouncing debouncer(
		.clk(clk),
		.btnu(btnu),
		.btns(btns),
		.rst_score(rst_score),
		.rst_board(rst_board)
	);
	
	Decoder d(
		.clk(clk),
		.Row(JA[7:4]), 
		.Col(JA[3:0]),
		.DecodeOut(move)
	);
	
	game_logic game(
		.move(move),
		.rst(rst_board),
		.x(x),
		.o(o),
		.inval_move(inval_move),
		.x_win(x_win),
		.o_win(o_win),
		.tie(tie)
	);
	
	led_display leds(
		.x_win(x_win),
		.o_win(o_win),
		.tie(tie),
		.inval_move(inval_move),
		.Led(Led)
	);
	
	scoreboard scorer(
		.rst(rst_score),
		.x_win(x_win),
		.o_win(o_win),
		.d0(d0),
		.d1(d1),
		.d2(d2),
		.d3(d3)
	);

	vga_display screen(
		.vga_clk(vga_clk),
		.rst(rst_board), // unnecessary?
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
	 input clk,
	 input btnu, // buttons
	 input btns,
	 output rst_score,
	 output rst_board
);
	
	wire rst_i;
	reg [1:0] rst_ff;
	assign rst_i = btns;
	assign rst_score = rst_ff[0];
	always @(posedge clk or posedge rst_i) begin
		if (rst_i)
			rst_ff <= 2'b11;
		else
			rst_ff <= {1'b0, rst_ff[1]};
	end
	
	wire rst1_i;
	reg [1:0] rst1_ff;
	assign rst1_i = btnu;
	assign rst_board = rst1_ff[0];
	always @(posedge clk or posedge rst1_i) begin
		if (rst1_i)
			rst1_ff <= 2'b11;
		else
			rst1_ff <= {1'b0, rst1_ff[1]};
	end
	
endmodule


// Online demo
module Decoder(
    clk,
    Row,
    Col,
    DecodeOut
    );

    input clk;						// 100MHz onboard clock
    input [3:0] Row;				// Rows on KYPD
    output [3:0] Col;			// Columns on KYPD
    output [8:0] DecodeOut;	// Output data
	
	// Output wires and registers
	reg [3:0] Col;
	reg [8:0] D1, D2, D3;
	reg [8:0] DecodeOut;
	
	// Count register
	reg [19:0] sclk;

	always @(posedge clk) begin

			// 1ms
			if (sclk == 20'b00011000011010100000) begin
				//C1
				Col <= 4'b0111;
				sclk <= sclk + 1'b1;
			end
			
			// check row pins
			else if(sclk == 20'b00011000011010101000) begin
				//R1
				if (Row == 4'b0111) begin
					D1 <= 9'b000000001;  // 1
					D2 <= 9'b000000001;
					D3 <= 9'b000000001;
					DecodeOut <= 9'b000000001;
				end
				//R2
				else if(Row == 4'b1011) begin
					D1 <= 9'b000001000;   // 4
					D2 <= 9'b000001000;
					D3 <= 9'b000001000;
					DecodeOut <= 9'b000001000;
				end
				//R3
				else if(Row == 4'b1101) begin
					D1 <= 9'b001000000;		// 7
					D2 <= 9'b001000000;
					D3 <= 9'b001000000;
					DecodeOut <= 9'b001000000;
				end
				//R4
				//else if(Row == 4'b1110) begin  // 0
				//end
				else begin
					D1 <= 9'b0;
					D2 <= D1;
					D3 <= D2;
					DecodeOut <= D3;
				end
				sclk <= sclk + 1'b1;
			end

			// 2ms
			else if(sclk == 20'b00110000110101000000) begin
				//C2
				Col<= 4'b1011;
				sclk <= sclk + 1'b1;
			end
			
			// check row pins
			else if(sclk == 20'b00110000110101001000) begin
				//R1
				if (Row == 4'b0111) begin
					D1 <= 9'b000000010;		//2
					D2 <= 9'b000000010;
					D3 <= 9'b000000010;
					DecodeOut <= 9'b000000010;
				end
				//R2
				else if(Row == 4'b1011) begin
					D1 <= 9'b000010000;		//5
					D2 <= 9'b000010000;	
					D3 <= 9'b000010000;	
					DecodeOut <= 9'b000010000;
				end
				//R3
				else if(Row == 4'b1101) begin
					D1 <= 9'b010000000; 		//8
					D2 <= 9'b010000000;
					D3 <= 9'b010000000;
					DecodeOut <= 9'b010000000;
				end
				//R4
				//else if(Row == 4'b1110) begin  //F
				//end
				else begin
					D1 <= 9'b0;
					D2 <= D1;
					D3 <= D2;
					DecodeOut <= D3;
				end
				sclk <= sclk + 1'b1;
			end

			//3ms
			else if(sclk == 20'b01001001001111100000) begin
				//C3
				Col<= 4'b1101;
				sclk <= sclk + 1'b1;
			end
			
			// check row pins
			else if(sclk == 20'b01001001001111101000) begin
				//R1
				if(Row == 4'b0111) begin
					D1 <= 9'b000000100; 		//3
					D2 <= 9'b000000100;
					D3 <= 9'b000000100;
					DecodeOut <= 9'b000000100;
				end
				//R2
				else if(Row == 4'b1011) begin
					D1 <= 9'b000100000; 		//6
					D2 <= 9'b000100000;
					D3 <= 9'b000100000;
					DecodeOut <= 9'b000100000;
				end
				//R3
				else if(Row == 4'b1101) begin
					D1 <= 9'b100000000; 		//9
					D2 <= 9'b100000000; 
					D3 <= 9'b100000000; 
					DecodeOut <= 9'b100000000;
				end
				//R4
				//else if(Row == 4'b1110) begin // E
				//end
				else begin
					D1 <= 9'b0;
					D2 <= D1;
					D3 <= D2;
					DecodeOut <= D3;					
				end
				sclk <= sclk + 1'b1;
			end

			//4ms
			else if(sclk == 20'b01100001101010000000) begin
				//C4
				Col<= 4'b1110;
				sclk <= sclk + 1'b1;
			end

			// Check row pins
			else if(sclk == 20'b01100001101010001000) begin
//				//R1
//				if(Row == 4'b0111) begin
//					// DecodeOut <= 4'b1010; //A
//				end
//				//R2
//				else if(Row == 4'b1011) begin
//					// DecodeOut <= 4'b1011; //B
//				end
//				//R3
//				else if(Row == 4'b1101) begin
//					// DecodeOut <= 4'b1100; //C
//				end
//				//R4
//				else if(Row == 4'b1110) begin
//					// DecodeOut <= 4'b1101; //D
//				end
				sclk <= 20'b00000000000000000000;
			end

			// Otherwise increment
			else begin
				sclk <= sclk + 1'b1;
			end
			
	end

endmodule



module game_logic(
	input [8:0] move,
	input rst,
	output reg [8:0] x,
	output reg [8:0] o,
	output reg inval_move,
	output x_win,
	output o_win,
	output tie
);

	reg turn; // 0 --> X, 1 --> O
	wire slot_taken;
	wire some_move;
	
	assign tie = &(x | o) & (~x_win);
	assign x_win = (x[0] && x[1] && x[2]) || (x[3] && x[4] && x[5])
			|| (x[6] && x[7] && x[8]) || (x[0] && x[3] && x[6])
			|| (x[1] && x[4] && x[7]) || (x[2] && x[5] && x[8])
			|| (x[0] && x[4] && x[8]) || (x[2] && x[4] && x[6]);
	assign o_win = (o[0] && o[1] && o[2]) || (o[3] && o[4] && o[5])
			|| (o[6] && o[7] && o[8]) || (o[0] && o[3] && o[6])
			|| (o[1] && o[4] && o[7]) || (o[2] && o[5] && o[8])
			|| (o[0] && o[4] && o[8]) || (o[2] && o[4] && o[6]);
	
	
	assign slot_taken = |((x | o) & move);
	assign some_move = |move;
	
	always @(posedge some_move or posedge rst) begin
		if (rst) begin
			turn <= 0;
			inval_move <= 0;
		end
		else begin
			turn <= ~turn;
			inval_move <= (slot_taken || x_win || o_win || tie);
		end
	end
	
	always @(posedge move[0] or posedge rst) begin
		if (rst) begin
			x[0] <= 0;
			o[0] <= 0;
		end
		else begin
			if (!(slot_taken || x_win || o_win || tie)) begin
				o[0] <= turn;
				x[0] <= ~turn;
			end
		end
	end
	
	always @(posedge move[1] or posedge rst) begin
		if (rst) begin
			x[1] <= 0;
			o[1] <= 0;
		end
		else begin
			if (!(slot_taken || x_win || o_win || tie)) begin
				o[1] <= turn;
				x[1] <= ~turn;
			end
		end
	end
	
	always @(posedge move[2] or posedge rst) begin
		if (rst) begin
			x[2] <= 0;
			o[2] <= 0;
		end
		else begin
			if (!(slot_taken || x_win || o_win || tie)) begin
				o[2] <= turn;
				x[2] <= ~turn;
			end
		end
	end
	
	always @(posedge move[3] or posedge rst) begin
		if (rst) begin
			x[3] <= 0;
			o[3] <= 0;
		end
		else begin
			if (!(slot_taken || x_win || o_win || tie)) begin
				o[3] <= turn;
				x[3] <= ~turn;
			end
		end
	end
	
	always @(posedge move[4] or posedge rst) begin
		if (rst) begin
			x[4] <= 0;
			o[4] <= 0;
		end
		else begin
			if (!(slot_taken || x_win || o_win || tie)) begin
				o[4] <= turn;
				x[4] <= ~turn;
			end
		end
	end
	
	always @(posedge move[5] or posedge rst) begin
		if (rst) begin
			x[5] <= 0;
			o[5] <= 0;
		end
		else begin
			if (!(slot_taken || x_win || o_win || tie)) begin
				o[5] <= turn;
				x[5] <= ~turn;
			end
		end
	end
	
	always @(posedge move[6] or posedge rst) begin
		if (rst) begin
			x[6] <= 0;
			o[6] <= 0;
		end
		else begin
			if (!(slot_taken || x_win || o_win || tie)) begin
				o[6] <= turn;
				x[6] <= ~turn;
			end
		end
	end
	
	always @(posedge move[7] or posedge rst) begin
		if (rst) begin
			x[7] <= 0;
			o[7] <= 0;
		end
		else begin
			if (!(slot_taken || x_win || o_win || tie)) begin
				o[7] <= turn;
				x[7] <= ~turn;
			end
		end
	end
	
	always @(posedge move[8] or posedge rst) begin
		if (rst) begin
			x[8] <= 0;
			o[8] <= 0;
		end
		else begin
			if (!(slot_taken || x_win || o_win || tie)) begin
				o[8] <= turn;
				x[8] <= ~turn;
			end
		end
	end
	
//	always @(posedge move[0] or posedge move[1] or posedge move[2]
//			or posedge move[3] or posedge move[4] or posedge move[5] 
//			or posedge move[6] or posedge move[7] or posedge move[8] 
//			or posedge rst) begin
//		if (rst) begin
//			x <= 9'b0;
//			o <= 9'b0;
//			turn <= 1'b0;
//			inval_move <= 1'b0;
//		end
//		else if (x_win || o_win || tie || slot_taken) begin
//			inval_move <= 1'b1;
//		end
//		else if (move[0]) begin
//			o[0] <= turn;
//			x[0] <= ~turn;
//				
//			inval_move <= 0;
//			turn <= ~turn;
//		end
//		else if (move[1]) begin
//			o[1] <= turn;
//			x[1] <= ~turn;
//			
//			inval_move <= 0;
//			turn <= ~turn;
//		end
//		else if (move[2]) begin
//			o[2] <= turn;
//			x[2] <= ~turn;
//				
//			inval_move <= 0;
//			turn <= ~turn;
//		end
//		else if (move[3]) begin
//			o[3] <= turn;
//			x[3] <= ~turn;
//				
//			inval_move <= 0;
//			turn <= ~turn;
//		end
//		else if (move[4]) begin
//			o[4] <= turn;
//			x[4] <= ~turn;
//				
//			inval_move <= 0;
//			turn <= ~turn;
//		end
//		else if (move[5]) begin
//			o[5] <= turn;
//			x[5] <= ~turn;
//				
//			inval_move <= 0;
//			turn <= ~turn;
//		end
//		else if (move[6]) begin
//			o[6] <= turn;
//			x[6] <= ~turn;
//				
//			inval_move <= 0;
//			turn <= ~turn;
//		end
//		else if (move[7]) begin
//			o[7] <= turn;
//			x[7] <= ~turn;
//				
//			inval_move <= 0;
//			turn <= ~turn;
//		end
//		else if (move[8]) begin
//			o[8] <= turn;
//			x[8] <= ~turn;	
//				
//			inval_move <= 0;
//			turn <= ~turn;
//		end	
//	end

endmodule

//===================

module scoreboard(
	input rst,
	input x_win,
	input o_win,
	output reg [3:0] d0,
	output reg [3:0] d1,
	output reg [3:0] d2,
	output reg [3:0] d3
);

	always @(posedge rst or posedge x_win) begin
		if (rst) begin
			d2 <= 4'b0;
			d3 <= 4'b0;
		end
		else if (x_win) begin
			if (d3 == 4'b1001 && d2 == 4'b1001) begin
				d2 <= 4'b0;
				d3 <= 4'b0;
			end
			else if (d2 == 4'b1001) begin
				d2 <= 4'b0;
				d3 <= d3 + 4'b1;
			end
			else begin
				d2 <= d2 + 4'b1;
			end
		end
	end
	
	always @(posedge rst or posedge o_win) begin
		if (rst) begin
			d0 <= 4'b0;
			d1 <= 4'b0;
		end
		else if (o_win) begin
			if (d1 == 4'b1001 && d0 == 4'b1001) begin
				d0 <= 4'b0;
				d1 <= 4'b0;
			end
			else if (d2 == 4'b1001) begin
				d0 <= 4'b0;
				d1 <= d1 + 4'b1;
			end
			else begin
				d0 <= d0 + 4'b1;
			end
		end
	end

endmodule

module led_display(
	input x_win,
	input o_win,
	input tie,
	input inval_move,
	output [7:0] Led
);
	assign Led[2] = x_win;
	assign Led[0] = o_win;
	assign Led[1] = tie;
	assign Led[7] = inval_move;
	assign Led[6:3] = 4'b0;

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

	
	always @(posedge vga_clk or posedge rst)
	begin
		if (rst) begin
			hc <= 0;
			vc <= 0;
		end
		else begin
			if (hc < hpixels - 1)
				hc <= hc + 10'b1;
			else begin
				hc <= 0;
				if (vc < vlines - 1)
					vc <= vc + 10'b1;
				else
					vc <= 0;
			end
		end
	end

	assign hsync = (hc < hpulse) ? 1'b0: 1'b1;
	assign vsync = (vc < vpulse) ? 1'b0: 1'b1;
	
	always @(*) begin
		if ((hline1 - lineWidth <= vc && vc <= hline1 + lineWidth) ||
			(hline2 - lineWidth <= vc && vc <= hline2 + lineWidth) ||
			(vline1 - lineWidth <= hc && hc <= vline1 + lineWidth) ||
			(vline2 - lineWidth <= hc && hc <= vline2 + lineWidth) 
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;			
		end
		// display Xs
		else if (x[0] && cx0 - letterHeight - lineWidth <= hc && hc <= cx0 + letterHeight + lineWidth &&
			cy0 - letterHeight <= vc && vc <= cy0 + letterHeight &&
			(((vc - cy0) - (hc - cx0) >= lineWidth && (hc - cx0) - (vc - cy0) <= lineWidth) ||
			((vc - cy0) + (hc - cx0) + lineWidth >= 0  && (hc - cx0) + (vc - cy0) <= lineWidth))
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		// add stuff
		else if (x[1] && cx1 - letterHeight - lineWidth <= hc && hc <= cx1 + letterHeight + lineWidth &&
			cy0 - letterHeight <= vc && vc <= cy0 + letterHeight &&
			(((vc - cy0) - (hc - cx1) >= lineWidth && (hc - cx1) - (vc - cy0) <= lineWidth) ||
			((vc - cy0) + (hc - cx1) + lineWidth >= 0  && (hc - cx1) + (vc - cy0) <= lineWidth))
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		else if (x[2] && cx2 - letterHeight - lineWidth <= hc && hc <= cx2 + letterHeight + lineWidth &&
			cy0 - letterHeight <= vc && vc <= cy0 + letterHeight &&
			(((vc - cy0) - (hc - cx2) >= lineWidth && (hc - cx2) - (vc - cy0) <= lineWidth) ||
			((vc - cy0) + (hc - cx2) + lineWidth >= 0  && (hc - cx2) + (vc - cy0) <= lineWidth))
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		else if (x[3] && cx0 - letterHeight - lineWidth <= hc && hc <= cx0 + letterHeight + lineWidth &&
			cy1 - letterHeight <= vc && vc <= cy1 + letterHeight &&
			(((vc - cy1) - (hc - cx0) >= lineWidth && (hc - cx0) - (vc - cy1) <= lineWidth) ||
			((vc - cy1) + (hc - cx0) + lineWidth >= 0  && (hc - cx0) + (vc - cy1) <= lineWidth))
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		else if (x[4] && cx1 - letterHeight <= hc && hc <= cx1 + letterHeight &&
			cy1 - letterHeight <= vc && vc <= cy1 + letterHeight &&
			(((vc - cy1) - (hc - cx1) >= lineWidth && (hc - cx1) - (vc - cy1) <= lineWidth) ||
			((vc - cy1) + (hc - cx1) + lineWidth >= 0  && (hc - cx1) + (vc - cy1) <= lineWidth))
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		else if (x[5] && cx2 - letterHeight - lineWidth <= hc && hc <= cx2 + letterHeight + lineWidth &&
			cy1 - letterHeight <= vc && vc <= cy1 + letterHeight &&
			(((vc - cy1) - (hc - cx2) >= lineWidth && (hc - cx2) - (vc - cy1) <= lineWidth) ||
			((vc - cy1) + (hc - cx2) + lineWidth >= 0  && (hc - cx2) + (vc - cy1) <= lineWidth))
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		else if (x[6] && cx0 - letterHeight - lineWidth <= hc && hc <= cx0 + letterHeight + lineWidth &&
			cy2 - letterHeight <= vc && vc <= cy2 + letterHeight &&
			(((vc - cy2) - (hc - cx0) >= lineWidth && (hc - cx0) - (vc - cy2) <= lineWidth) ||
			((vc - cy2) + (hc - cx0) + lineWidth >= 0  && (hc - cx0) + (vc - cy2) <= lineWidth))
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		else if (x[7] && cx1 - letterHeight - lineWidth <= hc && hc <= cx1 + letterHeight + lineWidth &&
			cy2 - letterHeight <= vc && vc <= cy2 + letterHeight &&
			(((vc - cy2) - (hc - cx1) >= lineWidth && (hc - cx1) - (vc - cy2) <= lineWidth) ||
			((vc - cy2) + (hc - cx1) + lineWidth >= 0  && (hc - cx1) + (vc - cy2) <= lineWidth))
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		else if (x[8] && cx2 - letterHeight - lineWidth <= hc && hc <= cx2 + letterHeight + lineWidth &&
			cy2 - letterHeight <= vc && vc <= cy2 + letterHeight &&
			(((vc - cy2) - (hc - cx2) >= lineWidth && (hc - cx2) - (vc - cy2) <= lineWidth) ||
			((vc - cy2) + (hc - cx2) + lineWidth >= 0  && (hc - cx2) + (vc - cy2) <= lineWidth))
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		//	display Os
		else if (o[0] && cx0 - letterHeight <= hc && hc <= cx0 + letterHeight &&
			cy0 - letterHeight <= vc && vc <= cy0 + letterHeight &&
			!(cx0 - letterHeight + lineWidth <= hc && hc <= cx0 + letterHeight - lineWidth &&
			cy0 - letterHeight + lineWidth <= vc && vc <= cy0 + letterHeight - lineWidth)
				
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		else if (o[1] && cx1 - letterHeight <= hc && hc <= cx1 + letterHeight &&
			cy0 - letterHeight <= vc && vc <= cy0 + letterHeight &&
			!(cx1 - letterHeight + lineWidth <= hc && hc <= cx1 + letterHeight - lineWidth &&
			cy0 - letterHeight + lineWidth <= vc && vc <= cy0 + letterHeight - lineWidth)
				
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		else if (o[2] && cx2 - letterHeight <= hc && hc <= cx2 + letterHeight &&
			cy0 - letterHeight <= vc && vc <= cy0 + letterHeight &&
			!(cx2 - letterHeight + lineWidth <= hc && hc <= cx2 + letterHeight - lineWidth &&
			cy0 - letterHeight + lineWidth <= vc && vc <= cy0 + letterHeight - lineWidth)	
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		else if (o[3] && cx0 - letterHeight <= hc && hc <= cx0 + letterHeight &&
			cy1 - letterHeight <= vc && vc <= cy1 + letterHeight &&
			!(cx0 - letterHeight + lineWidth <= hc && hc <= cx0 + letterHeight - lineWidth &&
			cy1 - letterHeight + lineWidth <= vc && vc <= cy1 + letterHeight - lineWidth)
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
		else if (o[5] && cx2 - letterHeight <= hc && hc <= cx2 + letterHeight &&
			cy1 - letterHeight <= vc && vc <= cy1 + letterHeight &&
			!(cx2 - letterHeight + lineWidth <= hc && hc <= cx2 + letterHeight - lineWidth &&
			cy1 - letterHeight + lineWidth <= vc && vc <= cy1 + letterHeight - lineWidth)
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		else if (o[6] && cx0 - letterHeight <= hc && hc <= cx0 + letterHeight &&
			cy2 - letterHeight <= vc && vc <= cy2 + letterHeight &&
			!(cx0 - letterHeight + lineWidth <= hc && hc <= cx0 + letterHeight - lineWidth &&
			cy2 - letterHeight + lineWidth <= vc && vc <= cy2 + letterHeight - lineWidth)
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		else if (o[7] && cx1 - letterHeight <= hc && hc <= cx1 + letterHeight &&
			cy2 - letterHeight <= vc && vc <= cy2 + letterHeight &&
			!(cx1 - letterHeight + lineWidth <= hc && hc <= cx1 + letterHeight - lineWidth &&
			cy2 - letterHeight + lineWidth <= vc && vc <= cy2 + letterHeight - lineWidth)
		) begin
			vgaRed = 3'b111;
			vgaGreen = 3'b111;
			vgaBlue = 2'b11;
		end
		else if (o[8] && cx2 - letterHeight <= hc && hc <= cx2 + letterHeight &&
			cy2 - letterHeight <= vc && vc <= cy2 + letterHeight &&
			!(cx2 - letterHeight + lineWidth <= hc && hc <= cx2 + letterHeight - lineWidth &&
			cy2 - letterHeight + lineWidth <= vc && vc <= cy2 + letterHeight - lineWidth)
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

// adapted from lab 3
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
					4'b0110: seg <= `SIX;
					4'b0111: seg <= `SEVEN;
					4'b1000: seg <= `EIGHT;
					4'b1001: seg <= `NINE;
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
					4'b0110: seg <= `SIX;
					4'b0111: seg <= `SEVEN;
					4'b1000: seg <= `EIGHT;
					4'b1001: seg <= `NINE;
					4'b1010: seg <= `BLANK;
					default: seg <= `ZERO;
				endcase
			end
		endcase
		
		digitUpdate <= digitUpdate + 2'b01;
	end

endmodule