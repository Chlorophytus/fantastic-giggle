`default_nettype none
`timescale 1ns / 1ps
// 8-bit Leading One Detector
module lod8
   (input wire logic aclk,
    input wire logic aresetn,

    // Enable this block
    input wire logic rx_enable,
    
    // Data in and out
    input wire logic unsigned [7:0] rx_data,
    output logic unsigned [2:0] tx_data,
    
    // If anything is high set this flag
    output logic tx_hotflag);
    always_comb begin: lod8_leading_ones
        case ({rx_enable, rx_data}) inside
            9'b0????????: ;
            9'b11???????: {tx_hotflag, tx_data} = 4'b1111;
            9'b101??????: {tx_hotflag, tx_data} = 4'b1110;
            9'b1001?????: {tx_hotflag, tx_data} = 4'b1101;
            9'b10001????: {tx_hotflag, tx_data} = 4'b1100;
            9'b100001???: {tx_hotflag, tx_data} = 4'b1011;
            9'b1000001??: {tx_hotflag, tx_data} = 4'b1010;
            9'b10000001?: {tx_hotflag, tx_data} = 4'b1001;
            9'b100000001: {tx_hotflag, tx_data} = 4'b1000;
            9'b100000000: {tx_hotflag, tx_data} = 4'b0000;
        endcase
    end: lod8_leading_ones
endmodule: lod8
