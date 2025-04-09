`timescale 1ns / 1ps
module NBitShiftLeft #(parameter N=32) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    assign out = in << 1;
endmodule
