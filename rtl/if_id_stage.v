`include "defs.vh"

module if_id_stage #(
    parameter pc_width = 10,
    parameter instr_width = 16
)(
    input      clk,
    input      rstn,
    input      isJmp,
    input      [pc_width-1 : 0] pc_next,
    output reg isPipeLoading_id,
    input      [pc_width-1 : 0] pc_curr_if,
    output reg [pc_width-1 : 0] pc_curr_id
);

always @(posedge clk) begin
    pc_curr_id       <= rstn ? (isJmp ? pc_next + 3
                                      : pc_curr_if) : 3;
    isPipeLoading_id <= !rstn || isJmp;
end

endmodule
