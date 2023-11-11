`include "timescale.vh"
`include "defs.vh"

module testbench_alu();

reg [31:0] S1;
reg [31:0] S2;
reg en;
reg [4:0] func;
wire [31:0] D;

alu dut(
    .S1(S1),
    .S2(S2),
    .en(en),
    .func(func),
    .D(D)
);

initial begin
    #21
    en=1;
    S1 = 12;
    S2 = 10;
    func = 5'b01_100;
    #10
    S2 = 20;
    #10
    $stop();
end

endmodule
