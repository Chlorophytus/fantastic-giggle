`timescale 1ns / 1ps
module decoder
   (input wire logic aresetn,
    input wire logic aclk,
    input wire logic enable,
    input wire logic unsigned [7:0] rx_data,
    output logic do_rjmp,
    output logic do_cjmp);
endmodule: decoder
