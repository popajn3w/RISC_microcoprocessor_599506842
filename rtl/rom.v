`include "defs.vh"

module rom #(
    parameter pc_width = 10,
    parameter instr_width = 16
)(
    input clk,
    input we,
    input [pc_width-1 : 0] addr,
    input [pc_width-1 : 0] addr2,
    input [instr_width-1 : 0] wr_data,
    output reg [instr_width-1 : 0] data,
    output reg [instr_width-1 : 0] data2
); 

reg [instr_width-1 : 0] memory [0 : (1<<pc_width)-1];

always @(posedge clk) begin
    if(we)
        memory[addr2] <= wr_data;    // we, addr2, wr_data ext only
    data  <= memory[addr ];
    data2 <= memory[addr2];
end

endmodule
