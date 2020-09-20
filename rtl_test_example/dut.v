`timescale 1ns / 1ps
module dut
   (input wire aclk,
    input wire aresetn,
    input wire enable,
    output reg blink);

    blinky d(.*); 
endmodule
