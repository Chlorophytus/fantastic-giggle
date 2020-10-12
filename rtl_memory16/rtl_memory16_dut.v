`timescale 1ns / 1ps
module memory16_dut
   (input wire aclk,
    input wire aresetn,
    input wire rx_enable,
    input wire rx_write,
    input wire rx_strobe,
    input wire [15:0] rx_program_counter,
    input wire [7:0] rx_data,
    output reg [7:0] tx_data,
    output reg tx_ready);

    memory16 d(.*); 
endmodule
