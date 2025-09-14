module CombCol(input logic [1:0] inCols,
                output logic [3:0] outCols);

                //creating encoding for rows
                always_comb
					case(inCols)
						0:		outCols = 4'b0001;
						1:		outCols = 4'b0010;
						2:		outCols = 4'b0100;
						3:		outCols = 4'b1000;
					endcase
					

endmodule
