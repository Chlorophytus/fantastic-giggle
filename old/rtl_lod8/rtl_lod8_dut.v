`default_nettype none
`timescale 1ns / 1ps
module lod8_dut
   (input wire aclk,
    input wire aresetn,
    input wire rx_enable,
    input wire [7:0] rx_data,
    output reg [2:0] tx_data,
    output reg tx_hotflag);

    lod8 d(.*); 
endmodule
