`include "defs.vh"

module id_ex_stage #(
    parameter pc_width = 10,
    parameter func_width = 6,
    parameter const_width = 8,
    parameter index_width = 3,
    parameter reg_width = 32
)(
    input      clk,
    input      [pc_width-1 : 0] pc_curr_id,
    output reg [pc_width-1 : 0] pc_curr_ex,
    input      [func_width-1 : 0] func_id,
    output reg [func_width-1 : 0] func_ex,
    input      [const_width-1 : 0] const_id,
    output reg [const_width-1 : 0] const_ex,
    input      memRead_id,
    output reg memRead_ex,
    input      memWrite_id,
    output reg memWrite_ex,
    input      aluToReg_id,
    output reg aluToReg_ex,
    input      constToReg_id,
    output reg constToReg_ex,
    input      aluEn_id,
    output reg aluEn_ex,
    input      halt_id,
    output reg halt_ex,
    input      regWrite_id,
    output reg regWrite_ex,
    input      [index_width-1 : 0] op0_id,
    output reg [index_width-1 : 0] op0_ex,
    input      [reg_width-1 : 0] S1_id,
    output reg [reg_width-1 : 0] S1_ex,
    input      [reg_width-1 : 0] S2_id,
    output reg [reg_width-1 : 0] S2_ex
);

always @(posedge clk) begin
    pc_curr_ex    <= pc_curr_id;
    func_ex       <= func_id;
    const_ex      <= const_id;
    memRead_ex    <= memRead_id;
    memWrite_ex   <= memWrite_id;
    aluToReg_ex   <= aluToReg_id;
    constToReg_ex <= constToReg_id;
    aluEn_ex      <= aluEn_id;
    halt_ex       <= halt_id;
    regWrite_ex   <= regWrite_id;
    op0_ex        <= op0_id;
    S1_ex         <= S1_id;
    S2_ex         <= S2_id;
end

endmodule
