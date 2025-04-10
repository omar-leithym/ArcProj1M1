module CU(
    input [6:0] instBits,       
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg FenceOp
);
    
    initial begin
        Branch = 1'b0;
        MemRead = 1'b0;
        MemtoReg = 1'b0;
        ALUOp = 2'b00;
        MemWrite = 1'b0;
        ALUSrc = 1'b0;
        RegWrite = 1'b0;
        FenceOp = 1'b0;
    end

    always @(*) begin
       
        Branch = 1'b0;
        MemRead = 1'b0;
        MemtoReg = 1'b0;
        ALUOp = 2'b00;
        MemWrite = 1'b0;
        ALUSrc = 1'b0;
        RegWrite = 1'b0;
        FenceOp = 1'b0;
        
        case (instBits)
            // R-type instructions 
            7'b0110011: begin
                RegWrite = 1'b1;
                ALUOp = 2'b10;
            end

            // I-type arithmetic instructions 
            7'b0010011: begin
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 2'b00;
            end

            // LUI (Load Upper Immediate)
            7'b0110111: begin
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 2'b10;
            end

            // AUIPC 
            7'b0010111: begin
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 2'b11;
            end

            // Load instructions
            7'b0000011: begin
                MemRead = 1'b1;
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                MemtoReg = 1'b1;
            end

            // Store instructions
            7'b0100011: begin
                MemWrite = 1'b1;
                ALUSrc = 1'b1;
            end

            // Branch instructions
            7'b1100011: begin
                Branch = 1'b1;
                ALUOp = 2'b01;
            end

            // FENCE instruction
            7'b0001111: begin
                FenceOp = 1'b1;
            end

            // Default case - NOP
            default: begin
                // All signals already set to default
            end
        endcase
    end
endmodule
