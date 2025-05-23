`timescale 1ns / 1ps
module RegFile(
    input  [4:0] read1, 
    input  [4:0] read2, 
    input  [4:0] write1, 
    input  [31:0] writeData, 
    input  write, 
    input  rst,
    input  clk,
    output [31:0] read1Output, 
    output [31:0] read2Output
);
    reg [31:0] regFile [0:31];
    integer i;
    
    // Initialize registers at simulation start
    initial begin
        for(i=0; i<32; i=i+1) begin
            regFile[i] = 32'b0;
        end
    end
    
    // Synchronous write with asynchronous reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for(i=0; i<32; i=i+1) begin
                regFile[i] <= 32'b0;
            end
        end
        else if (write && (write1 != 5'b0)) begin
            regFile[write1] <= writeData;
        end
    end
    
    // Asynchronous read with special handling for x0 register
    assign read1Output = (read1 == 5'b0) ? 32'b0 : regFile[read1];
    assign read2Output = (read2 == 5'b0) ? 32'b0 : regFile[read2];
endmodule
