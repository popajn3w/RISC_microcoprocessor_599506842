
`include "defs.vh"
`include "timescale.vh"

module testbench_core_pipeline();

reg rstn;
reg clk;

top_core_pipeline dut(
    .rstn(rstn),
    .clk(clk)
);


initial begin
    clk = 0;
    #10;  clk = 0;  clk = 1;
    forever begin
        #5 clk = ~clk;
    end
end

initial begin
    #1 rstn = 0;
    //dut.wb_if_stage0.pc_if = 0;

    dut.sram0.memory[0] = 0;
    dut.sram0.memory[1] = 10;
    dut.sram0.memory[2] = 20;
    dut.sram0.memory[3] = 30;
    dut.sram0.memory[4] = 40;
    dut.sram0.memory[5] = 50;
    dut.sram0.memory[6] = 60;
    dut.sram0.memory[7] = 0;
    dut.sram0.memory[600] = 1<<31;

    // ALU instructions 3 ops {
    //dut.rom0.memory[0] = {`NOP};
    //dut.rom0.memory[1] = {`ADD,`R0,`R1,`R2};
    //dut.rom0.memory[2] = {`SUB,`R3,`R4,`R5};
    //dut.rom0.memory[3] = {`AND,`R3,`R4,`R5};
    //dut.rom0.memory[4] = {`OR,`R3,`R4,`R5};

    dut.rom0.memory[0] = {`SUB,`R0,`R5,`R1};
    dut.rom0.memory[1] = {`NOP};
    dut.rom0.memory[2] = {`NOP};
    dut.rom0.memory[3] = {`NOP};
    dut.rom0.memory[4] = {`ADD,`R0,`R1,`R2};
    dut.rom0.memory[5] = {`NOP};
    dut.rom0.memory[6] = {`NOP};
    dut.rom0.memory[7] = {`NOP};
    dut.rom0.memory[8] = {`SUB,`R3,`R5,`R4};
    dut.rom0.memory[9] = {`NOP};
    dut.rom0.memory[10] = {`NOP};
    dut.rom0.memory[11] = {`NOP};
    dut.rom0.memory[12] = {`AND,`R3,`R4,`R5};
    dut.rom0.memory[13] = {`NOP};
    dut.rom0.memory[14] = {`NOP};
    dut.rom0.memory[15] = {`NOP};
    dut.rom0.memory[16] = {`OR,`R3,`R4,`R5};
    dut.rom0.memory[17] = {`NOP};
    dut.rom0.memory[18] = {`NOP};
    dut.rom0.memory[19] = {`NOP};
    // }

    #47 rstn = 1;

    dut.core_pipeline0.register_file0.regs[`R0] = 1;
    dut.core_pipeline0.register_file0.regs[`R1] = 2;
    dut.core_pipeline0.register_file0.regs[`R2] = 3;
    dut.core_pipeline0.register_file0.regs[`R3] = 4;
    dut.core_pipeline0.register_file0.regs[`R4] = 32'b0110_0110_0110_0110_0110_0110_0110_0110;
    dut.core_pipeline0.register_file0.regs[`R5] = 32'b0111_1110_0110_1110_0111_0110_1110_1110;
    dut.core_pipeline0.register_file0.regs[`R6] = 600;
    //dut.core_pipeline0.register_file0.regs[`R7] = 0;

//    dut.rom.memory[100] = ;
//    dut.rom.memory[101] = ;
//    dut.rom.memory[102] = ;
//    dut.rom.memory[103] = ;
//    dut.rom.memory[104] = ;

    #200
    dut.rom0.memory[20] = {`XOR,`R3,`R4,`R5};
    dut.rom0.memory[21] = {`NOP};
    dut.rom0.memory[22] = {`NOP};
    dut.rom0.memory[23] = {`NOP};
    dut.rom0.memory[24] = {`NXOR,`R3,`R4,`R5};
    dut.rom0.memory[25] = {`NOP};
    dut.rom0.memory[26] = {`NOP};
    dut.rom0.memory[27] = {`NOP};
    dut.rom0.memory[28] = {`SHIFTL,`R2,6'd0};
    dut.rom0.memory[29] = {`NOP};
    dut.rom0.memory[30] = {`NOP};
    dut.rom0.memory[31] = {`NOP};
    dut.rom0.memory[32] = {`SHIFTL,`R2,6'd2};
    dut.rom0.memory[33] = {`NOP};
    dut.rom0.memory[34] = {`NOP};
    dut.rom0.memory[35] = {`NOP};
    dut.rom0.memory[36] = {`SHIFTR,`R2,6'd2};
    dut.rom0.memory[37] = {`NOP};
    dut.rom0.memory[38] = {`NOP};
    dut.rom0.memory[39] = {`NOP};

    #200
    dut.rom0.memory[40] = {`LOAD,`R0,5'b0,`R6};
    dut.rom0.memory[41] = {`OR,`R2,`R2,`R0};
    dut.rom0.memory[42] = {`SHIFTRA,`R2,6'd1};
    dut.rom0.memory[43] = {`SHIFTRA,`R2,6'd28};
    dut.rom0.memory[44] = {`LOADC,`R6,8'd200};

    dut.rom0.memory[45] = {`STORE,`R6,5'd0,`R2};
    dut.rom0.memory[46] = {`SHIFTR,`R0,6'd31};    // R0 = 1
    dut.rom0.memory[47] = {`SHIFTR,`R2,6'd30};    // set R2 as counter = b11
    dut.rom0.memory[48] = {`LOADC,`R1,8'd18};    // set R1 as return addr
    dut.rom0.memory[49] = {`JMP,9'b0,`R7};

    #100
    dut.rom0.memory[20] = {`LOADC,`R7,8'd105};
    dut.rom0.memory[21] = {`SHIFTR,`R2,6'd30};   // set R2 as counter = b11; 380ns
    dut.rom0.memory[22] = {`JMP,9'b0,`R7};
    dut.rom0.memory[23] = {`NOP};
    dut.rom0.memory[24] = {`NOP};

    dut.rom0.memory[40] = {`JMPR,6'b0,-6'd20};
    dut.rom0.memory[70] = {`JMPR,6'b0,-6'd30};

    dut.rom0.memory[100] = {`SUB,`R2,`R2,`R0};    // R2--
    dut.rom0.memory[101] = {`JMPNN,`R2,3'b0,`R1};    // do while(R2>=0)
    dut.rom0.memory[102] = {`JMPR,6'b0,-6'd32};
    dut.rom0.memory[103] = {`NOP};
    dut.rom0.memory[104] = {`NOP};

    dut.rom0.memory[105] = {`SUB,`R2,`R2,`R0};
    dut.rom0.memory[106] = {`JMPRNZ,`R2,6'd4};
    dut.rom0.memory[107] = {`LOADC,`R7,8'd115};
    dut.rom0.memory[108] = {`JMP,9'b0,`R7};
    dut.rom0.memory[109] = {`NOP};

    #50
    dut.rom0.memory[110] = {`JMPR,6'b0,-6'd5};
    dut.rom0.memory[111] = {`NOP};
    dut.rom0.memory[112] = {`NOP};
    dut.rom0.memory[113] = {`NOP};
    dut.rom0.memory[114] = {`NOP};

    dut.rom0.memory[115] = {`LOADC,`R7,8'd117};
    dut.rom0.memory[116] = {`NOP};
    dut.rom0.memory[117] = {`NOP};
    dut.rom0.memory[118] = {`NOP};
    dut.rom0.memory[119] = {`NOP};

    #500

    #20 $stop();
end

endmodule
