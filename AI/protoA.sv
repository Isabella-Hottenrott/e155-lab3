// Top-level module for 4x4 keypad scanner with dual 7-segment display
// Target: Lattice iCE40 UP5K FPGA with ~20MHz internal oscillator
module keypad_top (
    input  logic        clk,        // ~20MHz internal oscillator
    input  logic        rst_n,      // Active-low reset
    
    // 4x4 Keypad interface (active-low)
    output logic [3:0]  col_n,      // Column outputs (active-low)
    input  logic [3:0]  row_n,      // Row inputs (active-low)
    
    // Dual 7-segment display interface
    output logic [6:0]  seg_n,      // Segment outputs (active-low: gfedcba)
    output logic [1:0]  dig_n       // Digit select (active-low)
);

    // Internal signals
    logic scan_clk;                 // ~150Hz scan clock
    logic display_clk;              // ~1kHz display multiplex clock
    logic [3:0] key_pressed;        // Current key value (0-F)
    logic key_valid;                // Key press strobe
    logic [3:0] digit1, digit0;     // Stored hex digits (digit1=older, digit0=newest)

    // Clock dividers
    clock_divider clk_div (
        .clk(clk),
        .rst_n(rst_n),
        .scan_clk(scan_clk),
        .display_clk(display_clk)
    );

    // Keypad scanner
    keypad_scanner scanner (
        .clk(scan_clk),
        .rst_n(rst_n),
        .col_n(col_n),
        .row_n(row_n),
        .key_pressed(key_pressed),
        .key_valid(key_valid)
    );

    // Key storage and 7-segment display controller
    display_controller display (
        .clk(display_clk),
        .rst_n(rst_n),
        .key_pressed(key_pressed),
        .key_valid(key_valid),
        .seg_n(seg_n),
        .dig_n(dig_n)
    );

endmodule

