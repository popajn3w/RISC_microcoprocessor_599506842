//======== bus widths ===================//
`define A_BITS 16
`define D_BITS 32
`define I_BITS 16
`define IA_BITS 10

//======== registers ====================//
`define R0 3'b000
`define R1 3'b001
`define R2 3'b010
`define R3 3'b011
`define R4 3'b100
`define R5 3'b101
`define R6 3'b110
`define R7 3'b111

//=======================================//
//======== instr opcodes ================//
`define HALT 32'b0111_0010_0000_0000_0000_0000_0000_0000
`define NOP 32'b0111_0011_1111_1111_1111_1111_1111_1111
//======== arithmetico-logical ==========//
`define ADD 7'b0101_100
`define ADDF 7'b0101_101
`define SUB 7'b0101_110
`define SUBF 7'b0101_111
`define AND 7'b0110_000
`define OR 7'b0110_001
`define XOR 7'b0110_010
`define NAND 7'b0110_011
`define NOR 7'b0110_100
`define NXOR 7'b0110_101
`define SHIFTR 7'b0110_110
`define SHIFTRA 7'b0110_111
`define SHIFTL 7'b0111_000
//======== move =========================//
`define LOAD 5'b0100_0
`define STORE 5'b0100_1
`define LOADC 5'b0101_0
//======== jump =========================//
`define JMP 4'b0000
`define JMPR 4'b0001

`define JMPN 7'b0010_000
`define JMPNN 7'b0010_001
`define JMPZ 7'b0010_010
`define JMPNZ 7'b0010_011

`define JMPRN 7'b0011_000
`define JMPRNN 7'b0011_001
`define JMPRZ 7'b0011_010
`define JMPRNZ 7'b0011_011

