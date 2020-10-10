`timescale 1ns / 1ps
// LUTROM-based 2-bit ALU slice for FPGAs
module alu2
   (// Carry input
    input wire logic rx_carryflag,

    input wire logic unsigned [5:0] rx_what_op,

    // ALU inputs
    input wire logic unsigned [1:0] rx_operand0,
    input wire logic unsigned [1:0] rx_operand1,

    // Sum of addends
    output logic unsigned [1:0] tx_result,

    // Carry output
    output logic tx_carryflag,

    // Zero flag output
    output logic tx_zeroflag,

    // Sign flag output
    output logic tx_signflag);
    // ========================================================================
    // INSTANTIATE LUTS FOR: ADDITION
    // ========================================================================
    always_comb begin: alu2_add
        case ({rx_what_op[0], rx_carryflag, rx_operand1, rx_operand0}) inside
            6'b0_?_??_??: ;

            6'b1_0_00_00: {tx_carryflag, tx_result} = 3'b000;

            6'b1_1_00_00,
            6'b1_0_01_00,
            6'b1_0_00_01: {tx_carryflag, tx_result} = 3'b001;

            6'b1_0_01_01,
            6'b1_0_10_00,
            6'b1_0_00_10,
            6'b1_1_01_00,
            6'b1_1_00_01: {tx_carryflag, tx_result} = 3'b010;

            6'b1_0_01_10,
            6'b1_0_10_01,
            6'b1_0_11_00,
            6'b1_0_00_11,
            6'b1_1_00_10,
            6'b1_1_10_00,
            6'b1_1_01_01: {tx_carryflag, tx_result} = 3'b011;

            6'b1_0_11_01,
            6'b1_0_01_11,
            6'b1_0_10_10,
            6'b1_1_11_00,
            6'b1_1_00_11,
            6'b1_1_01_10,
            6'b1_1_10_01: {tx_carryflag, tx_result} = 3'b100;

            6'b1_0_11_10,
            6'b1_0_10_11,
            6'b1_1_10_10,
            6'b1_1_01_11,
            6'b1_1_11_01: {tx_carryflag, tx_result} = 3'b101;

            6'b1_0_11_11,
            6'b1_1_11_10,
            6'b1_1_10_11: {tx_carryflag, tx_result} = 3'b110;

            6'b1_1_11_11: {tx_carryflag, tx_result} = 3'b111;
        endcase
    end: alu2_add
    // ========================================================================
    // INSTANTIATE LUTS FOR: SUBTRACTION
    // ========================================================================
    always_comb begin: alu2_sub
        case ({rx_what_op[1], rx_carryflag, -rx_operand1, rx_operand0}) inside
            6'b0_?_??_??: ;

            6'b1_0_00_00: {tx_carryflag, tx_result} = 3'b000;

            6'b1_1_00_00,
            6'b1_0_01_00,
            6'b1_0_00_01: {tx_carryflag, tx_result} = 3'b001;

            6'b1_0_01_01,
            6'b1_0_10_00,
            6'b1_0_00_10,
            6'b1_1_01_00,
            6'b1_1_00_01: {tx_carryflag, tx_result} = 3'b010;

            6'b1_0_01_10,
            6'b1_0_10_01,
            6'b1_0_11_00,
            6'b1_0_00_11,
            6'b1_1_00_10,
            6'b1_1_10_00,
            6'b1_1_01_01: {tx_carryflag, tx_result} = 3'b011;

            6'b1_0_11_01,
            6'b1_0_01_11,
            6'b1_0_10_10,
            6'b1_1_11_00,
            6'b1_1_00_11,
            6'b1_1_01_10,
            6'b1_1_10_01: {tx_carryflag, tx_result} = 3'b100;

            6'b1_0_11_10,
            6'b1_0_10_11,
            6'b1_1_10_10,
            6'b1_1_01_11,
            6'b1_1_11_01: {tx_carryflag, tx_result} = 3'b101;

            6'b1_0_11_11,
            6'b1_1_11_10,
            6'b1_1_10_11: {tx_carryflag, tx_result} = 3'b110;

            6'b1_1_11_11: {tx_carryflag, tx_result} = 3'b111;
        endcase
    end: alu2_sub
    // ========================================================================
    // INSTANTIATE LUTS FOR: ROTATING
    // ========================================================================
    always_comb begin: alu2_rot
        case ({rx_what_op[2], rx_carryflag, rx_operand1, rx_operand0}) inside
            6'b0_?_??_??, 6'b1_?_??_11: ;

            6'b1_0_00_00: {tx_carryflag, tx_result} = 3'b000;
            6'b1_0_01_00: {tx_carryflag, tx_result} = 3'b001;
            6'b1_0_10_00: {tx_carryflag, tx_result} = 3'b010;
            6'b1_0_11_00: {tx_carryflag, tx_result} = 3'b011;

            6'b1_0_00_01: {tx_carryflag, tx_result} = 3'b000;
            6'b1_0_01_01: {tx_carryflag, tx_result} = 3'b100;
            6'b1_0_10_01: {tx_carryflag, tx_result} = 3'b001;
            6'b1_0_11_01: {tx_carryflag, tx_result} = 3'b101;

            6'b1_0_00_10: {tx_carryflag, tx_result} = 3'b000;
            6'b1_0_01_10: {tx_carryflag, tx_result} = 3'b010;
            6'b1_0_10_10: {tx_carryflag, tx_result} = 3'b100;
            6'b1_0_11_10: {tx_carryflag, tx_result} = 3'b110;

            6'b1_1_00_00: {tx_carryflag, tx_result} = 3'b100;
            6'b1_1_01_00: {tx_carryflag, tx_result} = 3'b101;
            6'b1_1_10_00: {tx_carryflag, tx_result} = 3'b110;
            6'b1_1_11_00: {tx_carryflag, tx_result} = 3'b100;

            6'b1_1_00_01: {tx_carryflag, tx_result} = 3'b010;
            6'b1_1_01_01: {tx_carryflag, tx_result} = 3'b100;
            6'b1_1_10_01: {tx_carryflag, tx_result} = 3'b011;
            6'b1_1_11_01: {tx_carryflag, tx_result} = 3'b111;

            6'b1_1_00_10: {tx_carryflag, tx_result} = 3'b001;
            6'b1_1_01_10: {tx_carryflag, tx_result} = 3'b011;
            6'b1_1_10_10: {tx_carryflag, tx_result} = 3'b101;
            6'b1_1_11_10: {tx_carryflag, tx_result} = 3'b111;
        endcase
    end: alu2_rot
    // ========================================================================
    // INSTANTIATE LUTS FOR: LOGICAL AND
    // ========================================================================
    always_comb begin: alu2_and
        case ({rx_what_op[3], rx_carryflag, rx_operand1, rx_operand0}) inside
            6'b0_?_??_??: ;

            6'b1_?_00_00: {tx_carryflag, tx_result} = 3'b000;
            6'b1_?_01_00: {tx_carryflag, tx_result} = 3'b000;
            6'b1_?_10_00: {tx_carryflag, tx_result} = 3'b000;
            6'b1_?_11_00: {tx_carryflag, tx_result} = 3'b000;

            6'b1_?_00_01: {tx_carryflag, tx_result} = 3'b000;
            6'b1_?_01_01: {tx_carryflag, tx_result} = 3'b001;
            6'b1_?_10_01: {tx_carryflag, tx_result} = 3'b000;
            6'b1_?_11_01: {tx_carryflag, tx_result} = 3'b001;

            6'b1_?_00_10: {tx_carryflag, tx_result} = 3'b000;
            6'b1_?_01_10: {tx_carryflag, tx_result} = 3'b000;
            6'b1_?_10_10: {tx_carryflag, tx_result} = 3'b010;
            6'b1_?_11_10: {tx_carryflag, tx_result} = 3'b010;

            6'b1_?_00_11: {tx_carryflag, tx_result} = 3'b000;
            6'b1_?_01_11: {tx_carryflag, tx_result} = 3'b001;
            6'b1_?_10_11: {tx_carryflag, tx_result} = 3'b010;
            6'b1_?_11_11: {tx_carryflag, tx_result} = 3'b011;
        endcase
    end: alu2_and
    // ========================================================================
    // INSTANTIATE LUTS FOR: LOGICAL OR
    // ========================================================================
    always_comb begin: alu2_orr
        case ({rx_what_op[4], rx_carryflag, rx_operand1, rx_operand0}) inside
            6'b0_?_??_??: ;

            6'b1_?_00_00: {tx_carryflag, tx_result} = 3'b000;
            6'b1_?_01_00: {tx_carryflag, tx_result} = 3'b001;
            6'b1_?_10_00: {tx_carryflag, tx_result} = 3'b010;
            6'b1_?_11_00: {tx_carryflag, tx_result} = 3'b011;

            6'b1_?_00_01: {tx_carryflag, tx_result} = 3'b001;
            6'b1_?_01_01: {tx_carryflag, tx_result} = 3'b001;
            6'b1_?_10_01: {tx_carryflag, tx_result} = 3'b011;
            6'b1_?_11_01: {tx_carryflag, tx_result} = 3'b011;

            6'b1_?_00_10: {tx_carryflag, tx_result} = 3'b010;
            6'b1_?_01_10: {tx_carryflag, tx_result} = 3'b011;
            6'b1_?_10_10: {tx_carryflag, tx_result} = 3'b010;
            6'b1_?_11_10: {tx_carryflag, tx_result} = 3'b011;

            6'b1_?_00_11: {tx_carryflag, tx_result} = 3'b011;
            6'b1_?_01_11: {tx_carryflag, tx_result} = 3'b011;
            6'b1_?_10_11: {tx_carryflag, tx_result} = 3'b011;
            6'b1_?_11_11: {tx_carryflag, tx_result} = 3'b011;
        endcase
    end: alu2_orr
    // ========================================================================
    // INSTANTIATE LUTS FOR: LOGICAL XOR
    // ========================================================================
    always_comb begin: alu2_eor
        case ({rx_what_op[5], rx_carryflag, rx_operand1, rx_operand0}) inside
            6'b0_?_??_??: ;

            6'b1_?_00_00: {tx_carryflag, tx_result} = 3'b000;
            6'b1_?_01_00: {tx_carryflag, tx_result} = 3'b001;
            6'b1_?_10_00: {tx_carryflag, tx_result} = 3'b010;
            6'b1_?_11_00: {tx_carryflag, tx_result} = 3'b011;

            6'b1_?_00_01: {tx_carryflag, tx_result} = 3'b001;
            6'b1_?_01_01: {tx_carryflag, tx_result} = 3'b000;
            6'b1_?_10_01: {tx_carryflag, tx_result} = 3'b011;
            6'b1_?_11_01: {tx_carryflag, tx_result} = 3'b010;

            6'b1_?_00_10: {tx_carryflag, tx_result} = 3'b010;
            6'b1_?_01_10: {tx_carryflag, tx_result} = 3'b011;
            6'b1_?_10_10: {tx_carryflag, tx_result} = 3'b000;
            6'b1_?_11_10: {tx_carryflag, tx_result} = 3'b001;

            6'b1_?_00_11: {tx_carryflag, tx_result} = 3'b011;
            6'b1_?_01_11: {tx_carryflag, tx_result} = 3'b010;
            6'b1_?_10_11: {tx_carryflag, tx_result} = 3'b001;
            6'b1_?_11_11: {tx_carryflag, tx_result} = 3'b000;
        endcase
    end: alu2_eor
    // ========================================================================
    // FLAG OUTPUTS
    // ========================================================================
    assign tx_zeroflag = ~|tx_result;
    assign tx_signflag = tx_result[1];
endmodule: alu2
