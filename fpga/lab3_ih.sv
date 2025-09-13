module lab3_ih(input logic reset, 
                input logic [3:0] rows,
                output logic [6:0] segment0,
                output logic [6:0] segment1,
                output logic seg0anode, seg1anode);



lab3fsm lab3fsm(.clk(clk), .reset(reset), .buttonpush(buttonpush), .synch_done(synch_done), .debounce_done(debounce_done), .post_debounce(post_debounce),
                .scan_counter_en(scan_counter_en), .WE_synch(WE_synch), .debounce_counter_en(debounce_counter_en), .check_again(check_again), .WE_send(WE_send));

Datapath Datapath(.clk(clk), .reset(reset), .scan_counter_en(scan_counter_en), .WE_synch(WE_synch), .debounce_counter_en(debounce_counter_en), .check_again(check_again),
                    .WE_send(WE_send), .inputrows(inputrows), .buttonpush(buttonpush), .synch_done(synch_done), .debounce_done(debounce_done), .post_debounce(post_debounce),
                    .seg0(seg0), .seg1(seg1), .cols(cols));

colrowseg colrowseg0(.seg(seg0), .digit(digits0));
colrowseg colrowseg1(.seg(seg1), .digit(digits1));

segments segments0(.digit(digits0), .segs(segment0));
segments segments1(.digit(digits1), .segs(segment1));



endmodule