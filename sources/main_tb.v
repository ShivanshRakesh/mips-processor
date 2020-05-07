`timescale 1ns / 1ps
module main_tb;
	reg clk; 

	main uut (
		.clk(clk)
	);
	
	initial begin
		clk = 1;
	end 
	
	always begin
	#5 clk=~clk;
	end
      
endmodule

