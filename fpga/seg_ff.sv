// Isabella Hottenrott
// seg_ff.sv
// ihottenrott@g.hmc.edu
// 19/9/2025
// Module containing a flop-enable for the output
// of the design.

module seg_ff(input logic clk, reset,
            input logic WE_send,
            input logic [3:0] cols,
            input logic [3:0] synchrows,
            output logic [8:0] seg0,
            output logic [8:0] seg1);

logic [8:0] old;

always_ff @(posedge clk) begin
    if (~reset) begin
      seg1 <= 9'b111111111;
	  seg0 <= 9'b111111111;
	  old <= 9'b111111111;
    end

    else if (WE_send) begin
		// WE_send is concatinated for the anode. (off anode drives transistor ON)
		seg0 <= {(~WE_send), cols, synchrows};
		seg1 <= seg0;
	end
end


endmodule