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
	 input JA [7:0], // keypad
	 output seg [7:0], // seven seg display
	 output an [4:0],
	 output Led [7:0], // LED
	 output vgaRed [2:0], // vga display
	 output vgaGreen [2:0],
	 output vgaBlue [1:0],
	 output Hsync,
	 output Vsync
	 );


endmodule

module seven_seg_display(
);

endmodule


module vga_display(
);

endmodule

