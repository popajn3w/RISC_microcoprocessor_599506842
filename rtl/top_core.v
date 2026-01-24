`include "defs.vh"

module top_core (
    input rstn,
    input clk
);

wire [`I_BITS-1 : 0] instr;
wire [`IA_BITS-1 : 0] pc_curr;
wire memRead;
wire memWrite;
wire [`A_BITS-1 : 0] addrRam;
wire [`D_BITS-1 : 0] wr_dataRam;
wire [`D_BITS-1 : 0] dataRam;


core core0(
    .rstn(rstn),
    .clk(clk),
    .instr(instr),
    .pc_curr(pc_curr),
    .memRead(memRead),
    .memWrite(memWrite),
    .addrRam(addrRam),
    .wr_dataRam(wr_dataRam),
    .dataRam(dataRam)
);

rom #(
    .pc_width(`IA_BITS),
    .instr_width(`I_BITS)
)rom0(
    .addr(pc_curr),
    .data(instr)
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

endmodule
