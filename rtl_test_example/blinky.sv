`timescale 1ns / 1ps
module blinky
   (input wire logic aresetn,
    input wire logic aclk,
    input wire logic enable,
    output logic blink);
    logic r_blink = 1'b0;
    always_ff@(posedge aclk or negedge aresetn) begin
        if(~aresetn)
            r_blink <= 1'b0;
        else if(enable)
            r_blink <= ~r_blink;
    end
    assign blink = r_blink;
endmodule: blinky
