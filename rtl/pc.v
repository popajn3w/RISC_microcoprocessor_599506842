`include "defs.vh"
`include "timescale.vh"

// combinational read, sequential posedge write
module pc #(
    parameter pc_width = 10
)(
    input clk,
    input [pc_width-1 : 0] pc_in,
    output reg [pc_width-1 : 0] pc_out
);

always @(posedge clk)
    pc_out <= pc_in;

endmodule
