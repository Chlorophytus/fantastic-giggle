`timescale 1ns / 1ps
// 16-bit 8-register file
module registerfile16x8
   (input wire logic aclk,
    input wire logic aresetn,

    // Enable this block
    input wire logic rx_enable,
    
    // Write Enable
    input wire logic rx_write,
    
    // Select this register to read or write to
    input wire logic unsigned [2:0] rx_select,
    
    // Data in and out
    input wire logic unsigned [15:0] rx_data,
    output logic unsigned [15:0] tx_data);
    // ========================================================================
    // INSTANTIATE SYNC FOR: ENABLE
    // ========================================================================
    logic enable;
    always_ff@(posedge aclk or negedge aresetn) begin: registerfile16x8_enable_sync
        if(~aresetn)
            enable <= 1'b0;
        else
            enable <= rx_enable;
    end: registerfile16x8_enable_sync
    // ========================================================================
    // INSTANTIATE SYNC FOR: WRITE
    // ========================================================================
    logic write;
    always_ff@(posedge aclk or negedge aresetn) begin: registerfile16x8_write_sync
        if(~aresetn)
            write <= 1'b0;
        else if(enable)
            write <= rx_write;
    end: registerfile16x8_write_sync
    // ========================================================================
    // INSTANTIATE SYNC FOR: SELECT
    // ========================================================================
    logic unsigned [2:0] select;
    always_ff@(posedge aclk or negedge aresetn) begin: registerfile16x8_select
        if(~aresetn)
            select <= 3'b000;
        else if(enable)
            select <= rx_select;
    end: registerfile16x8_select
    // ========================================================================
    // INSTANTIATE LUTS FOR: SELECT
    // ========================================================================
    logic unsigned [7:0] oh_select;
    always_comb begin: registerfile16x8_onehot
        case({enable, select}) inside
            4'b0???: oh_select = 8'h00;

            4'b1000: oh_select = 8'h01;
            4'b1001: oh_select = 8'h02;
            4'b1010: oh_select = 8'h04;
            4'b1011: oh_select = 8'h08;
            4'b1100: oh_select = 8'h10;
            4'b1101: oh_select = 8'h20;
            4'b1110: oh_select = 8'h40;
            4'b1111: oh_select = 8'h80;
        endcase
    end: registerfile16x8_onehot
    // ========================================================================
    // GENERATE REGISTERS
    // ========================================================================
    always_ff@(posedge aclk or negedge aresetn) begin: registerfile16x8_onreset 
        if(~aresetn | (enable & oh_select[0]))
            tx_data <= 16'h0000;
    end: registerfile16x8_onreset
    generate
        for (genvar i = 1; i < 8; i++) begin
            logic unsigned [15:0] myself;
            always_ff@(posedge aclk or negedge aresetn) begin: registerfile16x8_gen_store
                if(~aresetn)
                    myself <= 16'h0000;
                else if (enable & oh_select[i]) begin
                    if(write)
                        myself <= rx_data;
                    else
                        tx_data <= myself;
                end
            end: registerfile16x8_gen_store
        end
    endgenerate
endmodule: registerfile16x8
