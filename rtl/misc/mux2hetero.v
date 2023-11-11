module mux2hetero #(
    parameter data_width_in0out = 1,
    parameter data_width_in1 = 1
)(
    input [data_width_in0out-1 : 0] in0,
    input [data_width_in1-1 : 0] in1,
    input sel,
    output [data_width_in0out-1 : 0] out
);

assign out = sel ? in1 : in0;

endmodule
