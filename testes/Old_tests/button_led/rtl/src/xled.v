`timescale 1ns / 1ps
`include "xdefs.vh"

module xled (
		input 	   reset,
		input 	   clk,
		input 	   led_sel,
	        input      button,
		output reg led
		);

 always @(posedge clk,posedge reset)
   if (reset)
     led <= 1'b0;
   else if(led_sel && button)
     led <= 1'b1;
     

endmodule
