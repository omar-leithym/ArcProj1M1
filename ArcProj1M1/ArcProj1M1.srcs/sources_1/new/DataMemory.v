module DataMemory(
    input clk,
    input rst,            
    input MemRead,
    input MemWrite,
    input [5:0] addr,      // Up to 64 words
    input [31:0] data_in,
    output reg [31:0] data_out
);
    reg [31:0] mem [0:63];
    integer i;
    
    // Synchronous write
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 64; i = i + 1) begin
                mem[i] <= 32'b0; // Reset all memory to zero
            end
        end else if (MemWrite) begin
            mem[addr] <= data_in;
        end
    end

    // Asynchronous read
    always @(*) begin
        if (MemRead)
            data_out = mem[addr];
        else
            data_out = 32'b0;
    end
    
endmodule
