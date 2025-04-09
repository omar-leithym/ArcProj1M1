`timescale 1ns / 1ps

module CU(
    input[4:0] instBits, output reg Branch, MemRead, MemtoReg, output reg[1:0] ALUOp, output reg memWrite, ALUSrc, RegWrite
    );
    
    always@(*) begin
        if(instBits == 5'b01100) begin
            Branch=1'b0; MemRead = 1'b0; MemtoReg=1'b0; ALUOp = 2'b10; memWrite = 1'b0; ALUSrc = 1'b0; RegWrite = 1'b1;
        end
        if(instBits == 5'b00000) begin
            Branch=1'b0; MemRead = 1'b1; MemtoReg=1'b1; ALUOp = 2'b00; memWrite = 1'b0; ALUSrc = 1'b1; RegWrite = 1'b1;
        end 
        if(instBits == 5'b01000) begin
            Branch=1'b0; MemRead = 1'b0; MemtoReg=1'bx; ALUOp = 2'b00; memWrite = 1'b1; ALUSrc = 1'b1; RegWrite = 1'b0;
        end 
        if(instBits == 5'b11000) begin
            Branch=1'b1; MemRead = 1'b0; MemtoReg=1'bx; ALUOp = 2'b01; memWrite = 1'b0; ALUSrc = 1'b0; RegWrite = 1'b0;
        end  
    end
endmodule
