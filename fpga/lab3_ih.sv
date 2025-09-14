module lab3_ih(input logic clk, reset, 
                input logic [3:0] inputrows,
				output logic [3:0] cols,
                output logic [6:0] segment0,
                output logic [6:0] segment1,
                output logic seg0anode, seg1anode);
//logic clk;
logic buttonpush, synch_done, debounce_done, post_debounce, scan_counter_en, WE_synch, debounce_counter_en, check_again, WE_send;
logic [3:0] digits0, digits1;
logic [8:0] seg0, seg1;

//HSOSC #(.CLKHF_DIV(2'b00)) 
	//		hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));
	
			
lab3fsm lab3fsm(.clk(clk), .reset(reset), .buttonpush(buttonpush), .synch_done(synch_done), .debounce_done(debounce_done), .post_debounce(post_debounce),
                .scan_counter_en(scan_counter_en), .WE_synch(WE_synch), .debounce_counter_en(debounce_counter_en), .check_again(check_again), .WE_send(WE_send));

DataPath DataPath(.clk(clk), .reset(reset), .inputrows(inputrows), .scan_counter_en(scan_counter_en), .WE_synch(WE_synch), .debounce_counter_en(debounce_counter_en), .check_again(check_again),
                    .WE_send(WE_send), .buttonpush(buttonpush), .synch_done(synch_done), .debounce_done(debounce_done), .post_debounce(post_debounce),
                    .seg0(seg0), .seg1(seg1), .cols(cols));

colrowseg colrowseg0(.col_row_comb(seg0), .digit(digits0), .anode(seg0anode));
colrowseg colrowseg1(.col_row_comb(seg1), .digit(digits1), .anode(seg1anode));

segments segments0(.digit(digits0), .segs(segment0));
segments segments1(.digit(digits1), .segs(segment1));



endmodule