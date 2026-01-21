`include "defs.vh"
`include "timescale.vh"

module core_pipeline(
    input rstn,
    input clk
);

wire [`IA_BITS-1 : 0] pc_curr_if;
wire [`IA_BITS-1 : 0] pc_curr_id;
wire [`IA_BITS-1 : 0] pc_curr_ex;
wire [`IA_BITS-1 : 0] pc_next_ex;
wire [`IA_BITS-1 : 0] pc_next_wb;
wire [`I_BITS-1 : 0] instr_if;
wire [`I_BITS-1 : 0] instr_id;
wire [7:0] const_ex;
wire [5:0] func_ex;

wire memRead_id;
wire memRead_ex;
wire memRead_wb;
wire memWrite_id;
wire memWrite_ex;
wire memWrite_wb;
wire aluToReg_id;
wire aluToReg_ex;
wire aluToReg_wb;
wire constToReg_id;
wire constToReg_ex;
wire constToReg_wb;
wire aluEn_id;
wire aluEn_ex;
wire halt_id;
wire halt_ex;
wire S2Imm_id;
wire regWrite_id;
wire regWrite_ex;
wire regWrite_wb;
wire [2:0] op0_id;
wire [2:0] op0_ex;
wire [2:0] op0_wb;
wire [2:0] op1_id;
wire [2:0] op2_id;

wire [`D_BITS-1 : 0] D_wb;
wire [`D_BITS-1 : 0] S1_id;
wire [`D_BITS-1 : 0] S1_ex;
wire [`D_BITS-1 : 0] S2reg_id;
wire [`D_BITS-1 : 0] S2_id;
wire [`D_BITS-1 : 0] S2_ex;
wire [`D_BITS-1 : 0] resAlu_ex;
wire [`D_BITS-1 : 0] resAlu_wb;

wire [`A_BITS-1 : 0] addrRam_ex;
wire [`A_BITS-1 : 0] addrRam_wb;
wire [`D_BITS-1 : 0] wr_dataRam_ex;
wire [`D_BITS-1 : 0] wr_dataRam_wb;
wire [`D_BITS-1 : 0] dataRam_wb;
wire [`D_BITS-1 : 0] resMem_wb;


wb_if_stage #(
    .pc_width(`IA_BITS)
)wb_if_stage0(
    .clk(clk),
    .pc_wb(pc_next_wb),
    .pc_if(pc_curr_if)    // the "base" PC register
);

rom #(    // IF stage
    .pc_width(`IA_BITS),
    .instr_width(`I_BITS)
)rom0(
    .addr(pc_curr_if),
    .data(instr_if)
);

if_id_stage #(
    .pc_width(`IA_BITS),
    .instr_width(`I_BITS)
)if_id_stage0(
    .clk(clk),
    .pc_curr_if(pc_curr_if),
    .pc_curr_id(pc_curr_id),
    .instr_if(instr_if),
    .instr_id(instr_id)
);

control control0(    // ID stage
    .instr(instr_id),
    .memRead(memRead_id),
    .memWrite(memWrite_id),
    .aluToReg(aluToReg_id),
    .constToReg(constToReg_id),
    .aluEn(aluEn_id),
    .halt(halt_id),
    .S2Imm(S2Imm_id),
    .regWrite(regWrite_id),
    .op0(op0_id),
    .op1(op1_id),
    .op2(op2_id)
);

register_file #(    // ID stage: read;  WB/IF stage: write
    .index_width(3),
    .reg_width(`D_BITS)
)register_file0(
    .rstn(rstn),
    .clk(clk),
    .we(regWrite_wb),
    .op0(op0_wb),    // R[op0]=Rd
    .op1(op1_id),    // R[op1]=s1
    .op2(op2_id),    // R[op2]=s2
    .D(D_wb),
    .S1(S1_id),
    .S2(S2reg_id)
);

mux2hetero #(    // ID stage
    .data_width_in0out(`D_BITS),
    .data_width_in1(6)
)mux2hetero0(
    .in0(S2reg_id),
    .in1(instr_id[5:0]),
    .sel(S2Imm_id),
    .out(S2_id)
);

