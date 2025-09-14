module seg_ff(input logic clk, reset,
            input logic WE_send,
            input logic [3:0] cols,
            input logic [3:0] synchrows,
            output logic [8:0] seg0,
            output logic [8:0] seg1)

always_ff @(posedge clk) begin
    if (reset) begin
        seg1 <= 9'b0;
		seg0 <= 9'b0;
    end

    else if (WE_send) begin
		seg1 <= seg0;
		// WE_send is concatinated for the anode
		seg0 <= {WE_send, cols, synchrows};
	end
end


endmodule