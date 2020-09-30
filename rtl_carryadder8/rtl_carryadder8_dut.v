`timescale 1ns / 1ps
module carryadder8_dut
   (input wire aclk,
    input wire aresetn,
    input wire rx_enable,
    input wire rx_write,
    input wire rx_strobe,
    input wire rx_carryflag,
    input wire [7:0] rx_addend0,
    input wire [7:0] rx_addend1,
    output reg [7:0] tx_sum,
    output reg tx_carryflag,
    output reg tx_zeroflag,
    output reg tx_ready);

    carryadder8 d(.*); 
endmodule
