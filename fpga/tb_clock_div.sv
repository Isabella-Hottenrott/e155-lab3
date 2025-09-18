// Isabella Hottenrott
// tb_clock_div.sv
// ihottenrott@g.hmc.edu
// 19/9/2025
// Testbench for the clock divider to 60 Hz for E155 Lab 3

module tb_clock_div();
    logic clk, reset, test_int_osc, int_osc;
    logic [31:0] errors, vectornum;
    
    
    clock_div dut(.reset(reset), .clk(clk), .int_osc(int_osc));


    always
        begin
            clk=1; #1;
            clk=0; #1;
			vectornum = vectornum+1;
        end
        
    initial begin
            test_int_osc=0; errors=0; reset=0; #20; reset=1;
            #200000; test_int_osc=1; 
            #200000; test_int_osc=0;  
            #200000; test_int_osc=1;  
            #200000; test_int_osc=0; 
            #200000; test_int_osc=1; 
			#200000; test_int_osc=0;  
            #200000; test_int_osc=1;  
			#200000; test_int_osc=0;  
            #200000; test_int_osc=1;  
			#200000; test_int_osc=0; 
			#100; $display("completed with %d errors", errors);
            $stop;
        end
        



endmodule