// Clock divider: generates scan clock (~150Hz) and display clock (~1kHz)
module clock_divider (
    input  logic clk,           // ~20MHz input
    input  logic rst_n,
    output logic scan_clk,      // ~150Hz for keypad scanning
    output logic display_clk    // ~1kHz for display multiplexing
);

    // Divide 20MHz by ~133k to get ~150Hz (2^17 = 131072)
    logic [16:0] scan_counter;
    // Divide 20MHz by ~20k to get ~1kHz (2^14 = 16384, use 2^15 for ~610Hz)
    logic [14:0] display_counter;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_counter <= '0;
            display_counter <= '0;
            scan_clk <= 1'b0;
            display_clk <= 1'b0;
        end else begin
            scan_counter <= scan_counter + 1;
            display_counter <= display_counter + 1;
            
            // Generate scan clock (~150Hz)
            if (scan_counter == 17'd0)
                scan_clk <= ~scan_clk;
                
            // Generate display clock (~1.2kHz)
            if (display_counter == 15'd0)
                display_clk <= ~display_clk;
        end
    end

endmodule

// 4x4 Keypad scanner with debounce-by-design
module keypad_scanner (
    input  logic        clk,            // Scan clock (~150Hz)
    input  logic        rst_n,
    output logic [3:0]  col_n,          // Column drives (active-low)
    input  logic [3:0]  row_n,          // Row sense (active-low)
    output logic [3:0]  key_pressed,    // Detected key value
    output logic        key_valid       // Key press strobe (single cycle)
);

    // FSM states
    typedef enum logic [2:0] {
        IDLE,       // No key pressed, scanning
        DEBOUNCE,   // Key detected, waiting for stable
        PRESSED,    // Key confirmed pressed
        WAIT_RELEASE // Waiting for key release
    } state_t;

    state_t state, next_state;
    
    // Scanning state
    logic [1:0] scan_col;           // Current column being scanned (0-3)
    logic [3:0] detected_key;       // Key value from current scan
    logic       key_detected;       // Key detection flag
    
    // Keypad layout: 
    // Col:  0   1   2   3
    // Row 0: 1  2   3   A
    // Row 1: 4  5   6   B  
    // Row 2: 7  8   9   C
    // Row 3: *  0   #   D
    // (* = E, # = F for hex)
    
    // Key value lookup table
    always_comb begin
        case ({scan_col, row_decode(row_n)})
            {2'd0, 2'd0}: detected_key = 4'h1;  // Col0, Row0
            {2'd0, 2'd1}: detected_key = 4'h4;  // Col0, Row1
            {2'd0, 2'd2}: detected_key = 4'h7;  // Col0, Row2
            {2'd0, 2'd3}: detected_key = 4'hE;  // Col0, Row3 (*)
            {2'd1, 2'd0}: detected_key = 4'h2;  // Col1, Row0
            {2'd1, 2'd1}: detected_key = 4'h5;  // Col1, Row1
            {2'd1, 2'd2}: detected_key = 4'h8;  // Col1, Row2
            {2'd1, 2'd3}: detected_key = 4'h0;  // Col1, Row3
            {2'd2, 2'd0}: detected_key = 4'h3;  // Col2, Row0
            {2'd2, 2'd1}: detected_key = 4'h6;  // Col2, Row1
            {2'd2, 2'd2}: detected_key = 4'h9;  // Col2, Row2
            {2'd2, 2'd3}: detected_key = 4'hF;  // Col2, Row3 (#)
            {2'd3, 2'd0}: detected_key = 4'hA;  // Col3, Row0
            {2'd3, 2'd1}: detected_key = 4'hB;  // Col3, Row1
            {2'd3, 2'd2}: detected_key = 4'hC;  // Col3, Row2
            {2'd3, 2'd3}: detected_key = 4'hD;  // Col3, Row3
            default:      detected_key = 4'h0;
        endcase
    end

    // Function to decode active-low row to binary
    function logic [1:0] row_decode(logic [3:0] rows);
        case (rows)
            4'b1110: row_decode = 2'd0;  // Row 0 active
            4'b1101: row_decode = 2'd1;  // Row 1 active
            4'b1011: row_decode = 2'd2;  // Row 2 active
            4'b0111: row_decode = 2'd3;  // Row 3 active
            default: row_decode = 2'd0;  // Default case
        endcase
    endfunction

    // Detect if any key is pressed
    assign key_detected = (row_n != 4'b1111);

    // Column scanning: one active-low column at a time
    always_comb begin
        col_n = 4'b1111;  // Default all high
        col_n[scan_col] = 1'b0;  // Drive current column low
    end

    // Scanning counter and FSM
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            scan_col <= 2'b00;
            key_pressed <= 4'h0;
            key_valid <= 1'b0;
        end else begin
            state <= next_state;
            key_valid <= 1'b0;  // Default: no valid key
            
            case (state)
                IDLE: begin
                    // Continuous scanning
                    scan_col <= scan_col + 1;
                    if (key_detected) begin
                        key_pressed <= detected_key;
                    end
                end
                
                DEBOUNCE: begin
                    // Hold current column for debounce
                    if (!key_detected) begin
                        // Key released during debounce, back to scanning
                        scan_col <= scan_col + 1;
                    end
                end
                
                PRESSED: begin
                    // Key confirmed, generate strobe
                    key_valid <= 1'b1;
                end
                
                WAIT_RELEASE: begin
                    // Continue scanning but don't register new keys
                    scan_col <= scan_col + 1;
                end
            endcase
        end
    end

    // FSM next state logic
    always_comb begin
        next_state = state;
        
        case (state)
            IDLE: begin
                if (key_detected)
                    next_state = DEBOUNCE;
            end
            
            DEBOUNCE: begin
                if (key_detected)
                    next_state = PRESSED;
                else
                    next_state = IDLE;
            end
            
            PRESSED: begin
                next_state = WAIT_RELEASE;
            end
            
            WAIT_RELEASE: begin
                if (!key_detected)
                    next_state = IDLE;
            end
        endcase
    end

endmodule

// Display controller: manages hex digit storage and 7-segment multiplexing
module display_controller (
    input  logic        clk,            // Display multiplex clock (~1kHz)
    input  logic        rst_n,
    input  logic [3:0]  key_pressed,    // New key value
    input  logic        key_valid,      // Key press strobe
    output logic [6:0]  seg_n,          // 7-segment outputs (active-low)
    output logic [1:0]  dig_n           // Digit enables (active-low)
);

    // Stored digits (digit1 = older, digit0 = newest)
    logic [3:0] digit1, digit0;
    
    // Display multiplexing
    logic display_select;               // 0=digit0, 1=digit1
    logic [3:0] current_digit;
    
    // Update stored digits on valid key press
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            digit1 <= 4'h0;
            digit0 <= 4'h0;
        end else if (key_valid) begin
            digit1 <= digit0;           // Shift older digit
            digit0 <= key_pressed;      // Store new digit
        end
    end

    // Display multiplexing: alternate between digits
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            display_select <= 1'b0;
        end else begin
            display_select <= ~display_select;
        end
    end

    // Select current digit and enable appropriate display
    always_comb begin
        if (display_select) begin
            current_digit = digit1;
            dig_n = 2'b01;              // Enable digit 1 (active-low)
        end else begin
            current_digit = digit0;
            dig_n = 2'b10;              // Enable digit 0 (active-low)
        end
    end

    // 7-segment decoder (active-low outputs)
    // Segments: gfedcba (bit 6 to 0)
    always_comb begin
        case (current_digit)
            4'h0: seg_n = 7'b1000000;  // 0
            4'h1: seg_n = 7'b1111001;  // 1
            4'h2: seg_n = 7'b0100100;  // 2
            4'h3: seg_n = 7'b0110000;  // 3
            4'h4: seg_n = 7'b0011001;  // 4
            4'h5: seg_n = 7'b0010010;  // 5
            4'h6: seg_n = 7'b0000010;  // 6
            4'h7: seg_n = 7'b1111000;  // 7
            4'h8: seg_n = 7'b0000000;  // 8
            4'h9: seg_n = 7'b0010000;  // 9
            4'hA: seg_n = 7'b0001000;  // A
            4'hB: seg_n = 7'b0000011;  // b
            4'hC: seg_n = 7'b1000110;  // C
            4'hD: seg_n = 7'b0100001;  // d
            4'hE: seg_n = 7'b0000110;  // E
            4'hF: seg_n = 7'b0001110;  // F
        endcase
    end

endmodule