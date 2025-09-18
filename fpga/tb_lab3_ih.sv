// Isabella Hottenrott
// tb_lab3_ih.sv
// ihottenrott@g.hmc.edu
// 13/9/2025
// Testbench for Top level module of E155 Lab 3

module tb_lab3_ih();
    logic clk, reset, int_osc;
    logic [3:0] cols, inputrows, intermed;
    logic [6:0] segmentOut;
    logic anodeZeroOut, anodeOneOut;
    logic [9:0] errors;
    logic [4:0] vectornum;
    logic [15:0] clockticks;
	
	assign int_osc = dut.int_osc;
                
    always
        begin
            clk=1; #1;
            clk=0; #1;
        end
        
    lab3_ih dut(.clk(clk), .reset(reset), .inputrows(inputrows), .cols(cols), .segmentOut(segmentOut), .anodeZeroOut(anodeZeroOut), .anodeOneOut(anodeOneOut));
       
    initial begin
            reset = 0; #1; reset = 1; #1; reset =0; #15; reset=1; vectornum = 5'b0; inputrows = 4'b0; #6
            wait(int_osc == 0); assert((~int_osc) && (segmentOut == 7'b0000001) && (anodeZeroOut == 1)) else $display("error on vector %d seg0", vectornum);
            wait(int_osc == 1); assert(int_osc && (segmentOut == 7'b0000001) && (anodeOneOut == 1)) else $display("error on vector %d seg1", vectornum);
            #100

            wait(cols == 4'b0010);
			vectornum = 5'b00001;
            inputrows = 4'b0100; #1500000; inputrows = 4'b0000; #800;
            // col 1, row 2 = 5 = segment0. segment1 remains nothing.
            wait(int_osc == 1); assert((segmentOut == 7'b010_0100) && (anodeZeroOut == 0)) else $display("error on vector %d seg0", vectornum);
            wait(int_osc == 0); assert((segmentOut == 7'b0000001) && (anodeOneOut == 1)) else $display("error on vector %d seg1", vectornum);
            
            #100
            wait(cols == 4'b0001);
			vectornum = 5'b00010;
            inputrows = 4'b1000; #1500000; inputrows = 4'b0000; #800;
            // col 0, row 3 = 1 = segment0. segment1 =5.
            wait(int_osc == 1); assert((segmentOut == 7'b100_1111) && (anodeZeroOut == 0)) else $display("error on vector %d seg0", vectornum);
            wait(int_osc == 0); assert((segmentOut == 7'b010_0100) && (anodeOneOut == 0)) else $display("error on vector %d seg1", vectornum);

            #100
            wait(cols == 4'b1000);
            inputrows = 4'b0100; vectornum = 5'b00011; #1500000; inputrows = 4'b0000; #800;
            // col 3, row 2 = d = segment0. segment1 =1.
            wait(int_osc == 1); assert((segmentOut == 7'b100_0010) && (anodeZeroOut == 0)) else $display("error on vector %d seg0", vectornum);
            wait(int_osc == 0); assert((segmentOut == 7'b100_1111) && (anodeOneOut == 0)) else $display("error on vector %d seg1", vectornum);

            #100
            wait(cols == 4'b1000);
            inputrows = 4'b0100; vectornum = 5'b00100; #1500000; inputrows = 4'b0000; #800;
            // col 3, row 2 = d = segment0. segment1 =d // double press
            wait(int_osc == 1); assert((segmentOut == 7'b100_0010) && (anodeZeroOut == 0)) else $display("error on vector %d seg0", vectornum);
            wait(int_osc == 0); assert((segmentOut == 7'b100_0010) && (anodeOneOut == 0)) else $display("error on vector %d seg1", vectornum);
            

            #100
            wait(cols == 4'b0001);
            inputrows = 4'b0100; vectornum = 5'b00101; #1500000; inputrows = 4'b1001; #400; inputrows = 4'b0000; #800;
            // col 0, row 2 = 4 = segment0. segment1 =d. Checking the additional row input doesnt change anything
            wait(int_osc == 1); assert((segmentOut == 7'b100_1100) && (anodeZeroOut == 0)) else $display("error on vector %d seg0", vectornum);
            wait(int_osc == 0); assert((segmentOut == 7'b100_0010) && (anodeOneOut == 0)) else $display("error on vector %d seg1", vectornum);


            #100
            // checking columns dont change mid press
            wait(cols == 4'b1000);
            inputrows = 4'b1000; vectornum = 5'b00110; #1000;
            assert(cols == 4'b1000) else $display("error on vector %d. Cols = %b", vectornum, intermed);
            #300000; vectornum = 5'b00111; inputrows = 4'b0000; #1500000;
			
			#



            $stop;

            // 
        end
        
            

 
endmodule
