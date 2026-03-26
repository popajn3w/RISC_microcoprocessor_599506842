`include "defs.vh"

module ex_wb_stage #(
    parameter pc_width = 10,
    parameter index_width = 3,
    parameter reg_width = 32
)(
    input      clk,
    input      rstn,
    input      [pc_width-1 : 0] pc_next_ex,
    output reg [pc_width-1 : 0] pc_next_wb,
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
    input      [7 : 0] dataConst_ex,
    output reg [7 : 0] dataConst_wb
);

always @(posedge clk) begin
    pc_next_wb    <= (rstn) ? pc_next_ex    : 4;
    aluToReg_wb   <= (rstn) ? aluToReg_ex   : 1;
    constToReg_wb <= (rstn) ? constToReg_ex : 0;
    regWrite_wb   <= (rstn) ? regWrite_ex   : 0;
    op0_wb        <= (rstn) ? op0_ex        : 0;
    resAlu_wb     <= (rstn) ? resAlu_ex     : 0;
    dataConst_wb  <= (rstn) ? dataConst_ex  : 0;
end

endmodule
