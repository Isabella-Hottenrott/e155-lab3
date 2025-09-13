module lab3fsm(input logic clk,
				input logic reset,
				input logic buttonpush, synch_done, debounce_done, post_debounce,
				output logic scan_counter_en, WE_synch, debounce_counter_en, check_again, WE_send
				);
				
				typedef enum logic [2:0] {s0, s1, s2, s3, s4, s5} statetype;
				statetype state, nstate;
				
				always_ff@(posedge clk, posedge reset)
					if (reset) state <= s0;
					else state <= nstate;
						
				
				always_comb
					case(state)
						
						s0: if (buttonpush)		nstate = s1;
							else 				nstate = s0;
								
						s1: if (synch_done)		nstate = s2;
							else				nstate = s1;
								
						s2: if (debounce_done)	nstate = s3;
							else				nstate = s2;
								
						s3:	if (post_debounce)	nstate = s4;
							else				nstate = s0;
								
						s4:						nstate = s5;
						
						s5: if (~buttonpush)	nstate = s0;
							else 				nstate = s5;
								
						default: nstate = state;
					endcase
					
					
				assign scan_counter_en = (state == s0);
				assign WE_synch = (state == s1);
				assign debounce_counter_en = (state == s2);
				assign check_again = (state == s3);
				assign WE_send = (state == s4);
				
				
				endmodule;
				