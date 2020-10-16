`default_nettype none
`timescale 1ns / 1ps
// 16-bit barrel shifter
module barrelshifter16
   (input wire logic aclk,
    input wire logic aresetn,

    // Enable this block
    input wire logic rx_enable,

    // Write to registers
    input wire logic rx_write,

    // 2'b10 = Lshift
    // 2'b01 = Rshift
    // 2'b11 / 2'b00 = do nothing
    input wire logic unsigned [1:0] rx_direction,

    // Shift this vector
    input wire logic unsigned [15:0] rx_input,

    // Shift `rx_input` by this vector
    input wire logic unsigned [2:0] rx_coeff,

    // Shifted `rx_input`
    output logic unsigned [15:0] tx_shift);
    // Good practice: capture enable/write inputs
    logic enable;
    always_ff@(posedge aclk or negedge aresetn) begin: barrelshifter16_enable_sync
        if(~aresetn)
            enable <= 1'b0;
        else
            enable <= rx_enable;
    end: barrelshifter16_enable_sync

    logic write;
    always_ff@(posedge aclk or negedge aresetn) begin: barrelshifter16_write_sync
        if(~aresetn)
            write <= 1'b0;
        else if(enable)
            write <= rx_write;
    end: barrelshifter16_write_sync

    // register stuff
    logic unsigned [15:0] in;
    logic unsigned [2:0] coeff;
    logic unsigned [15:0] shift;
    logic unsigned [1:0] direction;
    always_ff@(posedge aclk or negedge aresetn) begin: barrelshifter16_hold_input
        if(~aresetn)
            in <= 16'h0000;
        else if(enable & write)
            in <= rx_input;
    end: barrelshifter16_hold_input
    always_ff@(posedge aclk or negedge aresetn) begin: barrelshifter16_hold_coeff
        if(~aresetn)
            coeff <= 3'b000;
        else if(enable & write)
            coeff <= rx_coeff;
    end: barrelshifter16_hold_coeff
    always_ff@(posedge aclk or negedge aresetn) begin: barrelshifter16_hold_direction
        if(~aresetn)
            direction <= 2'b00;
        else if(enable & write)
            direction <= rx_direction;
    end: barrelshifter16_hold_direction

    logic unsigned [7:0] oh_shift;
    always_comb begin: barrelshifter16_onehot
        case({enable & ~write, coeff}) inside
            4'b0???: oh_shift = 8'h00;

            4'b1000: oh_shift = 8'h01;
            4'b1001: oh_shift = 8'h02;
            4'b1010: oh_shift = 8'h04;
            4'b1011: oh_shift = 8'h08;
            4'b1100: oh_shift = 8'h10;
            4'b1101: oh_shift = 8'h20;
            4'b1110: oh_shift = 8'h40;
            4'b1111: oh_shift = 8'h80;
        endcase
    end: barrelshifter16_onehot
    
    always_ff@(posedge aclk or negedge aresetn) begin: barrelshifter16_onreset
        if(~aresetn)
            tx_shift <= 16'h0000;
    end: barrelshifter16_onreset
    generate
        for (genvar i = 0; i < 8; i++) begin
            always_ff@(posedge aclk or negedge aresetn) begin: barrelshifter16_gen_shift
                if(enable & oh_shift[i] & ~write) begin
                    if(directi￼on[1]) 
                        tx_shift <= (in >> (16 - i)) | (in << i);
                    else if(direction[0])
                        tx_shift <= (in << (16 - i)) | (in >> i);
                end
            end: barrelshifter16_gen_shift
        end
    endgenerate
endmodule: barrelshifter16
