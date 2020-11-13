`default_nettype none
`timescale 1ns / 1ps
// AXI4 Lite, full duplex type interface
module axi4
   (input wire logic aclk,
    input wire logic aresetn,

    // WRITE ADDRESS
    input wire logic awvalid,
    output logic awready,
    input wire logic unsigned [15:0] awaddr,
    input wire logic unsigned [2:0] awprot,
    
    // WRITE DATA
    input wire logic wvalid,
    output logic wready,
    input wire logic unsigned [31:0] wdata,
    input wire logic unsigned [3:0] wstrb,
    
    // WRITE RESPONSE
    output logic bvalid,
    input wire logic bready, 
    output wire logic unsigned [1:0] bresp,
    
    // READ ADDRESS
    input wire logic arvalid,
    output logic arready,
    input wire logic unsigned [15:0] araddr,
    input wire logic unsigned [2:0] arprot,
    
    // READ DATA
    output logic rvalid,
    input wire logic rready, 
    output wire logic unsigned [32:0] rdata,
    output wire logic unsigned [1:0] rresp);
    
endmodule: axi4
