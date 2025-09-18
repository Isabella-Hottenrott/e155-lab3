// Isabella Hottenrott
// tb_lab3_ih.sv
// ihottenrott@g.hmc.edu
// 13/9/2025
// Testbench for Top level module of E155 Lab 3

module tb_top();
    logic clk, reset;
    logic [3:0] cols, inputrows;
    logic [6:0] segmentOut;
    logic anodeZeroOut, anodeOneOut;
    logic [9:0] errors;
    logic [4:0] vectornum;
	logic [15:0] clockticks;
				
	assign clk = dut.clk;
	
	`timescale 1ns/1ns;
		
    lab3_ih dut(.reset(reset), .inputrows(inputrows), .cols(cols), .segmentOut(segmentOut), .anodeZeroOut(anodeZeroOut), .anodeOneOut(anodeOneOut));
       
    initial begin
			reset = 0; #1; reset = 1; #1; reset =0; #15; reset=1; vectornum = 5'b0; inputrows = 4'b0;
			wait(cols == 4'b0010);
            inputrows = 4'b0100; #1000000000; vectornum = 5'b00010; inputrows = 4'b0000; #100000000;
			wait(cols == 4'b0001);
			inputrows = 4'b1000; vectornum = 5'b00011; #1000000000; vectornum = 5'b00100; inputrows = 4'b0000; #1000000000;
            $stop;
        end
        
	always @(posedge clk)
		if (~reset) begin
			vectornum=5'd0; inputrows=4'b0000; clockticks = 16'b0;
			end else begin
				clockticks = clockticks + 16'b1;
				end
			

 
endmodule