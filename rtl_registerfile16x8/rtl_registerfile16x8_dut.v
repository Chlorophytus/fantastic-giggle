`timescale 1ns / 1ps
module registerfile16x8_dut
   (input wire aclk,
    input wire aresetn,
    input wire rx_enable,
    input wire rx_write,
    input wire [2:0] rx_select,
    input wire [15:0] rx_data,
    output reg [15:0] tx_data);

    registerfile16x8 d(.*); 
endmodule
