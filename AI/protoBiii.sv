module keypad_top (
    input  logic        rst_n,         // External reset (active-low)
    input  logic [3:0]  row_in,        // Keypad row inputs (active-low)
    output logic [3:0]  col_out,       // Keypad column outputs (active-low)
    output logic [6:0]  seg_out,       // Seven-segment outputs (a-g)
    output logic [1:0]  digit_sel      // Digit select (active-low: [1]=left, [0]=right)
);

    // Internal oscillator for iCE40 UP5K (typically 48MHz)
    logic clk_internal;
    
    // iCE40 UP5K internal oscillator instance
    SB_HFOSC #(
        .CLKHF_DIV("0b10")  // Divide by 4: 48MHz -> 12MHz
    ) u_hfosc (
        .CLKHFPU(1'b1),     // Power up the oscillator
        .CLKHFEN(1'b1),     // Enable the oscillator
        .CLKHF(clk_internal)
    );

    // Clock divider for display multiplexing
    // Target ~1kHz refresh rate for each digit (2kHz total toggle rate)
    // 12MHz / 12000 = 1kHz per digit
    localparam DISPLAY_DIVIDER = 12000;
    localparam DISPLAY_COUNTER_WIDTH = $clog2(DISPLAY_DIVIDER);
    
    logic [DISPLAY_COUNTER_WIDTH-1:0] display_counter;
    logic display_tick;
    logic digit_select;  // 0 = right digit, 1 = left digit
    
    // Display refresh clock generation
    always_ff @(posedge clk_internal or negedge rst_n) begin
        if (!rst_n) begin
            display_counter <= '0;
            digit_select <= 1'b0;
        end else begin
            if (display_counter == DISPLAY_DIVIDER - 1) begin
                display_counter <= '0;
                digit_select <= ~digit_select;  // Toggle between digits
            end else begin
                display_counter <= display_counter + 1'b1;
            end
        end
    end
    
    assign display_tick = (display_counter == DISPLAY_DIVIDER - 1);

    // Keypad scanner signals
    logic [3:0] scanner_key_code;
    logic       scanner_key_valid;
    
    // One-shot registration signals
    logic [3:0] oneshot_captured_key;
    logic       oneshot_new_key_pulse;
    
    // Key history registers - store last two keys
    logic [3:0] most_recent_key;   // Rightmost digit
    logic [3:0] older_key;         // Leftmost digit
    
    // Display multiplexing signals
    logic [3:0] current_digit_code;
    logic [6:0] seg_decode_out;
    
    // Instantiate keypad scanner
    keypad_scanner u_scanner (
        .clk        (clk_internal),
        .rst_n      (rst_n),
        .row_in     (row_in),
        .col_out    (col_out),
        .key_code   (scanner_key_code),
        .key_valid  (scanner_key_valid)
    );
    
    // Instantiate one-shot key registration
    key_oneshot u_oneshot (
        .clk            (clk_internal),
        .rst_n          (rst_n),
        .key_code       (scanner_key_code),
        .key_valid      (scanner_key_valid),
        .captured_key   (oneshot_captured_key),
        .new_key_pulse  (oneshot_new_key_pulse)
    );
    
    // Key history management - shift register behavior
    always_ff @(posedge clk_internal or negedge rst_n) begin
        if (!rst_n) begin
            most_recent_key <= 4'h0;
            older_key <= 4'h0;
        end else if (oneshot_new_key_pulse) begin
            // Shift: older ← most_recent, most_recent ← new
            older_key <= most_recent_key;
            most_recent_key <= oneshot_captured_key;
        end
    end
    
    // Display multiplexing - select current digit to display
    always_comb begin
        if (digit_select) begin
            // Left digit (older key)
            current_digit_code = older_key;
        end else begin
            // Right digit (most recent key)
            current_digit_code = most_recent_key;
        end
    end
    
    // Instantiate seven-segment decoder
    sevenSegment u_seg_decoder (
        .hex_in     (current_digit_code),
        .seg_out    (seg_decode_out)
    );
    
    // Output assignments with synchronous drive
    always_ff @(posedge clk_internal or negedge rst_n) begin
        if (!rst_n) begin
            seg_out <= 7'b1111111;    // All segments off (assuming active-low)
            digit_sel <= 2'b11;       // Both digits off (active-low select)
        end else begin
            seg_out <= seg_decode_out;
            
            // Generate digit select signals (active-low)
            if (digit_select) begin
                digit_sel <= 2'b10;    // Select left digit (older key)
            end else begin
                digit_sel <= 2'b01;    // Select right digit (most recent key)
            end
        end
    end

endmodule

//-----------------------------------------------------------------------------
// Seven-segment decoder module (assumed to exist per requirements)
// This is a reference implementation - replace with your actual module
//-----------------------------------------------------------------------------
module sevenSegment (
    input  logic [3:0] hex_in,    // 4-bit hex input (0-F)
    output logic [6:0] seg_out    // 7-segment output (a-g, active-low)
);

    // Seven-segment encoding for hex digits (active-low segments)
    // Segment order: {g, f, e, d, c, b, a}
    always_comb begin
        case (hex_in)
            4'h0: seg_out = 7'b1000000; // 0
            4'h1: seg_out = 7'b1111001; // 1
            4'h2: seg_out = 7'b0100100; // 2
            4'h3: seg_out = 7'b0110000; // 3
            4'h4: seg_out = 7'b0011001; // 4
            4'h5: seg_out = 7'b0010010; // 5
            4'h6: seg_out = 7'b0000010; // 6
            4'h7: seg_out = 7'b1111000; // 7
            4'h8: seg_out = 7'b0000000; // 8
            4'h9: seg_out = 7'b0010000; // 9
            4'hA: seg_out = 7'b0001000; // A
            4'hB: seg_out = 7'b0000011; // b
            4'hC: seg_out = 7'b1000110; // C
            4'hD: seg_out = 7'b0100001; // d
            4'hE: seg_out = 7'b0000110; // E
            4'hF: seg_out = 7'b0001110; // F
            default: seg_out = 7'b1111111; // All off
        endcase
    end

endmodule