`timescale 1ns / 1ps
// 64kB 16-bit addressable memory
module memory16
   (input wire logic aclk,
    input wire logic aresetn,

    // Enable this block
    input wire logic rx_enable,
    
    // Data Write Enable
    input wire logic rx_write,

    // Strobe the state machine, reading or writing from memory.
    input wire logic rx_strobe,
    
    // Where is the memory reading/writing to?
    input wire logic unsigned [15:0] rx_program_counter,
    
    // Data in and out
    input wire logic unsigned [7:0] rx_data,
    output logic unsigned [7:0] tx_data,
    
    // Ready signal
    output logic tx_ready);
    logic unsigned [7:0] memory[65536];
    // ========================================================================
    // INSTANTIATE SYNC FOR: STATEFULNESS
    // ========================================================================
    logic unsigned [2:0] state;
    always_ff@(posedge aclk or negedge aresetn) begin: memory16_state_sequ
        if(~aresetn | state[2])
            state <= 3'b000;
        else if(enable) begin
            if(rx_strobe)
                state <= 3'b001;
            else
                state <= state << 1;
        end
    end: memory16_state_sequ
    // ========================================================================
    // INSTANTIATE SYNC FOR: ENABLE
    // ========================================================================
    logic enable;
    always_ff@(posedge aclk or negedge aresetn) begin: memory16_enable_sync
        if(~aresetn)
            enable <= 1'b0;
        else
            enable <= rx_enable;
    end: memory16_enable_sync
    // ========================================================================
    // INSTANTIATE SYNC FOR: WRITE
    // ========================================================================
    logic write;
    always_ff@(posedge aclk or negedge aresetn) begin: memory16_write_sync
        if(~aresetn)
            write <= 1'b0;
        else if(enable & ~|state)
            write <= rx_write;
    end: memory16_write_sync
    // ========================================================================
    // INSTANTIATE SYNC FOR: MEMORY
    // ========================================================================
    always_ff@(posedge aclk or negedge aresetn) begin: memory16_write
        if(~aresetn)
            $readmemh("bootrom.mem", memory);
        else if(enable & write & state[2])
            memory[rx_program_counter] <= rx_data;
    end: memory16_write
    always_ff@(posedge aclk or negedge aresetn) begin: memory16_read
        if(~aresetn)
            tx_data <= 8'h00;
        else if(enable & ~write & state[2])
            tx_data <= memory[rx_program_counter];
    end: memory16_read
    // ========================================================================
    // READY SIGNAL
    // ========================================================================
    assign tx_ready = ~|state;
endmodule: memory16
