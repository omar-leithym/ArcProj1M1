`timescale 1ns / 1ps

module TopModule(
    input clk, reset, SSDclk
    );
    reg [7:0] PC_address; wire [5:0] PC_next;
    always @(posedge clk) begin
        if (reset) begin
            PC_address <= 6'h00;  
        end else begin
            PC_address <= PC_next;
        end
    end
    wire [31:0] instruction;
    InstructionMemory instrMem(.addr(PC_address[7:2]), .data_out(instruction));

    wire Branch, MemRead, MemtoReg; wire [1:0] ALUOp; wire memWrite, ALUSrc, RegWrite;
    CU control(instruction[6:2], Branch, MemRead, MemtoReg, ALUOp, memWrite, ALUSrc, RegWrite);

    wire [31:0] muxOutput2;
    wire [31:0] readData1, readData2;
    RegFile myReg(.read1(instruction[19:15]), .read2(instruction[24:20]), .write1(instruction[11:7]), .writeData(muxOutput2), .write(RegWrite), .rst(reset), .clk(clk), .read1Output(readData1), .read2Output(readData2));
    
    
    wire [31:0] immediate;
    ImmGen immedGen(instruction, immediate);

    wire [3:0] ALUsel;
    ALU_CU AlUcontrol(instruction[14:12] ,ALUOp, instruction[30], ALUsel);
    
    wire [31:0] result; wire zeroFlag;
    wire [31:0] muxOutput1;
    NBitMux2x1 #(32) my32mux( readData2, immediate, ALUSrc, muxOutput1);

    ALU#(32) ALUU(readData1, muxOutput1, ALUsel, result, zeroFlag);
    
    wire [31:0]dataOut;
    DataMemory mem(clk, MemRead, memWrite, result[7:2] ,readData2, dataOut);
    
    NBitMux2x1 #(32) my32mux2( result, dataOut, MemtoReg, muxOutput2);

    wire [31:0] immShifted;
    NBitShiftLeft #(32) myShifter(immediate, immShifted);

    wire [5:0]branchPC; wire [5:0]PcIncrement;
    RCA #(6) myRCA32 (PC_address , immShifted[5:0], 1'b0, branchPC);
    
    RCA #(6) myRCA32v2 (PC_address , 6'd4, 1'b0, PcIncrement);
    wire selector;
    assign selector = Branch && zeroFlag;
    NBitMux2x1 #(8) my32mux3( PcIncrement, branchPC, selector, PC_next);

endmodule
