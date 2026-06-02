module binary_counter #(
    parameter int unsigned p_COUNT_MAX = 99_999_999 
)(
    input logic     i_clk ,
    input logic     i_reset,
    output logic    [3:0]o_led_ctrl
);
    logic [26:0] r_counter      = 0;
    logic [3:0]  r_led_ctrl     = 0;

    assign o_led_ctrl   =  r_led_ctrl ;

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            r_counter       <=  0;
            r_led_ctrl      <=  0;
        end 
        else if (r_counter == p_COUNT_MAX) begin
            r_counter       <=  0;
            r_led_ctrl      <=  r_led_ctrl  + 1;
            if (r_led_ctrl == 4'd15 ) 
                $display("Counter Increment wrapped!");
        end
        else 
            r_counter   <= r_counter +1;
    end
endmodule
    
