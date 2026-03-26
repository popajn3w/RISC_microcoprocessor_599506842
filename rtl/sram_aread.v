`include "defs.vh"

// sequential posedge write + comb read → distributed RAM
module sram_aread #(
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

always @(posedge clk) begin
    if(en)
        if(we)
            memory[addr] <= wr_data;
end

assign data = memory[addr];

endmodule
