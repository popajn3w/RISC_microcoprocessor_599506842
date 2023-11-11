`include "defs.vh"
`include "timescale.vh"

module testbench_core();

reg rstn;
reg clk;

core dut(
    .rstn(rstn),
    .clk(clk)
);


initial begin
    clk = 0;
    clk = 1;
    forever begin
        #5 clk = ~clk;
    end
end

initial begin
    #1
    dut.pc0.pc_out = 0;

    dut.sram0.memory[0] = 0;
    dut.sram0.memory[1] = 10;
    dut.sram0.memory[2] = 20;
    dut.sram0.memory[3] = 30;
    dut.sram0.memory[4] = 40;
    dut.sram0.memory[5] = 50;
    dut.sram0.memory[6] = 60;

    dut.rom0.memory[0] = {`NOP};
    dut.rom0.memory[1] = {`ADD,`R0,`R1,`R2};
    dut.rom0.memory[2] = {`ADD,`R3,`R4,`R5};
    dut.rom0.memory[3] = {`NOP};
    dut.rom0.memory[4] = {`NOP};
    dut.rom0.memory[5] = {`NOP};

    dut.registers0.regs[0] = 1;
    dut.registers0.regs[1] = 2;
    dut.registers0.regs[2] = 3;
    dut.registers0.regs[3] = 4;
    dut.registers0.regs[4] = 5;
    dut.registers0.regs[5] = 6;
    dut.registers0.regs[6] = 7;
    dut.registers0.regs[7] = 8;

//    dut.rom.memory[100] = ;
//    dut.rom.memory[101] = ;
//    dut.rom.memory[102] = ;
//    dut.rom.memory[103] = ;
//    dut.rom.memory[104] = ;
//    dut.rom.memory[105] = ;

    rstn = 1;

    #10

    #60
    #20 $stop();
end

endmodule
