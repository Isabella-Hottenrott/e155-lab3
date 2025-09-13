module DataPath(input logic clk, reset,
				input logic scan_counter_en, WE_synch, debounce_counter_en, check_again, WE_send,
				input logic [3:0] inputrows,
				output logic buttonpush, synch_done, debounce_done, post_debounce,
				output logic [6:0] seg0, seg1,
				output logic [3:0] cols);
				
				logic [1:0] encoded_rows, encoded_cols, synch_count;
				logic [3:0] synch_branch, synchrows, debounce_count;
				
				
				CombRowCol CombRowCol(.inRows(encoded_rows), .inCols(encoded_cols), .outRows(synchrows), .outCols(cols))
					
				
				always_ff @(posedge clk, negedge reset) begin
					if (~reset) begin
						encoded_cols <='0;
						synch_count <='0;
						debounce_count <= '0;
					end
						
					// iterate through cols at posedge clk
					else if (scan_counter_en) begin 
						encoded_cols <= encoded_cols + 1;
					end
					
					// synchronizer
					else if (WE_synch) begin
						synch_count <= synch_count +1;
						synch_branch <= inputrows;
						synchrows <= synch_branch;
					end
					
					else if (debounce_counter_en) begin
						debounce_count <= debounce_count+ 1;
					end
					
					else if (check_again) begin
						post_debounce = (inputrows == synchrows);
					end
					
					else if (WE_send) begin
						seg0 <= {cols, synchrows};
						seg1 <= seg0;
					end
						
				end
				
				
				// no sensitivity list for reading rows
				always
					begin
						buttonpush = |inputrows;
					end
					
				assign wait_done = (debounce_count == 4'b1111); // do the actual conversion for what the time should be
				assign synch_done = (synch_count == 2'b11); // done synchronizing after two clock cycles
				

endmodule
						