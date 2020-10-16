`default_nettype none
`timescale 1ns / 1ps
module barrelshifter16_dut
   (input wire aclk,
    input wire aresetn,
    input wire rx_enable,
    input wire rx_write,
    input wire [1:0] rx_direction,
    input wire [15:0] rx_input,
    input wire [2:0] rx_coeff,
    output reg [15:0] tx_shift);

    barrelshifter16 d(.*); 
endmodule
