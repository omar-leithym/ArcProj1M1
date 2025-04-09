`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 11:11:01 PM
// Design Name: 
// Module Name: BranchingUnit
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


module BranchingUnit(
    input [2:0] funct3, input cf, zf, vf, sf, output reg Branch
    );
    
    always@(*) begin
        case(funct3)
            3'b000: // beq
                Branch = zf;
            3'b001: // bne
                Branch = ~zf;
            3'b100: // blt
                Branch = (sf != vf);
            3'b101: // bge
                Branch = (sf == vf);
            3'b110: // bltu
                Branch = ~cf;
            3'b111: // bgeu
                Branch = cf;
            default: Branch = 1'b0;
        endcase
    end
endmodule
