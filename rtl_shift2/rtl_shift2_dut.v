`timescale 1ns / 1ps
module shift2_dut
   (input wire aclk,
    input wire aresetn,
    input wire rx_enable,
    input wire rx_carryflag,
    input wire [1:0] rx_input,
    input wire [1:0] rx_coeff,
    output reg [1:0] tx_result,
    output reg tx_carryflag);

    shift2 d(.*); 
endmodule
