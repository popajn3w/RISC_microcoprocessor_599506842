`include "defs.vh"

module top_core_pipeline (
    input rstn,
    input clk
);

wire [`IA_BITS-1 : 0] pc_curr_if;
wire [`I_BITS-1 : 0] instr_if;
wire memRead_wb;
wire memWrite_wb;
wire [`A_BITS-1 : 0] addrRam_wb;
wire [`D_BITS-1 : 0] wr_dataRam_wb;
wire [`D_BITS-1 : 0] dataRam_wb;


core_pipeline core_pipeline0(
    .rstn(rstn),
    .clk(clk),
    .pc_curr_if(pc_curr_if),
    .instr_if(instr_if),
    .memRead_wb(memRead_wb),
    .memWrite_wb(memWrite_wb),
    .addrRam_wb(addrRam_wb),
    .wr_dataRam_wb(wr_dataRam_wb),
    .dataRam_wb(dataRam_wb)
);

rom #(    // IF stage
    .pc_width(`IA_BITS),
    .instr_width(`I_BITS)
)rom0(
    .addr(pc_curr_if),
    .data(instr_if)
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

endmodule
