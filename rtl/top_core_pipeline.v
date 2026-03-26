`include "defs.vh"

module top_core_pipeline (
    input rstn,
    input clk
);

wire [`IA_BITS-1 : 0] pc_curr_if;
wire [`I_BITS-1 : 0] instr_rom_id;
wire memRead_ex;
wire memWrite_ex;
wire [`A_BITS-1 : 0] addrRam_ex;
wire [`D_BITS-1 : 0] wr_dataRam_ex;
wire [`D_BITS-1 : 0] dataRam_wb;


core_pipeline core_pipeline0(
    .rstn(rstn),
    .clk(clk),
    .pc_curr_if(pc_curr_if),
    .instr_rom_id(instr_rom_id),
    .memRead_ex(memRead_ex),
    .memWrite_ex(memWrite_ex),
    .addrRam_ex(addrRam_ex),
    .wr_dataRam_ex(wr_dataRam_ex),
    .dataRam_wb(dataRam_wb)
);

rom #(    // IF/ID stage
    .pc_width(`IA_BITS),
    .instr_width(`I_BITS)
)rom0(
    .clk(clk),
    .addr(pc_curr_if),
    .data(instr_rom_id)
);

sram #(    // EX/WB stage: read+write
    .addr_width(`A_BITS),
    .data_width(`D_BITS)
)sram0(
    .en(memRead_ex),
    .clk(clk),
    .we(memWrite_ex),
    .addr(addrRam_ex),
    .wr_data(wr_dataRam_ex),
    .data(dataRam_wb)
);

endmodule
