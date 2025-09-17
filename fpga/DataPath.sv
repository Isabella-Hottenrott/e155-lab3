module DataPath(input logic clk, reset,
				input logic [3:0] inputrows,
				input logic scan_counter_en, WE_synch, debouncer_counter_en, check_again, WE_send,
				output logic buttonpush, synch_done, debounce_done, post_debounce,
				output logic [8:0] seg0, seg1,
				output logic [3:0] cols);
				
				logic [1:0] encoded_cols;
				logic [3:0] synchrows, debounce_count;
				

				scancounter scancounter(.clk(clk), .reset(reset), .scan_counter_en(scan_counter_en), .encoded_cols(encoded_cols));

				combcol combcol(.incols(encoded_cols), .outcols(cols));
					
				synchronizer synchronizer(.clk(clk), .reset(reset), .WE_synch(WE_synch), .inputrows(inputrows), .synchrows(synchrows), .synch_done(synch_done));

				debouncer debouncer(.clk(clk), .reset(reset), .debouncer_counter_en(debouncer_counter_en), .debounce_done(debounce_done));
					
				seg_ff seg_ff(.clk(clk), .reset(reset), .WE_send(WE_send), .cols(cols), .synchrows(synchrows), .seg0(seg0), .seg1(seg1));


				always_comb 
					begin
						buttonpush = |inputrows;
						post_debounce = (check_again && (inputrows == synchrows));
					end
					
				

endmodule
						