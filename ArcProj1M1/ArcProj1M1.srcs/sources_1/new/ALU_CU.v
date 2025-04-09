`timescale 1ns / 1ps
module ALU_CU(
    input [2:0] inst14_12,   // f3
    input [1:0] ALUOp,       
    input inst30,            // F7[30] bit
    input inst25,            // F7[25] bit for MUL/DIV operations
    output reg [3:0] ALUsel  
);

always@(*) begin
    case(ALUOp)
        
        2'b00: ALUsel = 4'b0000;  
      
        2'b01: ALUsel = 4'b0001; 
        
       
        2'b10: begin
            if (inst25) begin  // MUL/DIV operations
                case(inst14_12)
                    3'b000: ALUsel = 4'b0000;  
                    3'b010: ALUsel = 4'b0000;  
                    3'b011: ALUsel = 4'b0000;  
                    3'b100: ALUsel = 4'b0001;  
                    3'b101: ALUsel = 4'b0001;  
                    3'b110: ALUsel = 4'b0011;  
                    3'b111: ALUsel = 4'b0011;  
                    default: ALUsel = 4'b0011;  
                endcase
            end
            else begin  // Standard arithmetic operations
                case(inst14_12)
                    3'b000: ALUsel = inst30 ? 4'b0001 : 4'b0000;  // ADD/SUB
                    3'b001: ALUsel = 4'b1000;  // SLL
                    3'b010: ALUsel = 4'b1101;  // SLT
                    3'b011: ALUsel = 4'b1111;  // SLTU
                    3'b100: ALUsel = 4'b0111;  // XOR
                    3'b101: ALUsel = inst30 ? 4'b1010 : 4'b1001;  // SRA/SRL
                    3'b110: ALUsel = 4'b0100;  // OR
                    3'b111: ALUsel = 4'b0101;  // AND
                    default: ALUsel = 4'b0011;  // Default to PASS
                endcase
            end
        end
        
        // U-type instructions (LUI, AUIPC)
        2'b11: begin
            case(inst14_12)
                3'b000: ALUsel = 4'b0010;  // LUI
                3'b001: ALUsel = 4'b0110;  // AUIPC
                default: ALUsel = 4'b0011;  // Default to PASS
            endcase
        end
        
        default: ALUsel = 4'b0011;  // Default to PASS
    endcase
end

endmodule
