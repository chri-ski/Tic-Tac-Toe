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
	 output [3:0] an,
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

	wire rst_score, rst_board;
	wire [8:0] move;
	wire inval_move, x_win, y_win;

	debouncing debouncer(
		.clk(clk),
		.btnu(btnu),
		.btns(btns),
		.JA(JA),
		.rst_score(rst_score),
		.rst_board(rst_board),
		.move(move)
	);
	
	game_logic game(
		.move(move),
		.x(x),
		.o(o),
		.inval_move(inval_move),
		.x_win(x_win),
		.o_win(o_win)
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
	 input [7:0] JA, // keypad
	 output rst_score,
	 output rst_board,
	 output [8:0] move
);
	
	wire [5:0] keypad_in;
	assign move[0] = keypad_in[0] && keypad_in[3];
	assign move[1] = keypad_in[0] && keypad_in[4];
	assign move[2] = keypad_in[0] && keypad_in[5];
	assign move[3] = keypad_in[1] && keypad_in[3];
	assign move[4] = keypad_in[1] && keypad_in[4];
	assign move[5] = keypad_in[1] && keypad_in[5];
	assign move[6] = keypad_in[2] && keypad_in[3];
	assign move[7] = keypad_in[2] && keypad_in[4];
	assign move[8] = keypad_in[2] && keypad_in[5];
	
	wire rst_i;
	reg [1:0] rst_ff;
	assign rst_i = btns;
	assign rst = rst_ff[0];
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
	
	wire kp0_i;
	reg [1:0] kp0_ff;
	assign kp0_i = btnu;
	assign keypad_in[0] = kp0_ff[0];
	always @(posedge clk or posedge kp0_i) begin
		if (kp0_i)
			kp0_ff <= 2'b11;
		else
			kp0_ff <= {1'b0, kp0_ff[1]};
	end
	
	wire kp1_i;
	reg [1:0] kp1_ff;
	assign kp1_i = btnu;
	assign keypad_in[1] = kp1_ff[0];
	always @(posedge clk or posedge kp1_i) begin
		if (kp1_i)
			kp1_ff <= 2'b11;
		else
			kp1_ff <= {1'b0, kp1_ff[1]};
	end
	
	wire kp2_i;
	reg [1:0] kp2_ff;
	assign kp2_i = btnu;
	assign keypad_in[2] = kp2_ff[0];
	always @(posedge clk or posedge kp2_i) begin
		if (kp2_i)
			kp2_ff <= 2'b11;
		else
			kp2_ff <= {1'b0, kp2_ff[1]};
	end
	
	wire kp3_i;
	reg [1:0] kp3_ff;
	assign kp3_i = btnu;
	assign keypad_in[3] = kp3_ff[0];
	always @(posedge clk or posedge kp3_i) begin
		if (kp3_i)
			kp3_ff <= 2'b11;
		else
			kp3_ff <= {1'b0, kp3_ff[1]};
	end

	wire kp4_i;
	reg [1:0] kp4_ff;
	assign kp4_i = btnu;
	assign keypad_in[4] = kp4_ff[0];
	always @(posedge clk or posedge kp4_i) begin
		if (kp4_i)
			kp4_ff <= 2'b11;
		else
			kp4_ff <= {1'b0, kp4_ff[1]};
	end
	
	wire kp5_i;
	reg [1:0] kp5_ff;
	assign kp5_i = btnu;
	assign keypad_in[5] = kp5_ff[0];
	always @(posedge clk or posedge kp5_i) begin
		if (kp5_i)
			kp5_ff <= 2'b11;
		else
			kp5_ff <= {1'b0, kp5_ff[1]};
	end
	
	
endmodule

module game_logic(
	input [8:0] move,
	output reg [8:0] x,
	output reg [8:0] o,
	output reg inval_move,
	output reg x_win,
	output reg o_win
);

	reg turn; // 0 --> X, 1 --> O
	wire some_move = | move;
	
	always @(posedge some_move) begin
		if (move[0]) begin
			if (x[0] || o[0]) begin
				inval_move <= 1;
			end
			else begin
				if (turn) begin
					o[0] <= 1;
					if ((o[1] && o[2]) || (o[3] && o[6]) || (o[4] && o[8]))
						o_win <= 1;
				end
				else begin
					x[0] <= 1;
					if ((x[1] && x[2]) || (x[3] && x[6]) || (x[4] && x[8]))
						x_win <= 1;
				end	
				
				inval_move <= 0;
				turn <= ~turn;
			end
		end
		else if (move[1]) begin
			if (x[1] || o[1]) begin
				inval_move <= 1;
			end
			else begin
				if (turn) begin
					o[1] <= 1;
					if ((o[0] && o[2]) || (o[4] && o[7]))
						o_win <= 1;
				end
				else begin
					x[1] <= 1;
					if ((x[0] && x[2]) || (x[4] && x[7]))
						x_win <= 1;
				end	
				
				inval_move <= 0;
				turn <= ~turn;
			end
		end
		else if (move[2]) begin
			if (x[2] || o[2]) begin
				inval_move <= 1;
			end
			else begin
				if (turn) begin
					o[2] <= 1;
					if ((o[0] && o[1]) || (o[5] && o[8]) || (o[4] && o[6]))
						o_win <= 1;
				end
				else begin
					x[2] <= 1;
					if ((x[0] && x[1]) || (x[5] && x[8]) || (x[4] && x[6]))
						x_win <= 1;
				end	
				
				inval_move <= 0;
				turn <= ~turn;
			end
		end
		else if (move[3]) begin
			if (x[3] || o[3]) begin
				inval_move <= 1;
			end
			else begin
				if (turn) begin
					o[3] <= 1;
					if ((o[0] && o[6]) || (o[4] && o[5]))
						o_win <= 1;
				end
				else begin
					x[3] <= 1;
					if ((x[0] && x[6]) || (x[4] && x[5]))
						x_win <= 1;
				end	
				
				inval_move <= 0;
				turn <= ~turn;
			end
		end
		else if (move[4]) begin
			if (x[4] || o[4]) begin
				inval_move <= 1;
			end
			else begin
				if (turn) begin
					o[4] <= 1;
					if ((o[0] && o[8]) || (o[1] && o[7]) || (o[2] && o[6]) || (o[3] && o[5]))
						o_win <= 1;
				end
				else begin
					x[4] <= 1;
					if ((x[0] && x[8]) || (x[1] && x[7]) || (x[2] && x[6]) || (x[3] && x[5]))
						x_win <= 1;
				end	
				
				inval_move <= 0;
				turn <= ~turn;
			end
		end
		else if (move[5]) begin
			if (x[5] || o[5]) begin
				inval_move <= 1;
			end
			else begin
				if (turn) begin
					o[5] <= 1;
					if ((o[3] && o[4]) || (o[2] && o[8]))
						o_win <= 1;
				end
				else begin
					x[5] <= 1;
					if ((x[3] && x[4]) || (x[2] && x[8]))
						x_win <= 1;
				end	
				
				inval_move <= 0;
				turn <= ~turn;
			end
		end
		else if (move[6]) begin
			if (x[6] || o[6]) begin
				inval_move <= 1;
			end
			else begin
				if (turn) begin
					o[6] <= 1;
					if ((o[0] && o[3]) || (o[2] && o[4]) || (o[7] && o[8]))
						o_win <= 1;
				end
				else begin
					x[6] <= 1;
					if ((x[0] && x[3]) || (x[2] && x[4]) || (x[7] && x[8]))
						x_win <= 1;
				end	
				
				inval_move <= 0;
				turn <= ~turn;
			end
		end
		else if (move[7]) begin
			if (x[7] || o[7]) begin
				inval_move <= 1;
			end
			else begin
				if (turn) begin
					o[7] <= 1;
					if ((o[1] && o[4]) || (o[6] && o[8]))
						o_win <= 1;
				end
				else begin
					x[7] <= 1;
					if ((x[1] && x[4]) || (x[6] && x[8]))
						x_win <= 1;
				end	
				
				inval_move <= 0;
				turn <= ~turn;
			end
		end
		else if (move[8]) begin
			if (x[8] || o[8]) begin
				inval_move <= 1;
			end
			else begin
				if (turn) begin
					o[8] <= 1;
					if ((o[0] && o[4]) || (o[2] && o[5]) || (o[6] && o[7]))
						o_win <= 1;
				end
				else begin
					x[8] <= 1;
					if ((x[0] && x[4]) || (x[2] && x[5]) || (x[6] && x[7]))
						x_win <= 1;
				end	
				
				inval_move <= 0;
				turn <= ~turn;
			end
		end
		
	end

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
