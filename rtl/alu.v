`include "timescale.vh"
`include "defs.vh"

module alu #(
    parameter data_width = 32
)(
    input [data_width-1 : 0] S1,
    input [data_width-1 : 0] S2,
    input en,
    input [4:0] func,
    output reg [data_width-1 : 0] D
);

integer val;
integer i;

always @(*) begin
    if(en)
        case(func)
            5'b01_100: D = $signed(S1) + $signed(S2);
            5'b01_101: D = 0;//ADDF
            5'b01_110: D = $signed(S1) - $signed(S2);
            5'b01_111: D = 0;//SUBF
            5'b10_000: D = S1 & S2;
            5'b10_001: D = S1 | S2;
            5'b10_010: D = S1 ^ S2;
            5'b10_011: D = ~(S1 & S2);
            5'b10_100: D = ~(S1 | S2);
            5'b10_101: D = ~(S1 ^ S2);
            5'b10_110: D = S1 >> S2;
//            5'b10_111: begin            // for this instr, S1==D
//                           val = S2[4:0];    // bits to ASHR
//                           D = {data_width{1'b1}};
//                           D = S1 >> val;*/
//                           //D = {{val{1'b1}}, S1[data_width-1 : val]};
//                           // // first try, defective
//                           //for(i=data_width-1;  i >= data_width-val;  i=i-1)
//                           //    D[i] <= 1;
//                           //for(i=0; i<data_width-val; i=i+1)
//                           //    D[data_width-val-1-i] <= S1[data_width-1-i];*/
//                       //end
            5'b10_111: D = $signed(S1) >>> $signed(S2);
            5'b11_000: D = S1 << S2;
            default: D = 0;
        endcase
    else
        D = 0;
end

endmodule
