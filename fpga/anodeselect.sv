// Isabella Hottenrott
// anodeselect.sv
// ihottenrott@g.hmc.edu
// 9/9/2025
// Anode and switch selecting modules for E155 Lab 2


module anodeselect(
            input logic int_osc, reset,
			input logic seg0anode, seg1anode,
            input logic [6:0] segment0,
            input logic [6:0] segment1,
            output logic [6:0] segmentOut,
            output logic anodeZeroOut, anodeOneOut);


        assign segmentOut = int_osc ? segment0 : segment1;
        assign anodeZeroOut = (~int_osc)|seg0anode;
        assign anodeOneOut = int_osc|seg1anode;

		
endmodule