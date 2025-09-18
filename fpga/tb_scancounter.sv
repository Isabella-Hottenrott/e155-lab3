// Isabella Hottenrott
// tb_scancounter.sv
// ihottenrott@g.hmc.edu
// 13/9/2025
// Testbench for scancounter module in Lab 3

module tb_scancounter();
	logic clk, reset;
    logic scan_counter_en;
    logic [1:0] encoded_cols, encoded_colsexp;
	logic [4:0] errors, vectornum;

	scancounter dut(.clk(clk), .reset(reset), .scan_counter_en(scan_counter_en), .encoded_cols(encoded_cols));


	always
		begin
			clk=1; #5;
			clk=0; #5;
		end
		
	initial begin
			errors=0; #10; vectornum=5'd0; reset=0; scan_counter_en=1'bx; encoded_colsexp = 2'b00; #10; reset=1;
			vectornum=5'd1; scan_counter_en=1'b0; encoded_colsexp = 2'b00; #10;
            vectornum=5'd2; scan_counter_en=1'b1; encoded_colsexp = 2'b01; #10;
            vectornum=5'd3; scan_counter_en=1'b1; encoded_colsexp = 2'b10; #10;
            vectornum=5'd4; scan_counter_en=1'b1; encoded_colsexp = 2'b11; #10;
            vectornum=5'd5; scan_counter_en=1'b1; encoded_colsexp = 2'b00; #10;
            vectornum=5'd6; scan_counter_en=1'b1; encoded_colsexp = 2'b01; #10;
            vectornum=5'd7; scan_counter_en=1'b1; encoded_colsexp = 2'b10; #10;
            vectornum=5'd8; scan_counter_en=1'b1; encoded_colsexp = 2'b11; #10;
            vectornum=5'd9; scan_counter_en=1'b0; encoded_colsexp = 2'b11; #10;

			$display("completed with %d errors", errors);
			$stop;
		end
		

	always @(negedge clk)
		if (reset) begin
			if ((encoded_cols !== encoded_colsexp)) begin
				$display("Error: on test = %d ", vectornum);
				errors = errors + 1;
			end

end 
endmodule