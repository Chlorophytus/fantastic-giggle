`default_nettype none
`timescale 1ns / 1ps
module axi4_dut
   (input wire aclk,
    input wire aresetn,
    
    // WRITE ADDRESS
    input wire awvalid,
    output reg awready,
    input wire [15:0] awaddr,
    input wire [2:0] awprot,
    
    // WRITE DATA
    input wire wvalid,
    output reg wready,
    input wire [31:0] wdata,
    input wire [3:0] wstrb,
    
    // WRITE RESPONSE
    output reg bvalid,
    input wire bready, 
    output wire [1:0] bresp,
    
    // READ ADDRESS
    input wire arvalid,
    output reg arready,
    input wire [15:0] araddr,
    input wire [2:0] arprot,
    
    // READ DATA
    output reg rvalid,
    input wire rready, 
    output wire [32:0] rdata,
    output wire [1:0] rresp);

    axi4 d(.*); 
endmodule
