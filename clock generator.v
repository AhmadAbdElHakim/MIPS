module clock(clk);
`timescale 10ps/1ps
output reg clk;
initial
	begin
		clk <= 0;
	end
always
	begin
		#3125
		clk <= 1;
		#3125
		clk <= 0;
	end
endmodule
