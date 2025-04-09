`timescale 1ns / 1ps
module ALU_CU(
    input [2:0] inst14_12,
    input [1:0] ALUOp,
    input inst30,
    output reg [3:0] ALUsel
);

always@(*) begin
    case(ALUOp)
        2'b00: ALUsel = 4'b0010;
        2'b01: ALUsel = 4'b0110;
        2'b10: begin
            case(inst14_12)
                3'b000: ALUsel = inst30 ? 4'b0110 : 4'b0010; // 000: ADD (if inst30==0) or SUB (if inst30==1)
                3'b001: ALUsel = 4'b1000;                     // 001: SLL
                3'b010: ALUsel = 4'b1011;                     // 010: SLT (signed)
                3'b011: ALUsel = 4'b1100;                     // 011: SLTU (unsigned)
                3'b100: ALUsel = 4'b0100;                     // 100: XOR
                3'b101: ALUsel = inst30 ? 4'b1010 : 4'b1001;    // 101: SRL (if inst30==0) or SRA (if inst30==1)
                3'b110: ALUsel = 4'b0001;                     // 110: OR
                3'b111: ALUsel = 4'b0000;                     // 111: AND
                default: ALUsel = 4'b1111;
            endcase
        end
        default: ALUsel = 4'b1111;
    endcase
end

endmodule