id_ex_stage #(
    .pc_width(`IA_BITS),
    .func_width(6),
    .const_width(8),
    .index_width(3),
    .reg_width(`D_BITS)
)id_ex_stage0(
    .clk(clk),
    .pc_curr_id(pc_curr_id),
    .pc_curr_ex(pc_curr_ex),
    .func_id(instr_id[14:9]),
    .func_ex(func_ex),
    .const_id(instr_id[7:0]),
    .const_ex(const_ex),
    .memRead_id(memRead_id),
    .memRead_ex(memRead_ex),
    .memWrite_id(memWrite_id),
    .memWrite_ex(memWrite_ex),
    .aluToReg_id(aluToReg_id),
    .aluToReg_ex(aluToReg_ex),
    .constToReg_id(constToReg_id),
    .constToReg_ex(constToReg_ex),
    .aluEn_id(aluEn_id),
    .aluEn_ex(aluEn_ex),
    .halt_id(halt_id),
    .halt_ex(halt_ex),
    .regWrite_id(regWrite_id),
    .regWrite_ex(regWrite_ex),
    .op0_id(op0_id),
    .op0_ex(op0_ex),
    .S1_id(S1_id),
    .S1_ex(S1_ex),
    .S2_id(S2_id),
    .S2_ex(S2_ex)
);

agu #(    // EX stage
    .pc_width(`IA_BITS),
    .addr_width(`A_BITS),
    .data_width(`D_BITS)
)agu0(
    .halt(halt_ex),
    .en(~aluEn_ex),
    .func(func_ex),
    .pc_in(pc_curr_ex),
    .S1(S1_ex),
    .S2(S2_ex),
    .const(const_ex),
    .pc_out(pc_next_ex),
    .addr(addrRam_ex),
    .wr_data(wr_dataRam_ex)
);

alu #(
    .data_width(`D_BITS)
)alu0(    // EX stage
    .S1(S1_ex),
    .S2(S2_ex),
    .en(aluEn_ex),
    .func(func_ex[4:0]),
    .D(resAlu_ex)
);

ex_wb_stage #(
    .pc_width(`IA_BITS),
    .index_width(3),
    .reg_width(`D_BITS),
    .addr_width(`A_BITS),
    .data_width(`D_BITS)
)ex_wb_stage0(
    .clk(clk),
    .pc_next_ex(pc_next_ex),
    .pc_next_wb(pc_next_wb),
    .memRead_ex(memRead_ex),
    .memRead_wb(memRead_wb),
    .memWrite_ex(memWrite_ex),
    .memWrite_wb(memWrite_wb),
    .aluToReg_ex(aluToReg_ex),
    .aluToReg_wb(aluToReg_wb),
    .constToReg_ex(constToReg_ex),
    .constToReg_wb(constToReg_wb),
    .regWrite_ex(regWrite_ex),
    .regWrite_wb(regWrite_wb),
    .op0_ex(op0_ex),
    .op0_wb(op0_wb),
    .resAlu_ex(resAlu_ex),
    .resAlu_wb(resAlu_wb),
    .addrRam_ex(addrRam_ex),
    .addrRam_wb(addrRam_wb),
    .wr_dataRam_ex(wr_dataRam_ex),
    .wr_dataRam_wb(wr_dataRam_wb)
);

sram #(    // WB stage: read;  WB/IF stage: write
    .addr_width(`A_BITS),
    .data_width(`D_BITS)
)sram0(
    .en(memRead_wb),
    .clk(clk),
    .we(memWrite_wb),
    .addr(addrRam_wb),
    .wr_data(wr_dataRam_wb),
    .data(dataRam_wb)
);

mux2 #(    // WB stage
    .data_width(`D_BITS)
)mux2_1(
    .in0(dataRam_wb),
    .in1(wr_dataRam_wb),
    .sel(constToReg_wb),
    .out(resMem_wb)
);

mux2 #(    // WB stage
    .data_width(`D_BITS)
)mux2_0(
    .in0(resMem_wb),
    .in1(resAlu_wb),
    .sel(aluToReg_wb),
    .out(D_wb)
);


endmodule
