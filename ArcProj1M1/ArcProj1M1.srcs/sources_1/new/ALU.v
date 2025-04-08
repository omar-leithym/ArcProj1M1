`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2025 02:10:18 AM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 11:56:45 AM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU #(parameter N=8)(
        input [N-1:0] A, [N-1:0] B, [3:0] ALUsel, output reg [N-1:0] result, output zeroFlag 
    );
    wire [N-1:0] resultWire;
    reg [N-1:0] Awire, Bwire;
    reg cin;
    
    RCA #(N) myRCA (Awire, Bwire, cin, resultWire);
    always @ (*) begin
       if(ALUsel == 4'b0010) begin
           Awire = A;
           Bwire = B;
           cin = 1'b0;
           result = resultWire;
       end 
       if(ALUsel == 4'b0110) begin
           Awire = A;
           Bwire = ~B;
           cin = 1'b1;
           result = resultWire;
       end
       if(ALUsel == 4'b0000) begin
           result = A & B;
       end
       if(ALUsel == 4'b0001) begin
           result = A | B;
       end
    end
    assign zeroFlag = result == 0;
endmodule

