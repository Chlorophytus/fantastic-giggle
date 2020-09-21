`timescale 1ns / 1ps
module accumulator4
   (input wire logic aresetn,
    input wire logic aclk,
    input wire logic enable,
    input wire logic rx_carry,
    input wire logic unsigned [3:0] rx_operand_hi,
    input wire logic unsigned [3:0] rx_operand_lo,
    input wire logic unsigned [4:0] rx_opcode,
    output logic unsigned [7:0] tx_accumulator,
    output logic tx_zero,
    output logic tx_sign,
    output logic tx_carry);
    /** ENABLER PATHS
     * 0 = load hi nybble of accumulator from hi operand
     * 1 = load lo nybble of accumulator from lo operand
     * 2 = load lo nybble of accumulator from hi operand
     * 3 = load hi nybble of accumulator from lo operand
     * 4 = load hi nybble of constant from hi operand
     * 5 = load lo nybble of constant from lo operand
     * 6 = load lo nybble of constant from hi operand
     * 7 = load hi nybble of constant from lo operand
     * 8 = add with carry
     * 9 = add w/o carry
     */
    logic unsigned [9:0] i_enabler_paths;
    logic unsigned [7:0] i_constant;
    always_comb begin: accumulator4_mux
        case ({enable, rx_opcode}) inside
            6'b100001: i_enabler_paths = 10'b0000000001;
            6'b100010: i_enabler_paths = 10'b0000000010;
            6'b100011: i_enabler_paths = 10'b0000000011;
            6'b100101: i_enabler_paths = 10'b0000000100;
            6'b100110: i_enabler_paths = 10'b0000001000;
            6'b100111: i_enabler_paths = 10'b0000001100;
            6'b101001: i_enabler_paths = 10'b0000010000;
            6'b101010: i_enabler_paths = 10'b0000100000;
            6'b101011: i_enabler_paths = 10'b0000110000;
            6'b101101: i_enabler_paths = 10'b0001000000;
            6'b101110: i_enabler_paths = 10'b0010000000;
            6'b101111: i_enabler_paths = 10'b0011000000;
            6'b110001: i_enabler_paths = 10'b0100000000;
            6'b110010: i_enabler_paths = 10'b1000000000;
            6'b110100: i_enabler_paths = 10'b0000100001;
            6'b110101: i_enabler_paths = 10'b0000010010;
            6'b110110: i_enabler_paths = 10'b0010000100;
            6'b110111: i_enabler_paths = 10'b0001001000;
            default:   i_enabler_paths = 10'b0000000000;
        endcase
    end: accumulator4_mux
    always_ff@(posedge aclk or negedge aresetn) begin: accumulator4_result
        if(~aresetn)
            tx_accumulator <= 8'b0000_0000;
        else if(enable) begin
            case(i_enabler_paths) inside
                10'b0000000001: tx_accumulator[7:4] <= rx_operand_hi;
                10'b0000000010: tx_accumulator[3:0] <= rx_operand_lo;
                10'b0000000011: tx_accumulator <= {rx_operand_hi, rx_operand_lo};
                10'b00000001??: tx_accumulator[7:4] <= rx_operand_lo;
                10'b00000010??: tx_accumulator[3:0] <= rx_operand_hi;
                10'b00000011??: tx_accumulator <= {rx_operand_lo, rx_operand_hi};
                10'b01????????: {tx_carry, tx_accumulator} <= {1'b0, tx_accumulator} + {1'b0, i_constant} + {8'h00, rx_carry};
                10'b1?????????: tx_accumulator <= tx_accumulator + i_constant;
                default: ;
            endcase
        end
    end: accumulator4_result
    always_ff@(posedge aclk or negedge aresetn) begin: accumulator4_constant
        if(~aresetn)
            i_constant <= 8'b0000_0000;
        else if(enable) begin
            case(i_enabler_paths) inside
                10'b000001????: i_constant[7:4] <= rx_operand_hi;
                10'b000010????: i_constant[3:0] <= rx_operand_lo;
                10'b000011????: i_constant <= {rx_operand_hi, rx_operand_lo};
                10'b0001??????: i_constant[7:4] <= rx_operand_lo;
                10'b0010??????: i_constant[3:0] <= rx_operand_hi;
                10'b0011??????: i_constant <= {rx_operand_lo, rx_operand_hi};
                default: ;
            endcase
        end
    end: accumulator4_constant
endmodule: accumulator4
