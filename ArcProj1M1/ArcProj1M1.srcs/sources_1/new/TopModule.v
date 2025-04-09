`timescale 1ns / 1ps

module TopModule(
    input clk, reset, SSDclk
    );
    // Fixed PC width consistency
    reg [7:0] PC_address; wire [7:0] PC_next;
    always @(posedge clk) begin
        if (reset) begin
            PC_address <= 8'h00;  // Initialize to 0 with correct width
        end else begin
            PC_address <= PC_next;
        end
    end
    
    wire [31:0] instruction;
    InstructionMemory instrMem(.addr(PC_address[7:2]), .data_out(instruction));

    // Control signals - match CU module definition
    wire Branch, MemRead, MemtoReg, memWrite, ALUSrc, RegWrite, FenceOp;
    wire [1:0] ALUOp;
    
    // Pass full 7-bit opcode to CU
    CU control(
        .instBits(instruction[6:0]),
        .Branch(Branch), 
        .MemRead(MemRead), 
        .MemtoReg(MemtoReg), 
        .ALUOp(ALUOp), 
        .MemWrite(memWrite), 
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .FenceOp(FenceOp)
    );

    wire [31:0] muxOutput2;
    wire [31:0] readData1, readData2;
    RegFile myReg(
        .read1(instruction[19:15]), 
        .read2(instruction[24:20]), 
        .write1(instruction[11:7]), 
        .writeData(muxOutput2), 
        .write(RegWrite), 
        .rst(reset), 
        .clk(clk), 
        .read1Output(readData1), 
        .read2Output(readData2)
    );
    
    wire [31:0] immediate;
    ImmGen immedGen(instruction, immediate);

    wire [3:0] ALUsel;
    ALU_CU AlUcontrol(
        .inst14_12(instruction[14:12]), 
        .ALUOp(ALUOp), 
        .inst30(instruction[30]), 
        .ALUsel(ALUsel)
    );
    
    wire [31:0] result; wire zeroFlag;
    wire [31:0] muxOutput1;
    
    // For AUIPC handling - check if LUI/AUIPC opcode (determined by ALUOp = 2'b10)
    // and use PC directly in the ALU when needed
    wire [31:0] aluInput1 = (instruction[6:2] == 5'b00101) ? {24'b0, PC_address} : readData1;
    
    // Existing mux for second ALU input
    NBitMux2x1 #(32) my32mux(
        .a(readData2), 
        .b(immediate), 
        .s(ALUSrc), 
        .c(muxOutput1)
    );

    // Connect all necessary ALU ports
    ALU ALUU(
        .a(aluInput1), 
        .b(muxOutput1), 
        .shamt(instruction[24:20]),
        .r(result),
        .zf(zeroFlag),
        .alufn(ALUsel)
    );
    
    wire [31:0]dataOut;
    DataMemory mem(
        .clk(clk), 
        .MemRead(MemRead & ~FenceOp),  // Modified for FENCE
        .MemWrite(memWrite & ~FenceOp), // Modified for FENCE
        .addr(result[7:2]),
        .data_in(readData2), 
        .data_out(dataOut)
    );
    
    NBitMux2x1 #(32) my32mux2(
        .a(result), 
        .b(dataOut), 
        .s(MemtoReg), 
        .c(muxOutput2)
    );

    wire [31:0] immShifted;
    NBitShiftLeft myShifter(
        .in(immediate), 
        .out(immShifted)
    );

    wire [7:0]branchPC; wire [7:0]PcIncrement;
    RCA #(8) myRCA32(
        .a(PC_address), 
        .b(immShifted[7:0]), 
        .cin(1'b0), 
        .sum(branchPC)
    );
    
    RCA #(8) myRCA32v2(
        .a(PC_address), 
        .b(8'd4), 
        .cin(1'b0), 
        .sum(PcIncrement)
    );
    
    wire selector;
    assign selector = Branch && zeroFlag;
    NBitMux2x1 #(8) my32mux3(
        .a(PcIncrement), 
        .b(branchPC), 
        .s(selector), 
        .c(PC_next)
    );

endmodule
