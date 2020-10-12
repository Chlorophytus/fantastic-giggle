`timescale 1ns / 1ps
// 4-flag branching unit
module brancher
   (input wire logic aclk,
    input wire logic aresetn,

    // Enable this block
    input wire logic rx_enable,
    
    // Data Write Enables
    input wire logic rx_write_branch,
    input wire logic rx_write_flags,
    
    // Increments the Program Counter, or jumps to `rx_branch`
    input wire logic rx_strobe,
    
    // Flags input from other blocks
    input wire logic unsigned [3:0] rx_input_flags,

    // Flags that we test for
    input wire logic unsigned [3:0] rx_check_flags,
    
    // Branch to here
    input wire logic unsigned [15:0] rx_branch,

    // The current Program Counter
    output logic unsigned [15:0] tx_program_counter,
    
    // Readiness
    output logic tx_ready);
    // ========================================================================
    // INSTANTIATE SYNC FOR: STATEFULNESS
    // ========================================================================
    logic unsigned [2:0] state;
    always_ff@(posedge aclk or negedge aresetn) begin: brancher_state_sequ
        if(~aresetn | state[2])
            state <= 3'b000;
        else if(enable) begin
            if(rx_strobe)
                state <= 3'b001;
            else
                state <= state << 1;
        end
    end: brancher_state_sequ
    // ========================================================================
    // INSTANTIATE SYNC FOR: ENABLE
    // ========================================================================
    logic enable;
    always_ff@(posedge aclk or negedge aresetn) begin: brancher_enable_sync
        if(~aresetn)
            enable <= 1'b0;
        else
            enable <= rx_enable;
    end: brancher_enable_sync
    // ========================================================================
    // INSTANTIATE SYNC FOR: WRITE
    // ========================================================================
    logic write_branch;
    always_ff@(posedge aclk or negedge aresetn) begin: brancher_writebranch_sync
        if(~aresetn)
            write_branch <= 1'b0;
        else if(enable & ~|state)
            write_branch <= rx_write_branch;
    end: brancher_writebranch_sync
    logic write_flags;
    always_ff@(posedge aclk or negedge aresetn) begin: brancher_writeflags_sync
        if(~aresetn)
            write_flags <= 1'b0;
        else if(enable & ~|state)
            write_flags <= rx_write_flags;
    end: brancher_writeflags_sync
    // ========================================================================
    // INSTANTIATE SYNC FOR: FLAGS
    // ========================================================================
    logic unsigned [3:0] check_flags;
    always_ff@(posedge aclk or negedge aresetn) begin: brancher_chk_flags_sync
        if(~aresetn)
            check_flags <= rx_check_flags;
        else if(enable & write_flags & ~|state)
            check_flags <= rx_check_flags;
    end: brancher_chk_flags_sync
    // just sync the flags here, below supresses runt pulses
    logic unsigned [3:0] input_flags;
    always_ff@(posedge aclk or negedge aresetn) begin: brancher_anti_runt_flags
        if(~aresetn)
            input_flags <= rx_input_flags;
        else if(enable)
            input_flags <= rx_input_flags;
    end: brancher_anti_runt_flags
    // ========================================================================
    // INSTANTIATE LUTS FOR: ONE-HOT FLAG EQUALITY CHECK
    // ========================================================================
    logic should_branch;
    always_comb begin: brancher_should_branch
        case ({enable & ~write_flags & ~write_branch, input_flags & check_flags}) inside
            5'b0_????: ;
            5'b1_0000: should_branch = 1'b0;
            5'b1_0001: should_branch = 1'b1;
            5'b1_001?: should_branch = 1'b1;
            5'b1_01??: should_branch = 1'b1;
            5'b1_1???: should_branch = 1'b1;
        endcase
    end: brancher_should_branch
    // ========================================================================
    // INSTANTIATE SYNC FOR: PROGRAM COUNTER
    // ========================================================================
    logic unsigned [15:0] program_branch;
    always_ff@(posedge aclk or negedge aresetn) begin: brancher_pbranch_sync
        if(~aresetn)
            program_branch <= 16'h0000;
        else if(enable & write_branch) begin
            program_branch <= rx_branch;
        end
    end: brancher_pbranch_sync
    always_ff@(posedge aclk or negedge aresetn) begin: brancher_pcounter_sync
        if(~aresetn)
            tx_program_counter <= 16'h0000;
        else if(enable & state[2]) begin
            if(should_branch)
                tx_program_counter <= program_branch;
            else
                tx_program_counter <= tx_program_counter + 16'h0001;
        end
    end: brancher_pcounter_sync

    assign tx_ready = ~|state;
endmodule: brancher
