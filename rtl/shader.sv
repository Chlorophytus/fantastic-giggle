`default_nettype none
`timescale 1ns / 1ps
// Root Unit
module shader
  #(parameter BOOTROM = "bootrom.mem")
   (input wire logic aclk,
    input wire logic aresetn,
    
    // Enable this block
    input wire logic rx_enable,
    
    input wire logic unsigned [7:0] rx_port0,
    input wire logic unsigned [7:0] rx_port1,
    input wire logic unsigned [7:0] rx_port2,
    input wire logic unsigned [7:0] rx_port3,
    output logic unsigned [7:0] tx_port0,
    output logic unsigned [7:0] tx_port1,
    output logic unsigned [7:0] tx_port2,
    output logic unsigned [7:0] tx_port3);
    // ========================================================================
    // INSTANTIATE CTL
    // ========================================================================
    // brancher ctl();
    // ========================================================================
    // INSTANTIATE MUL
    // ========================================================================
    // multiplier mul();
    // ========================================================================
    // INSTANTIATE MEM
    // ========================================================================
    logic mem_rx_enable;
    logic mem_rx_write;
    logic mem_rx_strobe;
    logic unsigned [11:0] mem_rx_program_counter;
    logic unsigned [7:0] mem_rx_data;
    logic unsigned [7:0] mem_tx_data;
    logic mem_tx_ready;
    memory#(BOOTROM) mem(
        .aclk(aclk),
        .aresetn(aresetn),
        .rx_enable(mem_rx_enable),
        .rx_write(mem_rx_write),
        .rx_strobe(mem_rx_strobe),
        .rx_program_counter(mem_rx_program_counter),
        .rx_data(mem_rx_data),
        .tx_data(mem_tx_data),
        .tx_ready(mem_tx_ready)
    );
endmodule: shader