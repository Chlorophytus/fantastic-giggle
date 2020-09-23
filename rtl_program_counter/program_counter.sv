`timescale 1ns / 1ps
module program_counter
   (input wire logic aresetn,
    input wire logic aclk,
    input wire logic enable,
    input wire logic cjmp, // Count Jumps
    input wire logic rjmp, // Realm Jumps
    input wire logic unsigned [7:0] rx_count,
    input wire logic unsigned [7:0] rx_realm,
    output logic unsigned [15:0] tx_addr);
    // The realm and the count together compose a 16-bit program counter.
    // [(Realm << 8) | (Count << 0)] -> PC
    always_ff@(posedge aclk or negedge aresetn) begin: program_counter_realm
        if(~aresetn)
            tx_addr[15:8] <= 8'b0000_0000;
        else if(enable & rjmp)
            tx_addr[15:8] <= rx_realm;
    end: program_counter_realm

    always_ff@(posedge aclk or negedge aresetn) begin: program_counter_count
        if(~aresetn)
            tx_addr[7:0] <= 8'b0000_0000;
        else if(enable) begin
            if(cjmp)
                tx_addr[7:0] <= rx_count + 8'b0000_0001;
            else if(~rjmp)
                tx_addr[7:0] <= tx_addr[7:0] + 8'b0000_0001;
            else
                tx_addr[7:0] <= 8'b0000_0000;
        end
    end: program_counter_count
endmodule: program_counter
