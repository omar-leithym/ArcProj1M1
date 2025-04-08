`timescale 1ns / 1ps
module NBitMux2x1 #(parameter N=8) (
    input wire [N-1:0] A, 
    input wire [N-1:0] B,
    input wire S,
    output wire [N-1:0] C
);
    genvar i;
    generate 
        for (i=0; i < N; i=i+1) begin
            mux2x1 myMux(
                .A(A[i]), 
                .B(B[i]), 
                .S(S), 
                .C(C[i])
            );
        end
    endgenerate
endmodule
