`timescale 1ns / 1ps

module CU(
    input [6:0] instBits,
    output reg Branch, 
    output reg MemRead, 
    output reg MemtoReg,
    output reg [1:0] ALUOp,
    output reg MemWrite, 
    output reg ALUSrc, 
    output reg RegWrite,
    output reg FenceOp  
);

    always@(*) begin
       
        Branch = 1'b0;
        MemRead = 1'b0;
        MemtoReg = 1'b0;
        ALUOp = 2'b00;
        MemWrite = 1'b0;
        ALUSrc = 1'b0;
        RegWrite = 1'b0;
        FenceOp = 1'b0;
        
        case(instBits[6:2]) 
            // I-type arithmetic operations (ADDI, ANDI, ORI, XORI, SLTI, SLTIU)
            5'b00100: begin
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = 2'b11;    // ALUOp for I-type arithmetic
                MemWrite = 1'b0;
                ALUSrc = 1'b1;    // Use immediate
                RegWrite = 1'b1;  // Write to register
                FenceOp = 1'b0;
            end
            
            // LUI instruction
            5'b01101: begin
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = 2'b10;    // Special ALUOp for LUI
                MemWrite = 1'b0;
                ALUSrc = 1'b1;    // Use immediate
                RegWrite = 1'b1;  // Write to register
                FenceOp = 1'b0;
            end
            
            // AUIPC instruction
            5'b00101: begin
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = 2'b10;    // Special ALUOp for AUIPC
                MemWrite = 1'b0;
                ALUSrc = 1'b1;    // Use immediate
                RegWrite = 1'b1;  // Write to register
                FenceOp = 1'b0;
            end
            
            // FENCE instruction
            5'b00011: begin
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = 2'b00;    
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
                FenceOp = 1'b1;   // Signal fence operation
            end
            
            default: begin
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = 2'b00;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
                FenceOp = 1'b0;
            end
        endcase
    end
endmodule
