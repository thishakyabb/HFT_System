`timescale 1ns / 1ps

module tb_binary_counter ();
    
    parameter int unsigned p_COUNT_MAX      =  100;
    parameter int          p_CLK_PERIOD     =  10;    //100 Mhz

    logic       r_tb_clk      =  1'b0;
    logic       r_tb_reset    =  1'b0;
    logic  [3:0]r_tb_led_ctrl =  4'b0;

    logic  [26:0]r_temp_counter = 27'b0;

    //DUT
    binary_counter #(
           .p_COUNT_MAX(p_COUNT_MAX)
        )DUT(
            .i_clk(r_tb_clk),
            .i_reset(r_tb_reset),
            .o_led_ctrl(r_tb_led_ctrl)
        );

    //CLOCK GENERATION
    always (#p_CLK_PERIOD/2)  r_tb_clk     =   ~r_tb_clk ;
    
    //Testing
    initial begin 
        r_tb_reset        = 1'b0;

        $display ("=====    Test Bench Starting  ====");

    //Test 1 = Checking the initial stater
        #100ns;
        assert(r_tb_led_ctrl ==  4'b0)
            $display("PASSED : Initial State Set Properly");
        else 
            $display ("FAILED :  LED state is incorrect. tb_led_ctrl = %0d at the time %0t",r_tb_led_ctrl,$time);
    
    //Test 2 = Checking the counter incrementation
        #3ns;
        r_temp_counter  =   DUT.r_counter;
        #10ns;
        assert(DUT.r_counter == r_temp_counter + 1) 
            $display ("PASSED : Counter is incrementing");
        else 
            $display ("FAILED :  Counter is not incrementing");

    // Test 3 =  Checking the reset
        #10ns;
        r_tb_reset        =   1'b1;
        #30ns;
        r_tb_reset        =   1'b0;
        assert (DUT.r_counter == 27'b0 && r_tb_led_ctrl == 4'b0)
            $display ("PASSED :  Reset test pass");
        else 
            $display ("FAILED  : Reset test failed");

    // Test 4 = LED control counter testing
        #1500ns;
        assert (r_tb_led_ctrl != 4'b0)
            $display ("PASSED   :  LED control counter working");
        else 
            $display ("FAILED   :   LED control counter failing");

        $finish;
    end
    
    //Reset continuity testing

    always_ff @(posedge r_tb_clk) begin
        if (r_tb_reset == 1'b1) begin 
            assert(r_tb_led_ctrl == 4'b0)
            else
                $error ("ERROR :  LED status is = %0d at time = %0t",r_tb_led_ctrl,$time);
        end

    end



endmodule