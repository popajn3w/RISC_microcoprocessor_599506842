`include "defs.vh"
`include "timescale.vh"

module testbench_rom();

reg clk;
reg [`A_BITS-1 : 0] addr;
wire [`D_BITS-1 : 0] data; 

rom dut(
    .addr(addr),
    .data(data)
);

initial begin
    clk = 1;
    forever
        #5 clk = ~clk;
end

initial begin
    #21 
    dut.memory[11]={`ADD, `R0, `R1, `R2};
    dut.memory[13]={131313}; 
    #10
    addr = 10;
    #10
    addr = 11;
    #10
    addr = 12;
    #30
    addr = 13;
    #10
    addr = 14;
    #10 $stop();
end

endmodule