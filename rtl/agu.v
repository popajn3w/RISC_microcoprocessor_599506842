`include "defs.vh"
`include "timescale.vh"

module agu #(
    parameter pc_width = 10,
    parameter addr_width = 16,
    parameter data_width = 32
)(
    input en,
    input [5:0] func,
    input [pc_width-1 : 0] pc_in,
    input [data_width-1 : 0] S1,
    input [data_width-1 : 0] S2,
    input [7:0] const,
    output reg [pc_width-1 : 0] pc_out,
    output reg [addr_width-1 : 0] addr,
    output reg [data_width-1 : 0] wr_data
);

always @(*) begin
    if(en) begin
        /// !! to avoid latching combinational case blocks, make sure all
        /// outputs are written for each iteration !!
        flag = 0;
        case(func[5:3])        // jump instructions + PC incrementing
            3'b000: pc_out = S1;    // JMP op1
            3'b001: pc_out = pc_in + offset;    // JMPR #offset
            3'b010: begin        // JMPcond op1 op2
                        case(func[2:0])
                            3'b000: flag = S1<0;
                            3'b001: flag = S1>=0;
                            3'b010: flag = S1==0;
                            3'b011: flag = S1!=0;
                        endcase
                        pc_out = flag ? S2 : pc_in+1;
                    end
            3'b011: begin        // JMPRcond op1 op2
                        case(func[2:0])
                            3'b000: flag = S1<0;
                            3'b001: flag = S1>=0;
                            3'b010: flag = S1==0;
                            3'b011: flag = S1!=0;
                        endcase
                        pc_out = flag ? pc_in+offset : pc_in+1;
                        //pc_out = flag ? $signed(pc_in) + $signed(const) : pc_in+1;
                    end
            default: pc_out = pc_in +1;
        endcase

        addr = 0;
        wr_data = 0;
        case(func[5:2])        // memory instructions
            4'b1000: addr = S1;    // LOAD op0 op1
            4'b1001: begin    // STORE op1 op2
                         addr = S1;
                         wr_data = S2;
                     end
            4'b1010: wr_data  =  {S1[data_width-1 : 24],  const};    // LOADC op1 const
        endcase
    end
    else
        pc_out = pc_in +1;
end

wire [pc_width-1 : 0] offset;
reg flag;

sign_extend #(
    .in_width(6),
    .out_width(pc_width)
)sign_extend0(
    .in(const[5:0]),
    .out(offset)
);

endmodule
