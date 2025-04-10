module ALU(
    input   wire [31:0] a, b,
    input   wire [4:0]  shamt,
    output  reg  [31:0] r,
    output  wire        zf, cf, vf, sf,
    input   wire [3:0]  alufn
);
    wire [31:0] add;
    wire [31:0] op_b;
    wire carry;
    
    // For addition/subtraction
    assign op_b = (alufn[0]) ? ~b : b;
    assign {carry, add} = a + op_b + (alufn[0] ? 1'b1 : 1'b0);
    
    // Shift operations
    wire [31:0] shift_left, shift_right, shift_right_arith;
    assign shift_left = a << shamt;
    assign shift_right = a >> shamt;
    assign shift_right_arith = $signed(a) >>> shamt;
    
    // Shift operation selection
    reg [31:0] sh;
    always @(*) begin
        case (alufn[1:0])
            2'b00: sh = shift_left;
            2'b01: sh = shift_right;
            2'b10: sh = shift_right_arith;
            default: sh = 32'b0;
        endcase
    end
    
    // ALU operations
    always @(*) begin
        r = 32'b0; // Default value
        case (alufn)
            // arithmetic
            4'b0000 : r = add;              // ADD, ADDI
            4'b0001 : r = add;              // SUB
            4'b0011 : r = b;                // PASS B
            // logic
            4'b0100 : r = a | b;            // OR, ORI
            4'b0101 : r = a & b;            // AND, ANDI
            4'b0111 : r = a ^ b;            // XOR, XORI
            // shift
            4'b1000 : r = sh;               // SLL
            4'b1001 : r = sh;               // SRL
            4'b1010 : r = sh;               // SRA
            // slt & sltu
            4'b1101 : r = {31'b0,(sf != vf)}; // SLT, SLTI
            4'b1111 : r = {31'b0,(~cf)};      // SLTU, SLTIU
            // additional operations for LUI and AUIPC
            4'b0010 : r = {b[19:0], 12'b0};   // LUI
            4'b0110 : r = a + b;              // AUIPC
            // default case
            default : r = 32'b0;
        endcase
    end
    
    // Flag calculations
    assign zf = (r == 32'b0);
    assign sf = r[31];
    assign cf = alufn[0] ? ~carry : carry;
    assign vf = (a[31] ^ op_b[31]) & (a[31] ^ add[31]);
endmodule
