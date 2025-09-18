// Isabella Hottenrott
// clock_div.sv
// ihottenrott@g.hmc.edu
// 19/9/2025
// Module containing Verilog code for clock division to 60 Hz.

module clock_div(input logic reset,
				input logic clk,
				output logic int_osc);
	
		logic [18:0] counter;
	 
	  
	   always_ff @(posedge clk) begin
		if (~reset) begin
			counter <=19'd0;
			int_osc<=0;
		end
        else if (counter == 19'd100_000) begin
            counter <= 19'd0;
            int_osc <= ~int_osc; 
        end else begin
            counter <= counter + 1;
        end
    end


endmodule