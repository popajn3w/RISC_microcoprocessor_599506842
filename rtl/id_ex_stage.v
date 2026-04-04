`include "defs.vh"

module id_ex_stage #(
    parameter pc_width = 10,
    parameter func_width = 6,
    parameter const_width = 8,
    parameter index_width = 3,
    parameter reg_width = 32
)(
    input      clk,
    input      rstn,
    input      halt_ext,
    input      isJmp,
    input      [pc_width-1 : 0] pc_next,
    input      isPipeLoading_id,
    output reg isPipeLoading_ex,
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
    input      halt_instr_id,
    output reg halt_instr_ex,
    input      regWrite_id,
    output reg regWrite_ex,
    input      [index_width-1 : 0] op0_id,
    output reg [index_width-1 : 0] op0_ex,
    input      [reg_width-1 : 0] S1_id,
    output reg [reg_width-1 : 0] S1_ex,
    input      [reg_width-1 : 0] S2_id,
    output reg [reg_width-1 : 0] S2_ex
);

// if (jmp||rst) NOP → regWrite = memWrite = 0;
always @(posedge clk)
    if(!halt_ext) begin
        pc_curr_ex       <= rstn ? (isJmp ? pc_next + 2
                                          : pc_curr_id) : 2;
        isPipeLoading_ex <= !rstn||isJmp||isPipeLoading_id;
        func_ex          <= (rstn&&!isJmp) ? func_id       : 6'b11_1001;
        const_ex         <= (rstn&&!isJmp) ? const_id      : 8'b1111_1111;
        memRead_ex       <= (rstn&&!isJmp) ? memRead_id    : 0;
        memWrite_ex      <= (rstn&&!isJmp) ? memWrite_id   : 0;
        aluToReg_ex      <= (rstn&&!isJmp) ? aluToReg_id   : 1;
        constToReg_ex    <= (rstn&&!isJmp) ? constToReg_id : 0;
        aluEn_ex         <= (rstn&&!isJmp) ? aluEn_id      : 0;
        halt_instr_ex    <= (rstn&&!isJmp) ? halt_instr_id : 0;
        regWrite_ex      <= (rstn&&!isJmp) ? regWrite_id   : 0;
        op0_ex           <= (rstn&&!isJmp) ? op0_id        : 0;
        S1_ex            <= (rstn&&!isJmp) ? S1_id         : 0;
        S2_ex            <= (rstn&&!isJmp) ? S2_id         : 0;
    end

endmodule
