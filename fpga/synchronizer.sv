// Isabella Hottenrott
// synchronizer.sv
// ihottenrott@g.hmc.edu
// 9/9/2025
// Module containing Verilog synchronization of asynchronous/timely inputs

module synchronizer(input logic clk, reset,
                    input logic WE_synch,
                    input logic [3:0] inputrows,
                    output logic [3:0] synchrows,
                    output logic synch_done);

logic [3:0] synch_branch;
logic [1:0] synch_count;

always_ff @(posedge clk) begin
	if (WE_synch) begin
		synch_count <= synch_count + 2'b01;
		synch_branch <= inputrows;
		synchrows <= synch_branch;
	end
    else begin 
        synch_count <= 2'b0; 
        end
end

assign synch_done = (synch_count == 2'b10);
// send a done signal to FSM when two clock cycles have past

endmodule

    
