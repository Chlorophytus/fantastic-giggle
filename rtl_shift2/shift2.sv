`timescale 1ns / 1ps
// LUTROM-based shift2 block for FPGAs
module shift2
   (// Enable this block
    input wire logic rx_enable,

    // Carry input.
    // For convenience, this is the MSB (3rd bit, bit 2, whatever)
    input wire logic rx_carryflag,

    // Input to shift
    input wire logic unsigned [1:0] rx_input,

    // How much we shift by
    input wire logic unsigned [1:0] rx_coeff,

    // Shifted `rx_input`
    output logic unsigned [1:0] tx_result,

    // Carry output, still is MSB
    output logic tx_carryflag);
    always_comb begin: shift2_actual_shift
        case ({rx_enable, rx_carryflag, rx_coeff, rx_input}) inside
            6'b0_?_??_??, 6'b1_?_11_??: ;
            6'b1_?_00_??: {tx_carryflag, tx_result} = {rx_carryflag, rx_input};
            
            6'b1_0_01_00: {tx_carryflag, tx_result} = 3'b000;
            6'b1_0_10_00: {tx_carryflag, tx_result} = 3'b000;
            6'b1_1_01_00: {tx_carryflag, tx_result} = 3'b010;
            6'b1_1_10_00: {tx_carryflag, tx_result} = 3'b001;

            6'b1_0_01_01: {tx_carryflag, tx_result} = 3'b100;
            6'b1_0_10_01: {tx_carryflag, tx_result} = 3'b010;
            6'b1_1_01_01: {tx_carryflag, tx_result} = 3'b011;
            6'b1_1_10_01: {tx_carryflag, tx_result} = 3'b011;

            6'b1_0_01_10: {tx_carryflag, tx_result} = 3'b001;
            6'b1_0_10_10: {tx_carryflag, tx_result} = 3'b100;
            6'b1_1_01_10: {tx_carryflag, tx_result} = 3'b011;
            6'b1_1_10_10: {tx_carryflag, tx_result} = 3'b101;

            6'b1_0_01_11: {tx_carryflag, tx_result} = 3'b101;
            6'b1_0_10_11: {tx_carryflag, tx_result} = 3'b101;
            6'b1_1_01_11: {tx_carryflag, tx_result} = 3'b111;
            6'b1_1_10_11: {tx_carryflag, tx_result} = 3'b111;
        endcase
    end: shift2_actual_shift
endmodule: shift2
