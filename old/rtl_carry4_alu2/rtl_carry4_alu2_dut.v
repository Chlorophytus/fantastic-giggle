`default_nettype none
`timescale 1ns / 1ps
module carry4_alu2_dut
   (input wire aclk,
    input wire aresetn,
    input wire rx_enable,
    input wire rx_write,
    input wire rx_strobe,
    input wire rx_carryflag,
    input wire [2:0] rx_opcode,
    input wire [7:0] rx_operand0,
    input wire [7:0] rx_operand1,
    output reg [7:0] tx_result,
    output reg tx_carryflag,
    output reg tx_zeroflag,
    output reg tx_signflag,
    output reg tx_ready);

    carry4_alu2 d(.*); 
endmodule
