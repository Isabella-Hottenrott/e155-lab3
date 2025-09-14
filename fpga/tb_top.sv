// Isabella Hottenrott
// tb_lab3_ih.sv
// ihottenrott@g.hmc.edu
// 13/9/2025
// Testbench for Top level module of E155 Lab 3

module tb_top();
    logic clk, reset;
    logic [3:0] cols, inputrows;
    logic [6:0] segment0, segment1;
    logic seg0anode, seg1anode;
    logic [9:0] errors;
    logic [4:0] vectornum;


    
    lab3_ih dut(.clk(clk), .reset(reset), .inputrows(inputrows), .cols(cols), .segment0(segment0), .segment1(segment1), .seg0anode(seg0anode), 
                .seg1anode(seg1anode));


    always
        begin
            clk=1; #1;
            clk=0; #1;
        end
        
    initial begin
			reset = 1; #20; reset = 0;
			#200;
			// SW1 = 0000, SW2 = 1111, should illuminate anodeTwo
			wait(cols == 4'b0001);
            #1; inputrows = 4'b0100; #1000; inputrows = 4'b0000; #500000;
			wait(cols == 4'b0001);
			inputrows = 4'b1000; #500; inputrows = 4'b0000; #50000;

            $stop;
        end
        
	always @(posedge clk)
		if (reset) begin
			vectornum=5'd0; inputrows=4'b0000; 
			end
			

 
endmodule