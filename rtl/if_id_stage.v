`include "defs.vh"

module if_id_stage #(
    parameter pc_width = 10,
    parameter instr_width = 16
)(
    input      clk,
    input      rstn,
    input      [pc_width-1 : 0] pc_curr_if,
    output reg [pc_width-1 : 0] pc_curr_id,
    input      [instr_width-1 : 0] instr_if,
    output reg [instr_width-1 : 0] instr_id
);

always @(posedge clk) begin
    pc_curr_id <= (rstn) ? pc_curr_if : 2;
    instr_id   <= (rstn) ? instr_if   : `NOP;
end

endmodule
