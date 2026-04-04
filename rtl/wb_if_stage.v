`include "defs.vh"

module wb_if_stage #(
    parameter pc_width = 10
)(
    input      clk,
    input      rstn,
    input      halt_ext,
    input      [pc_width-1 : 0] pc_wb,
    output reg [pc_width-1 : 0] pc_if    // the "base" PC register
);

always @(posedge clk)
    if (!halt_ext)
        pc_if <= (rstn) ? pc_wb : 0;

endmodule
