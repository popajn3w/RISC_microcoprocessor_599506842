`include "defs.vh"
`include "timescale.vh"

// combinational read, sequential negedge write
module sram #(
    parameter addr_width = 16,
    parameter data_width = 32
)(
    input en,
    input clk,
    input we,
    input [addr_width-1 : 0] addr,
    input [data_width-1 : 0] wr_data,
    output [data_width-1 : 0] data
);

reg [data_width-1 : 0] memory [0 : (1<<addr_width)-1];

always @(negedge clk) begin
    if(we)
        memory[addr] <= wr_data;
end

assign data = en ? memory[addr] : 0;

endmodule
