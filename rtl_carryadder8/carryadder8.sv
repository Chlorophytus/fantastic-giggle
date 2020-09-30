`timescale 1ns / 1ps
// 8-bit ripple carry adder based on the `adder2` block
module carryadder8
   (input wire logic aclk,
    input wire logic aresetn,

    // Enable this block
    input wire logic rx_enable,

    // Write to registers
    input wire logic rx_write,

    // Strobe the state machine, running the ripple-carry adder
    input wire logic rx_strobe,

    // Carry flag input
    input wire logic rx_carryflag,

    // Addends input
    input wire logic unsigned [7:0] rx_addend0,
    input wire logic unsigned [7:0] rx_addend1,

    // Sum of addends (a0 + a1)
    output logic unsigned [7:0] tx_sum,

    // Carry flag output
    output logic tx_carryflag,

    // Zero flag output
    output logic tx_zeroflag,

    // Ready signal
    output logic tx_ready);
    // need this synchronizer stuff so the chain of LUTs does not act weird.
    logic enable;
    always_ff@(posedge aclk or negedge aresetn) begin: carryadder8_enable_sync
        if(~aresetn)
            enable <= 1'b0;
        else
            enable <= rx_enable;
    end: carryadder8_enable_sync

    logic write;
    always_ff@(posedge aclk or negedge aresetn) begin: carryadder8_write_sync
        if(~aresetn)
            write <= 1'b0;
        else if(enable & ~|state)
            write <= rx_write;
    end: carryadder8_write_sync

    // statemachine
    logic unsigned [3:0] state;
    always_ff@(posedge aclk or negedge aresetn) begin: carryadder8_state_sequ
        if(~aresetn)
            state <= 4'b0000;
        else if(enable) begin
            if(rx_strobe)
                state <= 4'b0001;
            else
                state <= state << 1;
        end
    end: carryadder8_state_sequ

    // register stuff
    logic unsigned [7:0] addend0;
    logic unsigned [7:0] addend1;
    always_ff@(posedge aclk or negedge aresetn) begin: carryadder8_hold_addend0
        if(~aresetn)
            addend0 <= 8'b0000_0000;
        else if(enable & write & ~|state)
            addend0 <= rx_addend0;
    end: carryadder8_hold_addend0
    always_ff@(posedge aclk or negedge aresetn) begin: carryadder8_hold_addend1
        if(~aresetn)
            addend1 <= 8'b0000_0000;
        else if(enable & write & ~|state)
            addend1 <= rx_addend1;
    end: carryadder8_hold_addend1

    logic unsigned carryflag0;
    logic unsigned carryflag1;
    logic unsigned carryflag2;
    logic unsigned [3:0] zeroflags;
    logic unsigned [7:0] sum;
    generate
        for (genvar i = 0; i < 4; i+=1) begin
            case(i)
                0: adder2 d(
                    .rx_enable(enable & state[i]),
                    .rx_carryflag(rx_carryflag),
                    .rx_addend0(addend0[i+:2]),
                    .rx_addend1(addend1[i+:2]),
                    .tx_sum(sum[i+:2]),
                    .tx_carryflag(carryflag0),
                    .tx_zeroflag(zeroflags[i])
                );
                1: adder2 d(
                    .rx_enable(enable & state[i]),
                    .rx_carryflag(carryflag0),
                    .rx_addend0(addend0[i+:2]),
                    .rx_addend1(addend1[i+:2]),
                    .tx_sum(sum[i+:2]),
                    .tx_carryflag(carryflag1),
                    .tx_zeroflag(zeroflags[i])
                );
                2: adder2 d(
                    .rx_enable(enable & state[i]),
                    .rx_carryflag(carryflag1),
                    .rx_addend0(addend0[i+:2]),
                    .rx_addend1(addend1[i+:2]),
                    .tx_sum(sum[i+:2]),
                    .tx_carryflag(carryflag2),
                    .tx_zeroflag(zeroflags[i])
                );
                3: adder2 d(
                    .rx_enable(enable & state[i]),
                    .rx_carryflag(carryflag2),
                    .rx_addend0(addend0[i+:2]),
                    .rx_addend1(addend1[i+:2]),
                    .tx_sum(sum[i+:2]),
                    .tx_carryflag(tx_carryflag),
                    .tx_zeroflag(zeroflags[i])
                );
            endcase
        end
    endgenerate
    always_ff@(posedge aclk or negedge aresetn) begin: carryadder8_sum
        if(~aresetn)
            tx_sum <= 8'b0000_0000;
        else if(enable & ~|state)
            tx_sum <= sum;
    end: carryadder8_sum
    assign tx_zeroflag = &zeroflags;
    assign tx_ready = ~|state;
endmodule: carryadder8
