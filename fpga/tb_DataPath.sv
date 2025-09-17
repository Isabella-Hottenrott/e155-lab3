// Isabella Hottenrott
// tb_debouncer.sv
// ihottenrott@g.hmc.edu
// 13/9/2025
// Testbench for seg_ff.sv module in Lab3ih

module tb_DataPath();
	logic clk, reset;
	logic [3:0] inputrows;
    logic scan_counter_en, WE_synch, debouncer_counter_en, check_again, WE_send;
    logic buttonpush, synch_done, debounce_done, post_debounce;
	logic buttonpushex, synch_doneex, debounce_doneex, post_debounceex;
    logic [8:0] seg0, seg1, seg0ex, seg1ex;
	logic [3:0] cols, colsex;
	logic [4:0] errors, vectornum;
	
	DataPath DataPath(.clk(clk), .reset(reset), .inputrows(inputrows), .scan_counter_en(scan_counter_en), .WE_synch(WE_synch), .debouncer_counter_en(debouncer_counter_en),
	.check_again(check_again), .WE_send(WE_send), .buttonpush(buttonpush), .synch_done(synch_done), .debounce_done(debounce_done), .post_debounce(post_debounce),
	.seg0(seg0), .seg1(seg1), .cols(cols));


	always
		begin
			clk=1; #5;
			clk=0; #5;
		end
		
	initial begin
			errors=0; #10; vectornum=5'd0; reset=0; scan_counter_en=0; WE_synch=0; debouncer_counter_en=0; check_again=0; WE_send=0;
			inputrows = 4'b0000; buttonpushex=0; synch_doneex=0; debounce_doneex =0; post_debounceex=0; seg0ex=9'b1xxxxxxxx; seg1ex=9'b1xxxxxxxx;
			colsex=4'b0001;

			#10; reset=0;
			// all zeroes
			#10; vectornum=5'd1; reset=1; scan_counter_en=1; WE_synch=0; debouncer_counter_en=0; check_again=0; WE_send=0;
			inputrows = 4'b0000; buttonpushex=0; synch_doneex=0; debounce_doneex =0; post_debounceex=0; seg0ex=9'b1xxxxxxxx; seg1ex=9'b1xxxxxxxx;
			colsex=4'b0001;
			

			#10; vectornum=5'd2; reset=1; scan_counter_en=0; WE_synch=0; debouncer_counter_en=0; check_again=0; WE_send=0;
			inputrows = 4'b0001; buttonpushex=1; synch_doneex=0; debounce_doneex =0; post_debounceex=0; seg0ex=9'b1xxxxxxxx; seg1ex=9'b1xxxxxxxx;
			colsex=4'b0001;
			

			#10; vectornum=5'd3; reset=1; scan_counter_en=0; WE_synch=1; debouncer_counter_en=0; check_again=0; WE_send=0;
			inputrows = 4'b0001; buttonpushex=1; synch_doneex=0; debounce_doneex =0; post_debounceex=0; seg0ex=9'b1xxxxxxxx; seg1ex=9'b1xxxxxxxx;
			colsex=4'b0010;
			
	
			#10; vectornum=5'd4; reset=1; scan_counter_en=0; WE_synch=1; debouncer_counter_en=0; check_again=0; WE_send=0;
			inputrows = 4'b0001; buttonpushex=1; synch_doneex=1; debounce_doneex =0; post_debounceex=0; seg0ex=9'b1xxxxxxxx; seg1ex=9'b1xxxxxxxx;
			colsex=4'b0100;
			
	
			#10; vectornum=5'd5; reset=1; scan_counter_en=0; WE_synch=0; debouncer_counter_en=1; check_again=0; WE_send=0;
			inputrows = 4'b0001; buttonpushex=1; synch_doneex=0; debounce_doneex =0; post_debounceex=0; seg0ex=9'b1xxxxxxxx; seg1ex=9'b1xxxxxxxx;
			colsex=4'b0100;
			
	
			#6000000; vectornum=5'd6; reset=1; scan_counter_en=0; WE_synch=0; debouncer_counter_en=1; check_again=0; WE_send=0;
			inputrows = 4'b0001; buttonpushex=1; synch_doneex=0; debounce_doneex =1; post_debounceex=0; seg0ex=9'b000100001; seg1ex=9'b000100001;
			colsex=4'b0100;
			

			#10; vectornum=5'd7; reset=1; scan_counter_en=0; WE_synch=0; debouncer_counter_en=0; check_again=1; WE_send=0;
			inputrows = 4'b0001; buttonpushex=1; synch_doneex=0; debounce_doneex =0; post_debounceex=0; seg0ex=9'b000100001; seg1ex=9'b000100001;
			colsex=4'b0100;
			
			
			#10; vectornum=5'd8; reset=1; scan_counter_en=0; WE_synch=1; debouncer_counter_en=0; check_again=1; WE_send=1;
			inputrows = 4'b0000; buttonpushex=0; synch_doneex=0; debounce_doneex =0; post_debounceex=0; seg0ex=9'b1xxxxxxxx; seg1ex=9'b1xxxxxxxx;
			colsex=4'b0100;
			

			// individual controls:

			//post_debounce: both high
			#10; vectornum=5'd9; reset=1; scan_counter_en=0; WE_synch=0; debouncer_counter_en=0; check_again=1; WE_send=0;
			inputrows = 4'b0000; buttonpushex=0; synch_doneex=0; debounce_doneex =0; post_debounceex=1; seg0ex=9'b1xxxxxxxx; seg1ex=9'b1xxxxxxxx;
			colsex=4'b0100;
			
			//post_debounce: check again low, others high
			#10; vectornum=5'd9; reset=1; scan_counter_en=0; WE_synch=1; debouncer_counter_en=0; check_again=0; WE_send=0;
			inputrows = 4'b0000; buttonpushex=0; synch_doneex=0; debounce_doneex =0; post_debounceex=0; seg0ex=9'b1xxxxxxxx; seg1ex=9'b1xxxxxxxx;
			colsex=4'b0100;

			//post_debounce: check both low
			#10; vectornum=5'd9; reset=1; scan_counter_en=0; WE_synch=1; debouncer_counter_en=0; check_again=0; WE_send=0;
			inputrows = 4'b0000; buttonpushex=0; synch_doneex=0; debounce_doneex =0; post_debounceex=0; seg0ex=9'b1xxxxxxxx; seg1ex=9'b1xxxxxxxx;
			colsex=4'b0100;

			// need to see when synchrows==inputrows

			$display("completed with %d errors", errors);
			$stop;
		end
		

	always @(negedge clk)
		if (~reset) begin
			if ((buttonpush !== buttonpushex)||(synch_doneex !== synch_done) || (debounce_doneex !== debounce_done)||(post_debounceex !== post_debounce)) begin
				$display("Error: on test = %d ", vectornum);
				errors = errors + 1;
			end

end 
endmodule