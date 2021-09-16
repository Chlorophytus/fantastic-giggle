`default_nettype none
`timescale 1ns / 1ps
module memory_dut
   (input wire aclk,
    input wire aresetn,
    input wire rx_enable,
    input wire rx_write,
    input wire rx_strobe,
    input wire [11:0] rx_program_counter,
    input wire [7:0] rx_data,
    output reg [7:0] tx_data,
    output reg tx_ready);

    memory d(.*); 
endmodule
