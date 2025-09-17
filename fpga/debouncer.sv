module debouncer(input logic clk, reset,
                input logic debouncer_counter_en,
                output logic debounce_done);
    
  logic [21:0] debounce_count;

  always_ff @(posedge clk) begin   
    if (debouncer_counter_en) begin
		  debounce_count <= debounce_count + 22'b1;
    end else begin
        debounce_count <= 22'b0;
    end
  end
		
assign debounce_done = (debounce_count == 20'b0010010010011111000000);


endmodule