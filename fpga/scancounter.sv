// Isabella Hottenrott
// scancounter.sv
// ihottenrott@g.hmc.edu
// 19/9/2025
// Module containing incrementer that allows scanning of columns 
// on the 4x4 keypad

module scancounter(input logic clk, reset,
                    input logic scan_counter_en,
                    output logic [1:0] encoded_cols);

always_ff @(posedge clk, negedge reset) begin
    if (~reset) begin
        encoded_cols <=2'b00;
    end
    
    else if (scan_counter_en) begin 
		encoded_cols <= encoded_cols + 2'b01;
        // sweep through columns, encoded as a 2 bit number
	end

end


endmodule