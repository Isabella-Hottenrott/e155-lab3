module scancounter(input logic clk, reset,
                    input logic scan_counter_en,
                    input logic reset,
                    input logic [3:0] cols,
                    input logic [3:0] synchrows,
                    output logic [8:0] seg0,
                    output logic [8:0] seg1)

always_ff @(posedge clk) begin
    if (reset) begin
        encoded_cols <='0;
    end
    
    else if (scan_counter_en) begin 
		encoded_cols <= encoded_cols + 2'b01;
	end

end


endmodule