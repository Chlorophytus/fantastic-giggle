`timescale 1ns / 1ps
// LUTROM-based adder2 block for FPGAs
module adder2
   (// Enable this block
    input wire logic rx_enable,

    // Carry input
    input wire logic rx_carryflag,

    // Addends input
    input wire logic unsigned [1:0] rx_addend0,
    input wire logic unsigned [1:0] rx_addend1,

    // Sum of addends
    output logic unsigned [1:0] tx_sum,

    // Carry output
    output logic tx_carryflag,

    // Zero flag output
    output logic tx_zeroflag);
    always_comb begin: adder2_actual_addition
        case ({rx_enable, rx_carryflag, rx_addend1, rx_addend0}) inside
            6'b0_?_??_??: ;

            6'b1_0_00_00: {tx_carryflag, tx_sum} = 3'b000;

            6'b1_1_00_00,
            6'b1_0_01_00,
            6'b1_0_00_01: {tx_carryflag, tx_sum} = 3'b001;

            6'b1_0_01_01,
            6'b1_0_10_00,
            6'b1_0_00_10,
            6'b1_1_01_00,
            6'b1_1_00_01: {tx_carryflag, tx_sum} = 3'b010;

            6'b1_0_01_10,
            6'b1_0_10_01,
            6'b1_0_11_00,
            6'b1_0_00_11,
            6'b1_1_00_10,
            6'b1_1_10_00,
            6'b1_1_01_01: {tx_carryflag, tx_sum} = 3'b011;

            6'b1_0_11_01,
            6'b1_0_01_11,
            6'b1_0_10_10,
            6'b1_1_11_00,
            6'b1_1_00_11,
            6'b1_1_01_10,
            6'b1_1_10_01: {tx_carryflag, tx_sum} = 3'b100;

            6'b1_0_11_10,
            6'b1_0_10_11,
            6'b1_1_10_10,
            6'b1_1_01_11,
            6'b1_1_11_01: {tx_carryflag, tx_sum} = 3'b101;

            6'b1_0_11_11,
            6'b1_1_11_10,
            6'b1_1_10_11: {tx_carryflag, tx_sum} = 3'b110;

            6'b1_1_11_11: {tx_carryflag, tx_sum} = 3'b111;
        endcase
        tx_zeroflag = ~|tx_sum;
    end: adder2_actual_addition
endmodule: adder2
