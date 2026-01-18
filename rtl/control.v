// designed dependent to bus widths
module control(
    input [15:0] instr,
    output reg memRead,
    output reg memWrite,
    output reg aluToReg,
    output reg constToReg,
    output reg aluEn,
    output reg halt,
    output reg S2Imm,
    output reg regWrite,
    output reg [2:0] op0,
    output reg [2:0] op1,
    output reg [2:0] op2
);

always @(*) begin

    memRead = 0;
    memWrite = 0;
    aluToReg = 1;
    constToReg = 0;
    aluEn = 1;
    halt = 0;
    S2Imm = 0;
    regWrite = 0;
    op0 = instr[8:6];
    op1 = instr[5:3];
    op2 = instr[2:0];

    case(instr[15:12])    // jump instruction group
        4'b0000: begin    // JMP op0
                     aluEn = 0;
                     op0 = instr[2:0];
                     op1 = instr[2:0];    // op0
                     op2 = instr[2:0];
                 end
        4'b0001: begin    // JMPR #offset
                     aluEn = 0;
                     op0 = instr[2:0];
                     op1 = instr[2:0];
                     op2 = instr[2:0];
                 end
        4'b0010: begin    // JMPcond op0 op1
                     aluEn = 0;
                     op0 = instr[8:6];
                     op1 = instr[8:6];    // op0
                     op2 = instr[2:0];    // op1
                 end
        4'b0011: begin    // JMPRcond op0 #offset
                     aluEn = 0;
                     op0 = instr[8:6];
                     op1 = instr[8:6];    // op0
                     op2 = instr[8:6];
                 end
    endcase

    case(instr[15:11])    // memory instructions
        5'b0100_0: begin    // LOAD op0 op1
                       memRead = 1;
                       aluToReg = 0;
                       aluEn = 0;
                       regWrite = 1;
                       op0 = instr[10:8];    // op0
                       op1 = instr[2:0];    // op1
                       op2 = instr[2:0];
                   end
        5'b0100_1: begin    // STORE op0 op1
                       memRead = 1;
                       memWrite = 1;
                       aluEn = 0;
                       op0 = instr[10:8];
                       op1 = instr[10:8];    // op0
                       op2 = instr[2:0];    // op1
                   end
        5'b0101_0: begin    // LOADC op0 const
                       aluToReg = 0;
                       constToReg = 1;
                       aluEn = 0;
                       regWrite = 1;
                       op0 = instr[10:8];
                       op1 = instr[10:8];
                       op2 = instr[10:8];
                   end
    endcase

    case(instr[15:9])    // alu instructions
        7'b0101_100,    // ADD op0 op1 op2
        7'b0101_101,    // ADDF2
        7'b0101_110,    // SUB
        7'b0101_111,    // SUBF2
        7'b0110_000,    // AND
        7'b0110_001,    // OR
        7'b0110_010,    // XOR
        7'b0110_011,    // NAND
        7'b0110_100,    // NOR
        7'b0110_101: begin    // NXOR op0 op1 op2
                         aluEn = 1;
                         S2Imm = 0;
                         regWrite = 1;
                         op0 = instr[8:6];
                         op1 = instr[5:3];
                         op2 = instr[2:0];
                     end
        7'b0110_110,    // SHIFTR op0 #val
        7'b0110_111,    // SHIFTRA op0 #val
        7'b0111_000: begin    // SHIFTL op0 #val
                         aluEn = 1;
                         S2Imm = 1;
                         regWrite = 1;
                         op0 = instr[8:6];
                         op1 = instr[8:6];    // |
                         op2 = instr[8:6];    // | not used
                     end
    endcase

    case(instr)
        32'b0111_0010_0000_0000_0000_0000_0000_0000: aluEn= 0;    // NOP
        32'b0111_0011_1111_1111_1111_1111_1111_1111: begin
                                                         aluEn= 0;
                                                         halt = 1;    // HALT
                                                     end
    endcase
end

endmodule 
