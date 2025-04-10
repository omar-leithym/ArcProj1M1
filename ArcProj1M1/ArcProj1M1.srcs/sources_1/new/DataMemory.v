module DataMemory(
    input clk,
    input MemRead,
    input MemWrite,
    input [5:0] addr,
    input [31:0] data_in,
    output reg [31:0] data_out
);
    reg [31:0] memory [0:63];
    
    integer i;
    initial begin
        // Initialize memory with some test pattern
        for (i=0; i<64; i=i+1)
            memory[i] = i;
    end
    
    always @(posedge clk) begin
        if (MemWrite)
            memory[addr] <= data_in;
    end
    
    always @(*) begin
        if (MemRead)
            data_out = memory[addr];
        else
            data_out = 32'h00000000;
    end
endmodule
