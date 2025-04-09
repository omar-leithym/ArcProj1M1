`timescale 1ns / 1ps
module NBitMux2x1 #(parameter N=8) (
    input wire [N-1:0] a, 
    input wire [N-1:0] b,
    input wire s,
    output wire [N-1:0] c
);
    genvar i;
    generate 
        for (i=0; i < N; i=i+1) begin
            mux2x1 myMux(
                .a(a[i]), 
                .b(b[i]), 
                .s(s), 
                .c(c[i])
            );
        end
    endgenerate
endmodule
