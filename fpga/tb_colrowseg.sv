// Isabella Hottenrott
// tb_colrowseg.sv
// ihottenrott@g.hmc.edu
// 19/9/2025
// Testbench for the colrowseg module for E155 Lab 3

module tb_colrowseg();
	logic clk, reset, anode, anexp;
    logic [3:0] digit, expdigit;
    logic [8:0] col_row_comb;
	logic [4:0] vectornum, errors;
	
	
	colrowseg dut(.col_row_comb(col_row_comb), .digit(digit), .anode(anode));


	always
		begin
			clk=1; #5;
			clk=0; #5;
		end
		
	initial begin
			vectornum=6'd0; errors=0; reset=1; #22; reset=0;
			
			vectornum=6'd1; col_row_comb=9'b100010001; expdigit = 4'b1010; anexp= 1'b1; #10;
			vectornum=6'd2; col_row_comb=9'b100100001; expdigit = 4'b0000; anexp= 1'b1; #10;
			vectornum=6'd3; col_row_comb=9'b101000001; expdigit = 4'b1011; anexp= 1'b1; #10;
			vectornum=6'd4; col_row_comb=9'b110000001; expdigit = 4'b1111; anexp= 1'b1; #10;
			vectornum=6'd5; col_row_comb=9'b100010010; expdigit = 4'b0111; anexp= 1'b1; #10;
			vectornum=6'd6; col_row_comb=9'b100100010; expdigit = 4'b1000; anexp= 1'b1; #10;
			vectornum=6'd7; col_row_comb=9'b101000010; expdigit = 4'b1001; anexp= 1'b1; #10;
			vectornum=6'd8; col_row_comb=9'b110000010; expdigit = 4'b1110; anexp= 1'b1; #10;
			vectornum=6'd9; col_row_comb=9'b100010100; expdigit = 4'b0100; anexp= 1'b1; #10;
			vectornum=6'd10; col_row_comb=9'b100100100; expdigit = 4'b0101; anexp= 1'b1; #10;
			vectornum=6'd11; col_row_comb=9'b101000100; expdigit = 4'b0110; anexp= 1'b1; #10;
			vectornum=6'd12; col_row_comb=9'b110000100; expdigit = 4'b1101; anexp= 1'b1; #10;
			vectornum=6'd13; col_row_comb=9'b100011000; expdigit = 4'b0001; anexp= 1'b1; #10;
			vectornum=6'd14; col_row_comb=9'b100101000; expdigit = 4'b0010; anexp= 1'b1; #10;
			vectornum=6'd15; col_row_comb=9'b101001000; expdigit = 4'b0011; anexp= 1'b1; #10;
			vectornum=6'd16; col_row_comb=9'b110001000; expdigit = 4'b1100; anexp= 1'b1; #10;
            
            vectornum=6'd17; col_row_comb=9'b000010001; expdigit = 4'b1010; anexp= 1'b0; #10;
			vectornum=6'd18; col_row_comb=9'b000100001; expdigit = 4'b0000; anexp= 1'b0; #10;
			vectornum=6'd19; col_row_comb=9'b001000001; expdigit = 4'b1011; anexp= 1'b0; #10;
			vectornum=6'd20; col_row_comb=9'b010000001; expdigit = 4'b1111; anexp= 1'b0; #10;
			vectornum=6'd21; col_row_comb=9'b000010010; expdigit = 4'b0111; anexp= 1'b0; #10;
			vectornum=6'd22; col_row_comb=9'b000100010; expdigit = 4'b1000; anexp= 1'b0; #10;
			vectornum=6'd23; col_row_comb=9'b001000010; expdigit = 4'b1001; anexp= 1'b0; #10;
			vectornum=6'd24; col_row_comb=9'b010000010; expdigit = 4'b1110; anexp= 1'b0; #10;
			vectornum=6'd25; col_row_comb=9'b000010100; expdigit = 4'b0100; anexp= 1'b0; #10;
			vectornum=6'd26; col_row_comb=9'b000100100; expdigit = 4'b0101; anexp= 1'b0; #10;
			vectornum=6'd27; col_row_comb=9'b001000100; expdigit = 4'b0110; anexp= 1'b0; #10;
			vectornum=6'd28; col_row_comb=9'b010000100; expdigit = 4'b1101; anexp= 1'b0; #10;
			vectornum=6'd29; col_row_comb=9'b000011000; expdigit = 4'b0001; anexp= 1'b0; #10;
			vectornum=6'd30; col_row_comb=9'b000101000; expdigit = 4'b0010; anexp= 1'b0; #10;
			vectornum=6'd31; col_row_comb=9'b001001000; expdigit = 4'b0011; anexp= 1'b0; #10;
			vectornum=6'd32; col_row_comb=9'b010001000; expdigit = 4'b1100; anexp= 1'b0; #10;
			$display("completed with %d errors", errors);
			$stop;
		end
		

	always @(negedge clk)
		if (~reset) begin
			if ((expdigit !== digit)||(anexp !== anode)) begin
				$display("Error on test = %d ", vectornum);
				errors = errors + 1;
			end

end 
endmodule