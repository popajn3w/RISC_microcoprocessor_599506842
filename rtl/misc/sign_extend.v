module sign_extend #(
    parameter in_width = 16,
    parameter out_width = 32
)(
    input [in_width-1 : 0] in,
    output [out_width-1 : 0] out
);

generate
if(in_width>out_width)
    $error("bad usage of sign_extend.v");
endgenerate

assign out =  in[in_width-1]  ?  {{(out_width-in_width){1'b1}}, in}  :  in;

endmodule
