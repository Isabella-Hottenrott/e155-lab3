// Isabella Hottenrott
// combcol.sv
// ihottenrott@g.hmc.edu
// 19/9/2025
// Module containing binary encoding for columns

module combcol(input logic [1:0] incols,
                output logic [3:0] outcols);

                always_comb
					case(incols)
						0:		outcols = 4'b0001;
						1:		outcols = 4'b0010;
						2:		outcols = 4'b0100;
						3:		outcols = 4'b1000;
					endcase
					

endmodule
