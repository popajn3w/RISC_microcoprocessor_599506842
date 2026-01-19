`include "defs.vh"

module ex_wb_stage #(
    parameter pc_width = 10,
    parameter index_width = 3,
    parameter reg_width = 32,
    parameter addr_width = 10,
    parameter data_width = 32
)(
    input      clk,
    input      [pc_width-1 : 0] pc_next_ex,
    output reg [pc_width-1 : 0] pc_next_wb,
    input      memRead_ex,
    output reg memRead_wb,
    input      memWrite_ex,
    output reg memWrite_wb,
    input      aluToReg_ex,
    output reg aluToReg_wb,
    input      constToReg_ex,
    output reg constToReg_wb,
    input      regWrite_ex,
    output reg regWrite_wb,
    input      [index_width-1 : 0] op0_ex,
    output reg [index_width-1 : 0] op0_wb,
    input      [reg_width-1 : 0] resAlu_ex,
    output reg [reg_width-1 : 0] resAlu_wb,
    input      [addr_width-1 : 0] addrRam_ex,
    output reg [addr_width-1 : 0] addrRam_wb,
    input      [data_width-1 : 0] wr_dataRam_ex,
    output reg [data_width-1 : 0] wr_dataRam_wb
);

always @(posedge clk) begin
    pc_next_wb    <= pc_next_ex;
    memRead_wb    <= memRead_ex;
    memWrite_wb   <= memWrite_ex;
    aluToReg_wb   <= aluToReg_ex;
    constToReg_wb <= constToReg_ex;
    regWrite_wb   <= regWrite_ex;
    op0_wb        <= op0_ex;
    resAlu_wb     <= resAlu_ex;
    addrRam_wb    <= addrRam_ex;
    wr_dataRam_wb <= wr_dataRam_ex;
end

endmodule
