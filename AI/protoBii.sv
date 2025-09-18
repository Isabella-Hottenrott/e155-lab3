module keypad_scanner (
    input  logic        clk,           // System clock
    input  logic        rst_n,         // Active-low reset
    input  logic [3:0]  row_in,        // Row inputs (active-low when pressed)
    output logic [3:0]  col_out,       // Column outputs (active-low, one at a time)
    output logic [3:0]  key_code,      // 4-bit key code (0-F hex)
    output logic        key_valid      // High when a key is currently pressed
);

    // Scan timing - divide clock for reasonable scan rate
    // For 12MHz clock: 12MHz / 4096 = ~2.9kHz scan rate per column
    // Full 4-column scan = ~732Hz, well above typical keypad response
    localparam SCAN_DIVIDER = 4096;
    localparam COUNTER_WIDTH = $clog2(SCAN_DIVIDER);
    
    logic [COUNTER_WIDTH-1:0] scan_counter;
    logic scan_tick;
    
    // Column scanning state
    typedef enum logic [1:0] {
        COL0 = 2'b00,
        COL1 = 2'b01,
        COL2 = 2'b10,
        COL3 = 2'b11
    } col_state_t;
    
    col_state_t current_col, next_col;
    
    // Key detection and encoding
    logic [3:0] row_sync;        // Synchronized row inputs
    logic [3:0] current_key;     // Current detected key code
    logic       key_detected;    // Any key detected this scan cycle
    logic [3:0] stable_key;      // Latched stable key code
    logic       stable_valid;    // Stable key valid flag
    
    // Generate scan tick for column advancement
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_counter <= '0;
        end else begin
            scan_counter <= scan_counter + 1'b1;
        end
    end
    
    assign scan_tick = (scan_counter == SCAN_DIVIDER - 1);
    
    // Column state machine - advances on scan_tick
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_col <= COL0;
        end else if (scan_tick) begin
            current_col <= next_col;
        end
    end
    
    // Next column logic
    always_comb begin
        case (current_col)
            COL0:    next_col = COL1;
            COL1:    next_col = COL2;
            COL2:    next_col = COL3;
            COL3:    next_col = COL0;
            default: next_col = COL0;
        endcase
    end
    
    // Generate column outputs (active-low, one at a time)
    always_comb begin
        col_out = 4'b1111;  // Default all high (inactive)
        case (current_col)
            COL0: col_out = 4'b1110;  // Column 0 active
            COL1: col_out = 4'b1101;  // Column 1 active
            COL2: col_out = 4'b1011;  // Column 2 active
            COL3: col_out = 4'b0111;  // Column 3 active
        endcase
    end
    
    // Synchronize row inputs (double-flop for metastability)
    logic [3:0] row_meta;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            row_meta <= 4'b1111;
            row_sync <= 4'b1111;
        end else begin
            row_meta <= row_in;
            row_sync <= row_meta;
        end
    end
    
    // Key detection and encoding
    // Standard 4x4 keypad layout:
    //     Col0  Col1  Col2  Col3
    // Row0  1    2    3    A
    // Row1  4    5    6    B  
    // Row2  7    8    9    C
    // Row3  *    0    #    D
    //
    // Hex encoding: 1,2,3,A,4,5,6,B,7,8,9,C,*,0,#,D = 1,2,3,A,4,5,6,B,7,8,9,C,E,0,F,D
    always_comb begin
        key_detected = 1'b0;
        current_key = 4'h0;
        
        // Check each row for active (low) signal
        case (current_col)
            COL0: begin
                case (row_sync)
                    4'b1110: begin current_key = 4'h1; key_detected = 1'b1; end  // Row 0: Key '1'
                    4'b1101: begin current_key = 4'h4; key_detected = 1'b1; end  // Row 1: Key '4'
                    4'b1011: begin current_key = 4'h7; key_detected = 1'b1; end  // Row 2: Key '7'
                    4'b0111: begin current_key = 4'hE; key_detected = 1'b1; end  // Row 3: Key '*' (E)
                    default: begin current_key = 4'h0; key_detected = 1'b0; end
                endcase
            end
            COL1: begin
                case (row_sync)
                    4'b1110: begin current_key = 4'h2; key_detected = 1'b1; end  // Row 0: Key '2'
                    4'b1101: begin current_key = 4'h5; key_detected = 1'b1; end  // Row 1: Key '5'
                    4'b1011: begin current_key = 4'h8; key_detected = 1'b1; end  // Row 2: Key '8'
                    4'b0111: begin current_key = 4'h0; key_detected = 1'b1; end  // Row 3: Key '0'
                    default: begin current_key = 4'h0; key_detected = 1'b0; end
                endcase
            end
            COL2: begin
                case (row_sync)
                    4'b1110: begin current_key = 4'h3; key_detected = 1'b1; end  // Row 0: Key '3'
                    4'b1101: begin current_key = 4'h6; key_detected = 1'b1; end  // Row 1: Key '6'
                    4'b1011: begin current_key = 4'h9; key_detected = 1'b1; end  // Row 2: Key '9'
                    4'b0111: begin current_key = 4'hF; key_detected = 1'b1; end  // Row 3: Key '#' (F)
                    default: begin current_key = 4'h0; key_detected = 1'b0; end
                endcase
            end
            COL3: begin
                case (row_sync)
                    4'b1110: begin current_key = 4'hA; key_detected = 1'b1; end  // Row 0: Key 'A'
                    4'b1101: begin current_key = 4'hB; key_detected = 1'b1; end  // Row 1: Key 'B'
                    4'b1011: begin current_key = 4'hC; key_detected = 1'b1; end  // Row 2: Key 'C'
                    4'b0111: begin current_key = 4'hD; key_detected = 1'b1; end  // Row 3: Key 'D'
                    default: begin current_key = 4'h0; key_detected = 1'b0; end
                endcase
            end
            default: begin
                current_key = 4'h0;
                key_detected = 1'b0;
            end
        endcase
    end
    
    // Latch stable key code - hold while any key is pressed
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stable_key <= 4'h0;
            stable_valid <= 1'b0;
        end else begin
            if (key_detected) begin
                // Key detected - latch it and mark valid
                stable_key <= current_key;
                stable_valid <= 1'b1;
            end else if (!stable_valid) begin
                // No key detected and none was previously latched
                stable_key <= 4'h0;
            end else begin
                // No key detected but one was latched - check if it's still pressed
                // We need to wait for a complete scan cycle to confirm key release
                // For now, we'll check if no keys are detected across multiple scans
                if (scan_tick && current_col == COL3) begin
                    // Completed full scan cycle with no keys - clear the latch
                    stable_valid <= 1'b0;
                    stable_key <= 4'h0;
                end
            end
        end
    end
    
    // Output assignments
    assign key_code = stable_key;
    assign key_valid = stable_valid;

endmodule