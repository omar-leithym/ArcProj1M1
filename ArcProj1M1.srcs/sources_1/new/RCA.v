`timescale 1ns / 1ps
module RCA #(parameter n=32)(
    input  [n-1:0] x, 
    input  [n-1:0] y,
    input          cin,
    output [n-1:0] sum,
    output         cout
);
    // Simple assign-based addition. If you want a structural ripple-carry,
    // you can expand it. This is good enough for your pipeline.
    assign {cout, sum} = x + y + cin;
endmodule
