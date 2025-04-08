`timescale 1ns / 1ps
module ImmGen(
    input  [31:0] inst,
    output reg [31:0] gen_out
);
    // Quick approach: look at bits [6:5] to decide I/S/B type
    wire [1:0] opcode_two = inst[6:5];

    always @(*) begin
        case (opcode_two)
            2'b00: // I-type (like LW)
                gen_out = {{20{inst[31]}}, inst[31:20]};
            2'b01: // S-type (like SW)
                gen_out = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            2'b11: // B-type (like BEQ)
                gen_out = {{20{inst[31]}}, inst[31], inst[7],
                           inst[30:25], inst[11:8]};
            default:
                gen_out = 32'b0;
        endcase
    end
endmodule
