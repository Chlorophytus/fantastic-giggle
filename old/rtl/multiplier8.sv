`default_nettype none
`timescale 1ns / 1ps
// 8-bit Multiplier
module multiplier8
   (input wire logic aclk,
    input wire logic aresetn,

    // Enable this block
    input wire logic rx_enable,

    // Write to registers
    input wire logic unsigned [1:0] rx_write,

    // Operand to multiply
    input wire logic unsigned [7:0] rx_operand,

    // Strobe the state machine, running the multiplier
    input wire logic rx_strobe,

    // The result of the multiplication
    output logic unsigned [15:0] tx_result,

    // Ready signal
    output logic tx_ready);
    // Good practice: capture enable/write inputs
    logic enable;
    always_ff@(posedge aclk or negedge aresetn) begin: multiplier8_enable_sync
        if(~aresetn)
            enable <= 1'b0;
        else
            enable <= rx_enable;
    end: multiplier8_enable_sync

    logic unsigned [1:0] write;
    always_ff@(posedge aclk or negedge aresetn) begin: multiplier8_write_sync
        if(~aresetn)
            write <= 2'b00;
        else if(enable)
            write <= rx_write;
    end: multiplier8_write_sync

    logic unsigned [7:0] op0;
    logic unsigned [7:0] op1;
    always_ff@(posedge aclk or negedge aresetn) begin: multiplier8_hold_operand0
        if(~aresetn)
            op0 <= 8'b0000_0000;
        else if(enable & write[0] & ~|state)
            op0 <= rx_operand;
    end: multiplier8_hold_operand0
    always_ff@(posedge aclk or negedge aresetn) begin: multiplier8_hold_operand1
        if(~aresetn)
            op1 <= 8'b0000_0000;
        else if(enable & write[1] & ~|state)
            op1 <= rx_operand;
    end: multiplier8_hold_operand1

    logic unsigned [3:0] state;
    always_ff@(posedge aclk or negedge aresetn) begin: multiplier8_state_sequ
        if(~aresetn | state[3])
            state <= 4'b0000;
        else if(enable) begin
            if(rx_strobe & ~|write)
                state <= 4'b0001;
            else
                state <= state << 1;
        end
    end: multiplier8_state_sequ

`ifndef VERILATOR
   MULT_MACRO #(
      .DEVICE("7SERIES"), // Target Device: "7SERIES" 
      .LATENCY(2),        // Desired clock cycle latency, 0-4
      .WIDTH_A(16),       // Multiplier A-input bus width, 1-25
      .WIDTH_B(16)        // Multiplier B-input bus width, 1-18
   ) MULT_MACRO_inst (
      .P(tx_result),     // Multiplier output bus, width determined by WIDTH_P parameter
      .A({op0[7], 8'h00, op0[6:0]}),     // Multiplier input A bus, width determined by WIDTH_A parameter
      .B({op1[7], 8'h00, op1[6:0]}),     // Multiplier input B bus, width determined by WIDTH_B parameter
      .CE(enable & ~write),   // 1-bit active high input clock enable
      .CLK(aclk), // 1-bit positive edge clock input
      .RST(~aresetn)  // 1-bit input active high reset
   );
`else
    always_ff@(posedge aclk or negedge aresetn) begin: multiplier8_verilator_mul
        if(~aresetn)
            tx_result <= 16'h0000;
        else if(state[2])
            tx_result <= {op0[7], 8'h00, op0[6:0]} * {op1[7], 8'h00, op1[6:0]};
    end: multiplier8_verilator_mul
`endif
    assign tx_ready = ~|state;
endmodule: multiplier8