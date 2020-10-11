`timescale 1ns / 1ps
module lod4_dut
   (input wire aclk,
    input wire aresetn,
    input wire rx_enable,
    input wire [3:0] rx_data,
    output reg [1:0] tx_data,
    output reg tx_hotflag);

    lod4 d(.*); 
endmodule
