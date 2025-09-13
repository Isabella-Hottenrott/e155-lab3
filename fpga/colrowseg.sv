module colrowseg(input logic [7:0] seg,
                output logic [3:0] digit);

always_comb
    case(digit)
        8'b00010001:  digit = 4'b10;
        8'b00100001:  digit = 4'b0;
        8'b01000001:  digit = 4'b11;
        8'b10000001:  digit = 4'b15;
        8'b00010010:  digit = 4'b7;
        8'b00100010:  digit = 4'b8;
        8'b01000010:  digit = 4'b9;
        8'b10000010:  digit = 4'b14;
        8'b00010100:  digit = 4'b4;
        8'b00100100:  digit = 4'b5;
        8'b01000100:  digit = 4'b6;
        8'b10000100:  digit = 4'b13;
        8'b00011000:  digit = 4'b1;
        8'b00101000:  digit = 4'b2;
        8'b01001000:  digit = 4'b3;
        8'b10001000:  digit = 4'b12;
        default:      digt = 4'b0;
    endcase
endmodule