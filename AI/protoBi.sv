module key_oneshot (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [3:0]  key_code,     // 4-bit key code from keypad scanner
    input  logic        key_valid,    // High when a valid key is detected
    output logic [3:0]  captured_key, // Registered key code
    output logic        new_key_pulse // Single-cycle pulse for new key
);

    // FSM States
    typedef enum logic [1:0] {
        IDLE      = 2'b00,  // No key pressed, ready for new key
        DEBOUNCE  = 2'b01,  // Key detected, debouncing
        HOLD      = 2'b10,  // Key registered, waiting for release
        RELEASE   = 2'b11   // Key released, debouncing release
    } state_t;

    state_t current_state, next_state;

    // Debounce counter - adjust DEBOUNCE_CYCLES for your clock frequency
    // For 12MHz clock, 16 cycles = ~1.3us debounce time
    localparam DEBOUNCE_CYCLES = 16;
    localparam COUNTER_WIDTH = $clog2(DEBOUNCE_CYCLES);
    
    logic [COUNTER_WIDTH-1:0] debounce_counter;
    logic counter_expired;
    logic [3:0] key_reg;
    
    assign counter_expired = (debounce_counter == DEBOUNCE_CYCLES - 1);

    // Sequential logic - state register and counter
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            debounce_counter <= '0;
            key_reg <= '0;
        end else begin
            current_state <= next_state;
            
            // Counter management
            if (current_state != next_state) begin
                // Reset counter on state transitions
                debounce_counter <= '0;
            end else if (!counter_expired) begin
                // Increment counter while in debounce states
                debounce_counter <= debounce_counter + 1'b1;
            end
            
            // Capture key code when transitioning to DEBOUNCE state
            if (current_state == IDLE && next_state == DEBOUNCE) begin
                key_reg <= key_code;
            end
        end
    end

    // Combinational logic - next state and outputs
    always_comb begin
        next_state = current_state;
        new_key_pulse = 1'b0;
        captured_key = key_reg;
        
        case (current_state)
            IDLE: begin
                if (key_valid) begin
                    next_state = DEBOUNCE;
                end
            end
            
            DEBOUNCE: begin
                if (!key_valid) begin
                    // Key released during debounce - false trigger
                    next_state = IDLE;
                end else if (counter_expired) begin
                    // Debounce complete, key is stable
                    next_state = HOLD;
                    new_key_pulse = 1'b1;  // Generate one-shot pulse
                end
            end
            
            HOLD: begin
                if (!key_valid) begin
                    next_state = RELEASE;
                end
            end
            
            RELEASE: begin
                if (key_valid) begin
                    // Key pressed again during release debounce
                    next_state = HOLD;
                end else if (counter_expired) begin
                    // Release debounce complete
                    next_state = IDLE;
                end
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule