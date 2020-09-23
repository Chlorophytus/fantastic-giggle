`timescale 1ns / 1ps
module adder2
   (input wire logic aresetn,
    input wire logic aclk,
    input wire logic enable,
    input wire logic write,
    input wire logic rx_carryflag,
    input wire logic unsigned [1:0] rx_addend0,
    input wire logic unsigned [1:0] rx_addend1,
    output logic unsigned [1:0] tx_sum,
    output logic tx_carryflag,
    output logic tx_zeroflag);
    logic unsigned [1:0] addend0;
    logic unsigned [1:0] addend1;
    always_ff@(posedge aclk or negedge aresetn) begin: adder2_store_addend0
        if(~aresetn)
            addend0 <= 2'b00;
        else if(enable & write)
            addend0 <= rx_addend0;
    end: adder2_store_addend0

    always_ff@(posedge aclk or negedge aresetn) begin: adder2_store_addend1
        if(~aresetn)
            addend1 <= 2'b00;
        else if(enable & write)
            addend1 <= rx_addend1;
    end: adder2_store_addend1

    always_comb begin: adder2_actual_addition
        case ({(enable & ~write), rx_carryflag, addend1, addend0}) inside
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
