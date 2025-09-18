// Isabella Hottenrott
// segments.sv
// ihottenrott@g.hmc.edu
// 19/9/2025
// Module containing Verilog code for Seven-segment display mapping

module segments(input logic [3:0] digit,
                output logic [6:0] segs);

always_comb
    case(digit)
        0:  segs = 7'b000_0001; //0
        1:  segs = 7'b100_1111; //1
        2:  segs = 7'b001_0010; //2
        3:  segs = 7'b000_0110; //3
        4:  segs = 7'b100_1100; //4
        5:  segs = 7'b010_0100; //5
        6:  segs = 7'b010_0000; //6
        7:  segs = 7'b000_1111; //7
        8:  segs = 7'b000_0000; //8
        9:  segs = 7'b000_1100; //9
		10: segs = 7'b000_1000; //a
		11: segs = 7'b110_0000; //b
		12: segs = 7'b011_0001; //c
		13: segs = 7'b100_0010; //d
		14: segs = 7'b011_0000; //e
		15: segs = 7'b011_1000; //f
        default:    segs = 7'b111_1111;
    endcase
endmodule