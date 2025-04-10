    module InstructionMemory(
        input [5:0] addr,
        output reg [31:0] data_out
    );
        
        reg [31:0] memory [0:63];
        
        integer i;
        
        initial begin
           
            //  ADDI x1, x0, 10 (
            memory[0] = 32'h00A00093;
            
            // ANDI x2, x1, 15  
            memory[1] = 32'h00F0F113;
            
            // ORI x3, x1, 5 )
            memory[2] = 32'h0050E193;
            
            // XORI x4, x1, 7 
            memory[3] = 32'h0070C213;
            
            // SLTI x5, x1, 20 
            memory[4] = 32'h0140A293;
            
            // SLTIU x6, x1, 5 
            memory[5] = 32'h0050B313;
            
            // LUI x7, 0x12345 (
            memory[6] = 32'h123453B7;
            
            //  AUIPC x8, 0x800 
            memory[7] = 32'h00800417;
            
            // FENCE
            memory[8] = 32'h0000F00F;
            
            // Continue after FENCE
            memory[9] = 32'h00C00093; // ADDI x1, x0, 12
            
            // F NOPs
            for (i=10; i<64; i=i+1) begin
                memory[i] = 32'h00000013; // NOP (ADDI x0, x0, 0)
            end
        end
        
        always @(*)
            data_out = memory[addr];
    endmodule
