module debouncer(input logic clk, reset,
                input logic debouncer_counter_en,
                output logic debounce_done);
    
  logic [3:0] debounce_count;

  always_ff @(posedge clk) begin   
    if (reset) begin
        debounce_count <= 4'b0;
    end
    else if (debounce_counter_en) begin
		  debounce_count <= debounce_count + 4'b0001;
    end
  end
					
assign debounce_done = (debounce_count == 4'b0011);


endmodule