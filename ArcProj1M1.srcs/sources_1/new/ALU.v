`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 11:56:45 AM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU (
        input [31:0] A, [31:0] B, [3:0] ALUsel, output reg [31:0] result, output zeroFlag 
    );
  wire [4:0] shamt = B[4:0];
    
    always @(*) begin
        case(ALUsel)
            4'b0010: result = A + B;    // add  
            4'b0110: result = A - B;    // sub  
            4'b0000: result = A & B;    // and
            4'b0001: result = A | B;    // or
            4'b0100: result = A ^ B;    // xor
            4'b1000: result = A << shamt; // sll
            4'b1001: result = A >> shamt; // srl
            4'b1010: result = $signed(A) >>> shamt;  // sra
            4'b1011: result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // slt 
            4'b1100: result = (A < B) ? 32'd1 : 32'd0;        // sltu
            default: result = 32'd0;
        endcase
    end

    assign zeroFlag = (result == 32'd0);
    
endmodule