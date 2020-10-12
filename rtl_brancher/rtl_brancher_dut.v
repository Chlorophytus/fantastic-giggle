`timescale 1ns / 1ps
module brancher_dut
   (input wire aclk,
    input wire aresetn,
    input wire rx_enable,
    input wire rx_write_branch,
    input wire rx_write_flags,
    input wire rx_strobe,
    input wire [3:0] rx_input_flags,
    input wire [3:0] rx_check_flags,
    input wire [15:0] rx_branch,
    output reg [15:0] tx_program_counter,
    output reg tx_ready);

    brancher d(.*); 
endmodule
