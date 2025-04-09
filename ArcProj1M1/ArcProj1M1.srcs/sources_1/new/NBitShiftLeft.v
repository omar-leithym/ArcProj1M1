`timescale 1ns / 1ps
module NBitShiftLeft(
    input  wire [31:0] in,           
    input  wire [31:0] a,            
    input  wire [4:0]  shamt,        
    input  wire [1:0]  type,         
    output wire [31:0] out,         
    output reg  [31:0] r             
);
    
    assign out = in << 1;
    
    wire signed [31:0] signed_a = $signed(a);
    
    always @ (*) begin
        case(type)
            2'b00: r = a << shamt;                  
            2'b01: r = a >> shamt;                  
            2'b10: r = $signed(signed_a) >>> shamt; 
            default: r = a;
        endcase
    end

endmodule
