module scancounter(input logic clk, reset,
                    input logic scan_counter_en,
                    output logic [1:0] encoded_cols);

always_ff @(posedge clk, negedge reset) begin
    if (~reset) begin
        encoded_cols <=2'b00;
    end
    
    else if (scan_counter_en) begin 
		encoded_cols <= encoded_cols + 2'b01;
	end

end


endmodule