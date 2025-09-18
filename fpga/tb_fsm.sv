// Isabella Hottenrott
// tb_fsm.sv
// ihottenrott@g.hmc.edu
// 13/9/2025
// Testbench for fsm module in Lab 3

module tb_fsm();
	logic clk, reset;
	logic [2:0] state, nstate;
	typedef enum logic [2:0] {s0, s1, s2, s3, s4, s5} statetype;

    statetype stateExp, nstateExp;
    logic buttonpush, synch_done, debounce_done, post_debounce;
    logic scan_counter_en, WE_synch, debouncer_counter_en, check_again, WE_send;
    logic scan_counter_enexp, WE_synchexp, debouncer_counter_enexp, check_againexp, WE_sendexp;
    logic [4:0] vectornum, errors;
	
	FSM dut(.clk(clk), .reset(reset), .buttonpush(buttonpush), .synch_done(synch_done), .debounce_done(debounce_done), .post_debounce(post_debounce), 
    .scan_counter_en(scan_counter_en), .WE_synch(WE_synch), .debouncer_counter_en(debouncer_counter_en), .check_again(check_again), .WE_send(WE_send));

    assign state = dut.state;
    assign nstate = dut.nstate;


	always
		begin
			clk=1; #5;
			clk=0; #5;
		end
		
	initial begin
			errors=0; #10; vectornum=5'd1; reset=0; stateExp=s0; nstateExp=s0; buttonpush=0; scan_counter_enexp = 1; WE_synchexp=0; debouncer_counter_enexp=0; check_againexp=0; WE_sendexp=0; #10; reset=1;
			#10; vectornum=5'd2; stateExp=s0; nstateExp=s0; buttonpush=0; scan_counter_enexp = 1; WE_synchexp=0; debouncer_counter_enexp=0; check_againexp=0; WE_sendexp=0;
            #10; vectornum=5'd3; stateExp=s0; nstateExp=s1; buttonpush=1; scan_counter_enexp = 0; WE_synchexp=0; debouncer_counter_enexp=0; check_againexp=0; WE_sendexp=0;
            #10; vectornum=5'd4; stateExp=s1; nstateExp=s1; synch_done=0; scan_counter_enexp = 0; WE_synchexp=1; debouncer_counter_enexp=0; check_againexp=0; WE_sendexp=0;
            #10; vectornum=5'd5; stateExp=s1; nstateExp=s2; synch_done=1; scan_counter_enexp = 0; WE_synchexp=1; debouncer_counter_enexp=0; check_againexp=0; WE_sendexp=0;
			#10; vectornum=5'd6; stateExp=s2; nstateExp=s2; debounce_done=0; scan_counter_enexp = 0; WE_synchexp=0; debouncer_counter_enexp=1; check_againexp=0; WE_sendexp=0;
            #10; vectornum=5'd7; stateExp=s2; nstateExp=s3; debounce_done=1; scan_counter_enexp = 0; WE_synchexp=0; debouncer_counter_enexp=1; check_againexp=0; WE_sendexp=0;
            #10; vectornum=5'd8; stateExp=s3; nstateExp=s0; post_debounce=0; scan_counter_enexp = 0; WE_synchexp=0; debouncer_counter_enexp=0; check_againexp=1; WE_sendexp=0;
            // check you went back to s0, and then redo this whole loop
            #10; vectornum=5'd9; stateExp=s0; nstateExp=s0; buttonpush=0; scan_counter_enexp = 1; WE_synchexp=0; debouncer_counter_enexp=0; check_againexp=0; WE_sendexp=0;
            #10; vectornum=5'd10; stateExp=s0; nstateExp=s1; buttonpush=1; scan_counter_enexp = 0; WE_synchexp=0; debouncer_counter_enexp=0; check_againexp=0; WE_sendexp=0;
            #10; vectornum=5'd11; stateExp=s1; nstateExp=s1; synch_done=0; scan_counter_enexp = 0; WE_synchexp=1; debouncer_counter_enexp=0; check_againexp=0; WE_sendexp=0;
            #10; vectornum=5'd12; stateExp=s1; nstateExp=s2; synch_done=1; scan_counter_enexp = 0; WE_synchexp=1; debouncer_counter_enexp=0; check_againexp=0; WE_sendexp=0;
			#10; vectornum=5'd13; stateExp=s2; nstateExp=s2; debounce_done=0; scan_counter_enexp = 0; WE_synchexp=0; debouncer_counter_enexp=1; check_againexp=0; WE_sendexp=0;
            #10; vectornum=5'd14; stateExp=s2; nstateExp=s3; debounce_done=1; scan_counter_enexp = 0; WE_synchexp=0; debouncer_counter_enexp=1; check_againexp=0; WE_sendexp=0;
            #10; vectornum=5'd15; stateExp=s3; nstateExp=s4; post_debounce=1; scan_counter_enexp = 0; WE_synchexp=0; debouncer_counter_enexp=0; check_againexp=1; WE_sendexp=0;
            // Now goto state 4
            #10; vectornum=5'd16; stateExp=s4; nstateExp=s5; debounce_done=0; scan_counter_enexp = 0; WE_synchexp=0; debouncer_counter_enexp=0; check_againexp=0; WE_sendexp=1;
            #10; vectornum=5'd17; stateExp=s5; nstateExp=s5; buttonpush=1; scan_counter_enexp = 0; WE_synchexp=0; debouncer_counter_enexp=0; check_againexp=0; WE_sendexp=0;
            #10; vectornum=5'd18; stateExp=s5; nstateExp=s0; buttonpush=0; scan_counter_enexp = 0; WE_synchexp=0; debouncer_counter_enexp=0; check_againexp=0; WE_sendexp=0;
            #10; vectornum=5'd19; stateExp=s0; nstateExp=s0; buttonpush=0; scan_counter_enexp = 1; WE_synchexp=0; debouncer_counter_enexp=0; check_againexp=0; WE_sendexp=0;
			#20;$display("completed with %d errors", errors);
			$stop;
		end
		

	always @(negedge clk)
			if ((state !== stateExp)||(nstate !== nstateExp)||(scan_counter_enexp !== scan_counter_en)|| (WE_synch !== WE_synchexp) || (debouncer_counter_en !== debouncer_counter_enexp) || (check_again !== check_againexp) || (WE_send !== WE_sendexp))
             begin
				$display("Error: on test = %d ", vectornum);
				errors = errors + 1;
			end

    



endmodule