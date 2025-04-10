    module ImmGen (
        input  wire [31:0]  IR,
        output reg  [31:0]  Imm
    );
    
    always @(*) begin
        case (IR[6:0]) 
            7'b0010011: Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] };           // I-type 
            7'b0100011: Imm = { {21{IR[31]}}, IR[30:25], IR[11:8], IR[7] };             // S-type 
            7'b0110111: Imm = { IR[31], IR[30:20], IR[19:12], 12'b0 };                  // U-type 
            7'b0010111: Imm = { IR[31], IR[30:20], IR[19:12], 12'b0 };                  // U-type 
            7'b1101111: Imm = { {12{IR[31]}}, IR[19:12], IR[20], IR[30:25], IR[24:21], 1'b0 }; // J-type 
            7'b1100111: Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] };           // I-type (
            7'b1100011: Imm = { {20{IR[31]}}, IR[7], IR[30:25], IR[11:8], 1'b0};        // B-type 
            7'b0001111: Imm = { 27'b0, IR[31:28], 1'b0 };                               // FENCE 
            default   : Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] };   
                    // Default to I-type
        endcase 
    end
    
    endmodule
