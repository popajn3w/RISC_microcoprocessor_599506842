`include "defs.vh"
`include "timescale.vh"

module register_file_full_seq #(
    parameter index_width = 3,
    parameter reg_width = 32
)(
    input rstn,
    input clk,
    input we,
    input [index_width-1 : 0] op0,    // R[op0]=Rd
    input [index_width-1 : 0] op1,    // R[op1]=s1
    input [index_width-1 : 0] op2,    // R[op2]=s2
    input [reg_width-1 : 0] D,
    output reg [reg_width-1 : 0] S1,
    output reg [reg_width-1 : 0] S2
);

reg [reg_width-1 : 0] regs [0 : (1<<index_width)-1];
integer addr_internal;

always @(negedge clk) begin
    if(!rstn)
        for(addr_internal=0;  addr_internal < (1<<index_width); addr_internal=addr_internal+1)
            regs[addr_internal] <= 0;
            
    S1 <= regs[op1];
    S2 <= regs[op2];
end

always @(posedge clk)
    if(we)
        regs[op0] <= D;

endmodule 
