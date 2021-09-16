`default_nettype none
`timescale 1ns / 1ps
// 8-bit ripple carry ALU based on the `alu2` block
module carry4_alu2
   (input wire logic aclk,
    input wire logic aresetn,

    // Enable this block
    input wire logic rx_enable,

    // Write to registers
    input wire logic rx_write,

    // What op to do?
    input wire logic unsigned [2:0] rx_opcode,

    // Strobe the state machine, running the ripple-carry ALU
    input wire logic rx_strobe,

    // Carry flag input
    input wire logic rx_carryflag,

    // Addends input
    input wire logic unsigned [7:0] rx_operand0,
    input wire logic unsigned [7:0] rx_operand1,

    // Sum of addends (a0 + a1)
    output logic unsigned [7:0] tx_result,

    // Carry flag output
    output logic tx_carryflag,

    // Zero flag output
    output logic tx_zeroflag,

    // Sign flag output
    output logic tx_signflag,

    // Ready signal
    output logic tx_ready);
    // ========================================================================
    // INSTANTIATE SYNC FOR: STATEFULNESS
    // ========================================================================
    logic unsigned [3:0] state;
    always_ff@(posedge aclk or negedge aresetn) begin: carryadder8_state_sequ
        if(~aresetn | state[3])
            state <= 4'b0000;
        else if(enable) begin
            if(rx_strobe & ~write)
                state <= 4'b0001;
            else
                state <= state << 1;
        end
    end: carryadder8_state_sequ
    // ========================================================================
    // INSTANTIATE SYNC FOR: ENABLE BIT
    // ========================================================================
    logic enable;
    always_ff@(posedge aclk or negedge aresetn) begin: carryadder8_enable_sync
        if(~aresetn)
            enable <= 1'b0;
        else
            enable <= rx_enable;
    end: carryadder8_enable_sync
    // ========================================================================
    // INSTANTIATE SYNC FOR: WRITE BIT
    // ========================================================================
    logic write;
    always_ff@(posedge aclk or negedge aresetn) begin: carryadder8_write_sync
        if(~aresetn)
            write <= 1'b0;
        else if(enable & ~|state)
            write <= rx_write;
    end: carryadder8_write_sync
    // ========================================================================
    // INSTANTIATE SYNC FOR: OPERANDS
    // ========================================================================
    logic unsigned [7:0] operand0;
    logic unsigned [7:0] operand1;
    always_ff@(posedge aclk or negedge aresetn) begin: carryadder8_hold_operand0
        if(~aresetn)
            operand0 <= 8'b0000_0000;
        else if(enable & write & ~|state)
            operand0 <= rx_operand0;
    end: carryadder8_hold_operand0
    always_ff@(posedge aclk or negedge aresetn) begin: carryadder8_hold_operand1
        if(~aresetn)
            operand1 <= 8'b0000_0000;
        else if(enable & write & ~|state)
            operand1 <= rx_operand1;
    end: carryadder8_hold_operand1
    // ========================================================================
    // INSTANTIATE SYNC FOR: OPCODE
    // ========================================================================
    logic unsigned [2:0] opcode;
    always_ff@(posedge aclk or negedge aresetn) begin: carryadder8_hold_opcode
        if(~aresetn)
            opcode <= 3'b000;
        else if(enable & write & ~|state)
            opcode <= rx_opcode;
    end: carryadder8_hold_opcode
    // ========================================================================
    // INSTANTIATE OPERATION SENDOFFS
    // ========================================================================
    logic unsigned [6:0] send_openable;
    logic unsigned [4:0] send_op0;
    logic unsigned [4:0] send_op1;
    logic unsigned [4:0] send_op2;
    logic unsigned [4:0] send_op3;
    always_comb begin: carry4_alu2_sends
        case ({enable & ~write, opcode}) inside
            4'b0_???: send_openable = 7'b00_00000;

            // NOP
            4'b1_000: send_openable = 7'b00_00000;
            // ADC
            4'b1_001: send_openable = 7'b00_00001;
            // SUB
            4'b1_010: send_openable = 7'b00_00010;
            // AND
            4'b1_011: send_openable = 7'b00_00100;
            // ORR
            4'b1_100: send_openable = 7'b00_01000;
            // EOR
            4'b1_101: send_openable = 7'b00_10000;
            // SEL
            4'b1_110: send_openable = 7'b01_00000;
            // SEH
            4'b1_111: send_openable = 7'b10_00000;
        endcase
        send_op0 = state[0] ? send_openable[4:0] : 5'b00000;
        send_op1 = state[1] ? send_openable[4:0] : 5'b00000;
        send_op2 = state[2] ? send_openable[4:0] : 5'b00000;
        send_op3 = state[3] ? send_openable[4:0] : 5'b00000;
    end: carry4_alu2_sends
    // ========================================================================
    // GENERATE ALU BLOCKS
    // ========================================================================
    logic unsigned carryI[4];
    logic unsigned carryO[4];
    logic unsigned [3:0] zeroflags;
    logic unsigned [7:0] result;
    assign tx_carryflag = carryO[3];
    generate
        for(genvar i = 0; i < 4; i++) begin: carry4_alu2_Galu2
            case(i)
                0: begin
                    always_ff@(posedge aclk or negedge aresetn) begin: carry4_alu2_carry_forwarding
                        if(~aresetn)
                            carryI[i] <= 1'b0;
                        else
                            carryI[i] <= rx_carryflag;
                    end: carry4_alu2_carry_forwarding

                    alu2 alu(
                        .rx_what_op(send_op0),
                        .rx_carryflag(carryI[i]),
                        .rx_operand0(operand0[i*2+:2]),
                        .rx_operand1(operand1[i*2+:2]),
                        .tx_result(result[i*2+:2]),
                        .tx_carryflag(carryO[i]),
                        .tx_zeroflag(zeroflags[i]),
                        .tx_signflag()
                    );
                end
                1: begin
                    always_ff@(posedge aclk or negedge aresetn) begin: carry4_alu2_carry_forwarding
                        if(~aresetn)
                            carryI[i] <= 1'b0;
                        else
                            carryI[i] <= carryO[i - 1];
                    end: carry4_alu2_carry_forwarding
                    alu2 alu(
                        .rx_what_op(send_op1),
                        .rx_carryflag(carryI[i]),
                        .rx_operand0(operand0[i*2+:2]),
                        .rx_operand1(operand1[i*2+:2]),
                        .tx_result(result[i*2+:2]),
                        .tx_carryflag(carryO[i]),
                        .tx_zeroflag(zeroflags[i]),
                        .tx_signflag()
                    );
                end 
                2: begin
                    always_ff@(posedge aclk or negedge aresetn) begin: carry4_alu2_carry_forwarding
                        if(~aresetn)
                            carryI[i] <= 1'b0;
                        else
                            carryI[i] <= carryO[i - 1];
                    end: carry4_alu2_carry_forwarding
                    alu2 alu(
                        .rx_what_op(send_op2),
                        .rx_carryflag(carryI[i]),
                        .rx_operand0(operand0[i*2+:2]),
                        .rx_operand1(operand1[i*2+:2]),
                        .tx_result(result[i*2+:2]),
                        .tx_carryflag(carryO[i]),
                        .tx_zeroflag(zeroflags[i]),
                        .tx_signflag()
                    );
                end 
                3: begin
                    always_ff@(posedge aclk or negedge aresetn) begin: carry4_alu2_carry_forwarding
                        if(~aresetn)
                            carryI[i] <= 1'b0;
                        else
                            carryI[i] <= carryO[i - 1];
                    end: carry4_alu2_carry_forwarding
                    alu2 alu(
                        .rx_what_op(send_op3),
                        .rx_carryflag(carryI[i]),
                        .rx_operand0(operand0[i*2+:2]),
                        .rx_operand1(operand1[i*2+:2]),
                        .tx_result(result[i*2+:2]),
                        .tx_carryflag(carryO[i]),
                        .tx_zeroflag(zeroflags[i]),
                        .tx_signflag(tx_signflag)
                    );
                end
            endcase
        end: carry4_alu2_Galu2
    endgenerate
    always_ff@(posedge aclk or negedge aresetn) begin: carryadder8_sum
        if(~aresetn)
            tx_result <= 8'b0000_0000;
        else if(enable & state[3]) begin
            if(|send_openable[6:5]) begin
                if(send_openable[6])
                    tx_result <= operand1;
                else if(send_openable[5])
                    tx_result <= operand0;
            end else
                tx_result <= result;        
        end
    end: carryadder8_sum
    assign tx_zeroflag = &zeroflags;
    assign tx_ready = ~|state;
endmodule: carry4_alu2
