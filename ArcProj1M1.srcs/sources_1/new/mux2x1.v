`timescale 1ns / 1ps
module mux2x1(
    input wire A, B, S,
    output wire C
    );
        assign C = S ? B : A;
endmodule

