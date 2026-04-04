`include "defs.vh"

module core_pipeline(
    input rstn,
    input clk,
    input halt_ext,
    output wire [`IA_BITS-1 : 0] pc_curr_if,
    input wire [`I_BITS-1 : 0] instr_rom_id,
    output wire memRead_ex,
    output wire memWrite_ex,
    output wire [`A_BITS-1 : 0] addrRam_ex,
    output wire [`D_BITS-1 : 0] wr_dataRam_ex,
    input wire [`D_BITS-1 : 0] dataRam_wb
);

wire [`IA_BITS-1 : 0] pc_curr_id;
wire [`IA_BITS-1 : 0] pc_curr_ex;
wire [`IA_BITS-1 : 0] pc_next_ex;
wire [`IA_BITS-1 : 0] pc_next_wb;
wire [`I_BITS-1 : 0] instr_id_run;    // non-halt_ext
reg  [`I_BITS-1 : 0] last_instr_id;
wire [`I_BITS-1 : 0] instr_id;
wire [7:0] const_ex;
wire [5:0] func_ex;
wire isPipeLoading_id;
wire isPipeLoading_ex;
wire isJmp_ex;
wire isJmp_wb;
reg rstn_seq;
reg halt_ext_seq;

wire memRead_id;
wire memWrite_id;
wire aluToReg_id;
wire aluToReg_ex;
wire aluToReg_wb;
wire constToReg_id;
wire constToReg_ex;
wire constToReg_wb;
wire aluEn_id;
wire aluEn_ex;
wire halt_instr_id;
wire halt_instr_ex;
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

wire [        7 : 0] dataConst_wb;
wire [`D_BITS-1 : 0] resMem_wb;


wb_if_stage #(
    .pc_width(`IA_BITS)
)wb_if_stage0(
    .clk(clk),
    .rstn(rstn),
    .halt_ext(halt_ext),
    .pc_wb(pc_next_wb),
    .pc_if(pc_curr_if)    // the "base" PC register
);

always @(posedge clk)  rstn_seq <= rstn;
assign instr_id_run = (rstn_seq && !isJmp_wb) ? instr_rom_id : `NOP;

if_id_stage #(
    .pc_width(`IA_BITS),
    .instr_width(`I_BITS)
)if_id_stage0(
    .clk(clk),
    .rstn(rstn),
    .halt_ext(halt_ext),
    .isJmp(isJmp_wb),
    .pc_next(pc_next_wb),
    .isPipeLoading_id(isPipeLoading_id),
    .pc_curr_if(pc_curr_if),
    .pc_curr_id(pc_curr_id)
);

always @(posedge clk) begin    // IF/ID stage
    last_instr_id <= halt_ext_seq ? last_instr_id : instr_id_run;
    halt_ext_seq  <= halt_ext;
end
assign instr_id = halt_ext_seq ? last_instr_id : instr_id_run;    // ID stage

control control0(    // ID stage
    .instr(instr_id),
    .memRead(memRead_id),
    .memWrite(memWrite_id),
    .aluToReg(aluToReg_id),
    .constToReg(constToReg_id),
    .aluEn(aluEn_id),
    .halt(halt_instr_id),
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
    .rstn(rstn),
    .halt_ext(halt_ext),
    .isJmp(isJmp_wb),
    .pc_next(pc_next_wb),
    .isPipeLoading_id(isPipeLoading_id),
    .isPipeLoading_ex(isPipeLoading_ex),
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
    .halt_instr_id(halt_instr_id),
    .halt_instr_ex(halt_instr_ex),
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
    .data_width(`D_BITS),
    .pc_step(4)
)agu0(
    .halt(halt_instr_ex),
    .en(~aluEn_ex),
    .isPipeLoading(isPipeLoading_ex),
    .func(func_ex),
    .pc_in(pc_curr_ex),
    .S1(S1_ex),
    .S2(S2_ex),
    .const(const_ex),
    .isJmp(isJmp_ex),
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
    .reg_width(`D_BITS)
)ex_wb_stage0(
    .clk(clk),
    .rstn(rstn),
    .halt_ext(halt_ext),
    .isJmp_ex(isJmp_ex),
    .isJmp_wb(isJmp_wb),
    .pc_next_ex(pc_next_ex),
    .pc_next_wb(pc_next_wb),
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
    .dataConst_ex(wr_dataRam_ex[7:0]),
    .dataConst_wb(dataConst_wb)
);

mux2hetero #(    // WB stage
    .data_width_in0out(`D_BITS),
    .data_width_in1(8)
)mux2hetero_1(
    .in0(dataRam_wb),
    .in1(dataConst_wb),
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
