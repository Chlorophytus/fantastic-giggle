`default_nettype none
`timescale 1ns / 1ps
// Instruction decoder unit
module decoder
   (input wire logic aclk,
    input wire logic aresetn,

    // Enable this block
    input wire logic rx_enable,
    // Strobe the state machine
    input wire logic rx_strobe,
    // Data from Program Memory
    input wire logic unsigned [7:0] rx_data,

    // ALU0
    input wire logic rxalu0_ready,
    input wire logic rxalu0_carry,
    input wire logic rxalu0_zero,
    input wire logic rxalu0_sign,
    input wire logic unsigned [7:0] rxalu0_result,
    output logic txalu0_enable,
    output logic txalu0_strobe,
    output logic unsigned [2:0] txalu0_opcode,
    output logic unsigned [7:0] txalu0_operand0,
    output logic unsigned [7:0] txalu0_operand1,
    // ALU1
    input wire logic rxalu1_ready,
    input wire logic rxalu1_carry,
    input wire logic rxalu1_zero,
    input wire logic rxalu1_sign,
    input wire logic unsigned [7:0] rxalu1_result,
    output logic txalu1_enable,
    output logic txalu1_strobe,
    output logic unsigned [2:0] txalu1_opcode,
    output logic unsigned [7:0] txalu1_operand0,
    output logic unsigned [7:0] txalu1_operand1,

    // LOD0
    input wire logic rxlod0_hot,
    input wire logic rxlod0_result,
    input wire logic unsigned [1:0] txlod0_result,
    output logic txlod0_enable,
    output logic unsigned [3:0] txlod0_operand,
    // LOD1
    input wire logic rxlod1_hot,
    input wire logic rxlod1_result,
    input wire logic unsigned [1:0] txlod1_result,
    output logic txlod1_enable,
    output logic unsigned [3:0] txlod1_operand,
    // LOD2
    input wire logic rxlod2_hot,
    input wire logic rxlod2_result,
    input wire logic unsigned [1:0] txlod2_result,
    output logic txlod2_enable,
    output logic unsigned [3:0] txlod2_operand,
    // LOD3
    input wire logic rxlod3_hot,
    input wire logic rxlod3_result,
    input wire logic unsigned [1:0] txlod3_result,
    output logic txlod3_enable,
    output logic unsigned [3:0] txlod3_operand,
    
    // BarrelShifter
    input wire logic unsigned [15:0] rxbarrel_shifted,
    output logic txbarrel_enable,
    output logic txbarrel_write,
    output logic unsigned [1:0] txbarrel_direction,
    output logic unsigned [15:0] txbarrel_input,
    output logic unsigned [2:0] txbarrel_coeff,
    
    input wire logic unsigned [15:0] rxrfile_data,
    output logic txrfile_enable,
    output logic txrfile_write,
    output logic unsigned [2:0] txrfile_select,
    output logic unsigned [15:0] txrfile_data);
    // ========================================================================
    // INSTANTIATE SYNC FOR: STATEFULNESS
    // ========================================================================
    logic unsigned [3:0] state;
    always_ff@(posedge aclk or negedge aresetn) begin: decoder_state_sequ
        if(~aresetn | state[3])
            state <= 4'b0000;
        else if(enable) begin
            if(rx_strobe)
                state <= 4'b0001;
            else
                state <= state << 1;
        end
    end: decoder_state_sequ
    // ========================================================================
    // INSTANTIATE SYNC FOR: ENABLE BIT
    // ========================================================================
    logic enable;
    always_ff@(posedge aclk or negedge aresetn) begin: decoder_enable_sync
        if(~aresetn)
            enable <= 1'b0;
        else
            enable <= rx_enable;
    end: decoder_enable_sync
    // ========================================================================
    // INSTANTIATE SYNC FOR: WORKER (handles decoding the operation statefully)
    // ========================================================================
    logic unsigned [3:0] wstate;
    always_ff@(posedge aclk or negedge aresetn) begin: decoder_wstate_sequ
        if(~aresetn | wstate[3])
            wstate <= 4'b0000;
        else if(enable) begin
            if(state[3])
                wstate <= 4'b0001;
            else
                wstate <= wstate << 1;
        end
    end: decoder_wstate_sequ
    // ========================================================================
    // SEND OFF WORKER OUTPUT
    // ========================================================================

endmodule: decoder
