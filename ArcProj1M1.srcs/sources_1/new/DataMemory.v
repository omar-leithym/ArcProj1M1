`timescale 1ns / 1ps
module DataMemory(
    input clk,
    input MemRead,
    input MemWrite,
    input [5:0] addr,      // up to 64 words
    input [31:0] data_in,
    output reg [31:0] data_out
);
    reg [31:0] mem [0:63];

    // Synchronous write
    always @(posedge clk) begin
        if(MemWrite) begin
            mem[addr] <= data_in;
        end
    end

    // Asynchronous read
    always @(*) begin
        if(MemRead)
            data_out = mem[addr];
        else
            data_out = 32'b0;
    end

    // Optionally initialize some data words
    initial begin
        // Example data
        mem[0] = 32'd10;  
        mem[1] = 32'd20;   
        mem[2] = 32'd30;  
        // ...
    end
endmodule
