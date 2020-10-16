`default_nettype none
`timescale 1ns / 1ps
module alu2_dut
   (input wire aclk,
    input wire aresetn,
    input wire rx_carryflag,
    input wire [4:0] rx_what_op,
    input wire [1:0] rx_operand0,
    input wire [1:0] rx_operand1,
    output reg [1:0] tx_result,
    output reg tx_carryflag,
    output reg tx_zeroflag,
    output reg tx_signflag);

    alu2 d(.*); 
endmodule
