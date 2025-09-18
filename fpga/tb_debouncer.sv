// Isabella Hottenrott
// tb_debouncer.sv
// ihottenrott@g.hmc.edu
// 13/9/2025
// Testbench for debouncer module in Lab 3

module tb_debouncer();
	logic clk, reset;
    logic debouncer_counter_en, debounce_done, exp_debounce_done;
	logic [4:0] errors, vectornum;
	
	debouncer dut(.clk(clk), .reset(reset), .debouncer_counter_en(debouncer_counter_en), .debounce_done(debounce_done));


	always
		begin
			clk=1; #5;
			clk=0; #5;
		end
		
	initial begin
			errors=0; #10; vectornum=5'd1; reset=1; exp_debounce_done=0; #10; reset=0;
			
			vectornum=5'd2; debouncer_counter_en=1'b0; exp_debounce_done=0; #30; vectornum=5'd3; exp_debounce_done=0;
			#10; debouncer_counter_en=1'b1;
            #10; vectornum=5'd4; exp_debounce_done=0;
            #5999980; vectornum=5'd5; exp_debounce_done=1; // waited 20 timestamps before this
			#10; exp_debounce_done=0; 
            #20; vectornum=5'd6; exp_debounce_done=0; #20 debouncer_counter_en =1'b0; exp_debounce_done=1'b0; #20;
			$display("completed with %d errors", errors);
			$stop;
		end
		

	always @(negedge clk)
		if (~reset) begin
			if (exp_debounce_done !== debounce_done) begin
				$display("Error: on test = %d ", vectornum);
				errors = errors + 1;
			end

end 
endmodule