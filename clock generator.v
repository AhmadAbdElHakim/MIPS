module clock(clk);
`timescale 100ps/1ps
output reg clk;
initial
	begin
		clk <= 0;
	end
always
	begin
		#625
		clk <= 1;
		#625
		clk <= 0;
	end
endmodule
