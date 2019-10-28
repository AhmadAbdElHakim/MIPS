module clock(clk);
`timescale 100ns/1ps
output reg clk;
initial
	begin
		clk <= 0;
	end
always
	begin
		#31.25
		clk <= 1;
		#31.25
		clk <= 0;
	end
endmodule
