`include "defs.vh"

// sequential posedge read+write → BRAM
module sram #(
    parameter addr_width = 16,
    parameter data_width = 32
)(
    input en,
    input clk,
    input we,
    input [addr_width-1 : 0] addr,
    input [addr_width-1 : 0] addr2,
    input [data_width-1 : 0] wr_data,
    output reg [data_width-1 : 0] data,
    output reg [data_width-1 : 0] data2
);

reg [data_width-1 : 0] memory [0 : (1<<addr_width)-1];

always @(posedge clk) begin
    if(en) begin
        if(we)
            memory[addr] <= wr_data;    // we, addr, wr_data shared for ext wr
        data  <= memory[addr ];
        data2 <= memory[addr2];
    end
end


endmodule
