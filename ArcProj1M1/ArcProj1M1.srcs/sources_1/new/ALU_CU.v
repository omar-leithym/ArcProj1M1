module ALU_CU(
    input [2:0] inst14_12,  // funct3
    input [1:0] ALUOp,      // From Control Unit
    input inst30,           // funct7[5]
    output reg [3:0] ALUsel // ALU operation select
);
    // Initialize output
    initial begin
        ALUsel = 4'b0000;
    end

    always @(*) begin
        // Default value
        ALUsel = 4'b0000;
        
        case (ALUOp)
            // I-type arithmetic instructions
            2'b00: begin
                case (inst14_12)
                    3'b000: ALUsel = 4'b0000; // ADDI
                    3'b111: ALUsel = 4'b0101; // ANDI
                    3'b110: ALUsel = 4'b0100; // ORI
                    3'b100: ALUsel = 4'b0111; // XORI
                    3'b010: ALUsel = 4'b1101; // SLTI
                    3'b011: ALUsel = 4'b1111; // SLTIU
                    3'b001: ALUsel = 4'b1000; // SLLI
                    3'b101: ALUsel = inst30 ? 4'b1010 : 4'b1001; // SRAI/SRLI
                    default: ALUsel = 4'b0000;
                endcase
            end
            
            // Branch comparison
            2'b01: ALUsel = 4'b0001; // SUB for comparison
            
            // R-type or LUI
            2'b10: begin
                if (inst14_12 == 3'b000 && inst30)
                    ALUsel = 4'b0001; // SUB
                else if (inst14_12 == 3'b000)
                    ALUsel = 4'b0000; // ADD
                else if (inst14_12 == 3'b111)
                    ALUsel = 4'b0101; // AND
                else if (inst14_12 == 3'b110)
                    ALUsel = 4'b0100; // OR
                else if (inst14_12 == 3'b100)
                    ALUsel = 4'b0111; // XOR
                else if (inst14_12 == 3'b010)
                    ALUsel = 4'b1101; // SLT
                else if (inst14_12 == 3'b011)
                    ALUsel = 4'b1111; // SLTU
                else if (inst14_12 == 3'b001)
                    ALUsel = 4'b1000; // SLL
                else if (inst14_12 == 3'b101 && inst30)
                    ALUsel = 4'b1010; // SRA
                else if (inst14_12 == 3'b101)
                    ALUsel = 4'b1001; // SRL
                else
                    ALUsel = 4'b0010; // LUI
            end
            
            // AUIPC
            2'b11: ALUsel = 4'b0110;
            
            default: ALUsel = 4'b0000;
        endcase
    end
endmodule
