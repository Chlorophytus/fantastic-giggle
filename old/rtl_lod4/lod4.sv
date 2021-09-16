`default_nettype none
`timescale 1ns / 1ps
// 4-bit Leading One Detector
module lod4
   (input wire logic aclk,
    input wire logic aresetn,

    // Enable this block
    input wire logic rx_enable,
    
    // Data in and out
    input wire logic unsigned [3:0] rx_data,
    output logic unsigned [1:0] tx_data,
    
    // If anything is high set this flag
    output logic tx_hotflag);
    always_comb begin: lod4_leading_ones
        case ({rx_enable, rx_data}) inside
            5'b0????: ;
            5'b11???: {tx_hotflag, tx_data} = 3'b111;
            5'b101??: {tx_hotflag, tx_data} = 3'b110;
            5'b1001?: {tx_hotflag, tx_data} = 3'b101;
            5'b10001: {tx_hotflag, tx_data} = 3'b100;
            5'b10000: {tx_hotflag, tx_data} = 3'b000;
        endcase
    end: lod4_leading_ones
endmodule: lod4
