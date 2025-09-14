// Isabella Hottenrott
// tb_debouncer.sv
// ihottenrott@g.hmc.edu
// 13/9/2025
// Testbench for synchronizer.sv module in Lab3ih

module tb_synchronizer();
	logic clk, reset;
    logic WE_synch, synch_done, synch_doneexp;
    logic [3:0] inputrows, synchrows, synchrowsexp;
	
	synchronizer dut(.clk(clk), .reset(reset), .WE_synch(WE_synch), .inputrows(inputrows), .synchrows(synchrows), synch_done(synch_done));


	always
		begin
			clk=1; #5;
			clk=0; #5;
		end
		
	initial begin
			errors=0; #10; vectornum=5'd0; reset=1; synch_rows_exp=4'b0000; synch_doneexp=1'b0; #10; reset=0;
			
			vectornum=5'd1; WE_synch=1'b0; inputrows=1'b0000; synch_doneexp=1'b0; synch_rows_exp=4'b0000; 
			#10; vectornum=5'd2; WE_synch=1'b1; inputrows=1'b1000; synch_doneexp=1'b0; synch_rows_exp=4'b0000;
            #10; vectornum=5'd3; WE_synch=1'b1; inputrows=1'b1000; synch_doneexp=1'b0; synch_rows_exp=4'b0000;
            #10; vectornum=5'd4;  WE_synch=1'b1; inputrows=1'b1000; synch_doneexp=1'b1; synch_rows_exp=4'b1000;
			#10; vectornum=5'd4;  WE_synch=1'b0; inputrows=1'b1000; synch_doneexp=1'b0; synch_rows_exp=4'b1000;

			$display("completed with %d errors", errors);
			$stop;
		end
		

	always @(negedge clk)
		if (~reset) begin
			if ((synchrows !== synchrowsexp)||(synch_done !== synch_doneexp)) begin
				$display("Error: on test = %d ", vectornum);
				errors = errors + 1;
			end

end 
endmodule