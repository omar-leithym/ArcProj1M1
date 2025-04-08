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
                3'b000: ALUsel = inst30 ? 4'b0110 : 4'b0010;
                3'b111: ALUsel = 4'b0000;
                3'b110: ALUsel = 4'b0001;
                default: ALUsel = 4'b1111;
            endcase
        end
        default: ALUsel = 4'b1111;
    endcase
end

endmodule

