// Isabella Hottenrott
// tb_anodeselect.sv
// ihottenrott@g.hmc.edu
// 9/9/2025
// Testbench for the Anodeselect module for E155 Lab 2


module tb_anodeselect();
    logic int_osc, reset, clk;
    logic seg0anode, seg1anode;
    logic [6:0] segment0, segment1, segmentOut, segmentOutexp;
    logic anodeZeroOut, anodeOneOut, anodeZeroOutexp, anodeOneOutexp;
    logic [4:0] errors, vectornum;
    
    anodeselect dut(.int_osc(int_osc), .reset(reset), .seg0anode(seg0anode), .seg1anode(seg1anode),
    .segment0(segment0), .segment1(segment1), .segmentOut(segmentOut), .anodeZeroOut(anodeZeroOut), .anodeOneOut(anodeOneOut));


    always
        begin
            clk=1; #5;
            clk=0; #5;
        end
        
    initial begin
            vectornum=5'd1; errors=0; reset=0; #22; reset=1;
            vectornum=5'd2; int_osc=1'b1; seg0anode=1'b0; seg1anode=1'b0; segment0=7'b0000000; segment1=7'b1111111; segmentOutexp=7'b0000000; anodeZeroOutexp=0; anodeOneOutexp=1; #10;
            vectornum=5'd3; int_osc=1'b0; seg0anode=1'b0; seg1anode=1'b0; segment0=7'b0000000; segment1=7'b1111111; segmentOutexp=7'b1111111; anodeZeroOutexp=1; anodeOneOutexp=0; #10;

            vectornum=5'd4; int_osc=1'b1; seg0anode=1'b1; seg1anode=1'b0; segment0=7'b0001111; segment1=7'b1110000; segmentOutexp=7'b0001111; anodeZeroOutexp=1; anodeOneOutexp=1; #10;
            vectornum=5'd5; int_osc=1'b0; seg0anode=1'b0; seg1anode=1'b1; segment0=7'b0001111; segment1=7'b1110000; segmentOutexp=7'b1110000; anodeZeroOutexp=1; anodeOneOutexp=1; #10;

            vectornum=5'd6; int_osc=1'b1; seg0anode=1'b1; seg1anode=1'b1; segment0=7'b0001111; segment1=7'b1110000; segmentOutexp=7'b0001111; anodeZeroOutexp=1; anodeOneOutexp=1; #10;
            vectornum=5'd7; int_osc=1'b0; seg0anode=1'b1; seg1anode=1'b1; segment0=7'b0001111; segment1=7'b1110000; segmentOutexp=7'b1110000; anodeZeroOutexp=1; anodeOneOutexp=1; #10;

            vectornum=5'd8; int_osc=1'b1; seg0anode=1'b0; seg1anode=1'b0; segment0=7'b0001111; segment1=7'b1110000; segmentOutexp=7'b0001111; anodeZeroOutexp=0; anodeOneOutexp=1; #10;
            vectornum=5'd9; int_osc=1'b0; seg0anode=1'b0; seg1anode=1'b0; segment0=7'b0001111; segment1=7'b1110000; segmentOutexp=7'b1110000; anodeZeroOutexp=1; anodeOneOutexp=0; #10;
            vectornum=5'd10; int_osc=1'b1; seg0anode=1'b0; seg1anode=1'b0; segment0=7'b0001111; segment1=7'b1110000; segmentOutexp=7'b0001111; anodeZeroOutexp=0; anodeOneOutexp=1; #10;
            vectornum=5'd11; int_osc=1'b0; seg0anode=1'b0; seg1anode=1'b0; segment0=7'b0001111; segment1=7'b1110000; segmentOutexp=7'b1110000; anodeZeroOutexp=1; anodeOneOutexp=0; #10;
            $display("total errors =", errors);
            #10
            $stop;
        end
        

    always @(negedge clk)
        if (reset) begin
            if ((segmentOut !== segmentOutexp) || (anodeZeroOut !== anodeZeroOutexp) || (anodeOneOut !== anodeOneOutexp)) begin
                $display(" Error on test = %d ", vectornum);
                errors = errors + 1;
            end

end 
endmodule
