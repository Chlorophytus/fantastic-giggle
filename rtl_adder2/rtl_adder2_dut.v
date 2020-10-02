`timescale 1ns / 1ps
module adder2_dut
   (input wire aclk,
    input wire aresetn,
    input wire rx_enable,
    input wire rx_carryflag,
    input wire [1:0] rx_addend0,
    input wire [1:0] rx_addend1,
    output reg [1:0] tx_sum,
    output reg tx_carryflag,
    output reg tx_zeroflag);

    adder2 d(.*); 
endmodule