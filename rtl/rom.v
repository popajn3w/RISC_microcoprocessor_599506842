`include "defs.vh"
`include "timescale.vh"

module rom #(
    parameter pc_width = 10,
    parameter instr_width = 16
)(
    input [pc_width-1 : 0] addr,
    output [instr_width-1 : 0] data
); 

reg [instr_width-1 : 0] memory [0 : (1<<pc_width)-1];

assign data = memory[addr];

endmodule
