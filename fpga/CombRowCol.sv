module CombRowCol(input logic [1:0] inRows, inCols,
                    output logic [3:0] outRows, outCols);

                //creating encoding for rows
                always_comb
					case(inCols)
						0:		inCols = 4'b0001;
						1:		inCols = 4'b0010;
						2:		inCols = 4'b0100;
						3:		inCols = 4'b1000;
					endcase
					
				//creating ecoding for rows
				always_comb
					case(inRows)
						0:		outRows = 4'b0001;
						1:		outRows = 4'b0010;
						2:		outRows = 4'b0100;
						3:		outRows = 4'b1111;
					endcase

endmodule
