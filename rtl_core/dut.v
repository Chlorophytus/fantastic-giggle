`timescale 1ns / 1ps
module dut
   (input wire aclk,
    input wire aresetn,
    input wire enable,
    input wire cjmp,
    input wire rjmp,
    input wire [7:0] rx_count,
    input wire [7:0] rx_realm,
    output reg [15:0] tx_addr);

    program_counter d(.*); 
endmodule