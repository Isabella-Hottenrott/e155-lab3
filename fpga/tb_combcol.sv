// Isabella Hottenrott
// tb_combcol.sv
// ihottenrott@g.hmc.edu
// 13/9/2025
// Testbench for combcol module in Lab 3

module tb_combcol();
	logic clk, reset;
    logic [3:0] outcols, outcolsexp;
    logic [1:0] incols;
	logic [2:0] vectornum, errors;
	
	
	combcol dut(.incols(incols), .outcols(outcols));


	always
		begin
			clk=1; #5;
			clk=0; #5;
		end
		
	initial begin
			vectornum=5'd0; errors=0; reset=1; #22; reset=0;
			
			vectornum=5'd1; incols=2'b00; outcolsexp = 4'b0001; #10;
			vectornum=5'd2; incols=2'b01; outcolsexp = 4'b0010; #10;
			vectornum=5'd3; incols=2'b10; outcolsexp = 4'b0100; #10;
			vectornum=5'd4; incols=2'b11; outcolsexp = 4'b1000; #10;
			$display("completed with %d errors", errors);
			$stop;
		end
		

	always @(negedge clk)
		if (~reset) begin
			if (outcols !== outcolsexp) begin
				$display("Error: on test = %d ", vectornum);
				errors = errors + 1;
			end

end 
endmodule