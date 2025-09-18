// Isabella Hottenrott
// colrowseg.sv
// ihottenrott@g.hmc.edu
// 19/9/2025
// Module containing encoding for column and row entries 
// into the segment module

module colrowseg(input logic [8:0] col_row_comb,
                output logic [3:0] digit,
				output logic anode);
logic [7:0] intermediate;
assign intermediate = col_row_comb[7:0];


always_comb
    case(intermediate)
        8'b00010001:  digit = 4'b1010;
        8'b00100001:  digit = 4'b0000;
        8'b01000001:  digit = 4'b1011;
        8'b10000001:  digit = 4'b1111;
        8'b00010010:  digit = 4'b0111;
        8'b00100010:  digit = 4'b1000;
        8'b01000010:  digit = 4'b1001;
        8'b10000010:  digit = 4'b1110;
        8'b00010100:  digit = 4'b0100;
        8'b00100100:  digit = 4'b0101;
        8'b01000100:  digit = 4'b0110;
        8'b10000100:  digit = 4'b1101;
        8'b00011000:  digit = 4'b0001;
        8'b00101000:  digit = 4'b0010;
        8'b01001000:  digit = 4'b0011;
        8'b10001000:  digit = 4'b1100;
        default:      digit = 4'b0000;
    endcase
	
assign anode = col_row_comb[8];
endmodule