`include "defs.vh"
`include "timescale.vh"

// designed dependent to bus widths
module core (
    input rstn,
    input clk
);



wire [`IA_BITS-1 : 0] pc_curr;
wire [`IA_BITS-1 : 0] pc_next;
wire [`I_BITS-1 : 0] instr;

wire memRead;
wire memWrite;
wire memToReg;
wire regToReg;
wire aluEn;
wire S2Imm;
wire regWrite;
wire [2:0] op [2:0];

wire [`D_BITS-1 : 0] D;
wire [`D_BITS-1 : 0] S1;
wire [`D_BITS-1 : 0] S2reg;
wire [`D_BITS-1 : 0] S2;
wire [`D_BITS-1 : 0] resAlu;

wire [`A_BITS-1 : 0] addrRam;
wire [`D_BITS-1 : 0] wr_dataRam;
wire [`D_BITS-1 : 0] dataRam;
wire [`D_BITS-1 : 0] resMem;



pc #(
    .pc_width(`IA_BITS)
)pc0(
    .clk(clk),
    .pc_in(pc_next),
    .pc_out(pc_curr)
);

rom #(
    .pc_width(`IA_BITS),
    .instr_width(`I_BITS)
)rom0(
    .addr(pc_curr),
    .data(instr)
);

control control0(
    .instr(instr),
    .memRead(memRead),
    .memWrite(memWrite),
    .memToReg(memToReg),
    .regToReg(regToReg),
    .aluEn(aluEn),
    .S2Imm(S2Imm),
    .regWrite(regWrite),
    .op0(op[0]),
    .op1(op[1]),
    .op2(op[2])
);

registers_8regs #(
    .index_width(3),
    .reg_width(`D_BITS)
)registers0(
    .rstn(rstn),
    .clk(clk),
    .we(regWrite),
    .op0(op[0]),
    .op1(op[1]),
    .op2(op[2]),
    .D(D),
    .S1(S1),
    .S2(S2reg)
);

mux2hetero #(
    .data_width_in0out(`D_BITS),
    .data_width_in1(6)
) mux2hetero0(
    .in0(S2reg),
    .in1(instr[5:0]),
    .sel(S2Imm),
    .out(S2)
);

alu #(
    .data_width(`D_BITS)
)alu0(
    .S1(S1),
    .S2(S2),
    .en(aluEn),
    .func(instr[13:9]),
    .D(resAlu)
);

agu #(
    .pc_width(`IA_BITS),
    .addr_width(`A_BITS),
    .data_width(`D_BITS)
)agu0(
    .en(~aluEn),
    .func(instr[14:9]),
    .pc_in(pc_curr),
    .S1(S1),
    .S2(S2reg),
    .const(instr[7:0]),
    .pc_out(pc_next),
    .addr(addrRam),
    .wr_data(wr_dataRam)
);

sram #(
    .addr_width(`A_BITS),
    .data_width(`D_BITS)
)sram0(
    .en(memRead),
    .clk(clk),
    .we(memWrite),
    .addr(addrRam),
    .wr_data(wr_dataRam),
    .data(dataRam)
);

mux2 #(
    .data_width(`D_BITS)
)mux2_0(
    .in0(dataRam),
    .in1(wr_dataRam),
    .sel(regToReg),
    .out(resMem)
);

mux2 #(
    .data_width(`D_BITS)
)mux2_1(
    .in0(resAlu),
    .in1(resMem),
    .sel(memToReg),
    .out(D)
);

endmodule
