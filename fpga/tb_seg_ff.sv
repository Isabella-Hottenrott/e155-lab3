// Isabella Hottenrott
// tb_debouncer.sv
// ihottenrott@g.hmc.edu
// 13/9/2025
// Testbench for seg_ff.sv module in Lab3ih

module tb_seg_ff();
	logic clk, reset;
    logic WE_send;
    logic [3:0] cols, synchrows;
    logic [8:0] seg0, seg1, seg0exp, seg1exp;
	
	seg_ff dut(.clk(clk), .reset(reset), .WE_send(WE_send), .cols(cols), .synchrows(synchrows), .seg0(seg0), .seg1(seg1));


	always
		begin
			clk=1; #5;
			clk=0; #5;
		end
		
	initial begin
			errors=0; #10; vectornum=5'd0; reset=1; cols=4'bx; synchrows=4'bx; WE_send = 1'bx; seg0exp=9'b0; seg1exp = 9'b0; #10; reset=0;
			
			vectornum=5'd1; WE_send=1'b0; cols=4'bx; synchrows=4'bx; seg0exp=9'b0; seg1exp = 9'b0;
			#10; vectornum=5'd2; WE_send=1'b1; cols=4'b1010; synchrows=4'b0101; seg0exp=9'b110100101; seg1exp = 9'b0;
            #10; vectornum=5'd3; WE_send = 1'b0; cols=4'b1111; synchrows=4'b1111; seg0exp=9'b110100101; seg1exp = 9'b0;
            #10; vectornum=5'd4; WE_send=1'b1; cols=4'b0011; synchrows=4'b0100; seg0exp=9'b100110100; seg1exp = 9'b110100101;
            #10; vectornum=5'd5; WE_send = 1'b0; cols=4'b1111; synchrows=4'b1111; seg0exp=9'b100110100; seg1exp = 9'b110100101;
			#10; vectornum=5'd6; WE_send = 1'b0; cols=4'b1111; synchrows=4'b1111; seg0exp=9'b100110100; seg1exp = 9'b110100101;
            #10; reset=1; seg0exp=9'b0; seg1exp = 9'b0;

			$display("completed with %d errors", errors);
			$stop;
		end
		

	always @(negedge clk)
		if (~reset) begin
			if ((seg0 !== seg0exp)||(seg1 !== seg1exp)) begin
				$display("Error: on test = %d ", vectornum);
				errors = errors + 1;
			end

end 
endmodule