`timescale 1ns / 1ps

// MODULE TO SIGN OR ZERO EXTEND THE IMMEDIATE INPUT
module extender(
    input [15:0] data_in,
    input ext_op,
    output wire [31:0] data_out
    );
    
    assign data_out = (~ext_op & {{16{1'b0}}, {data_in}}) | (ext_op & {{16{data_in[15]}}, {data_in}}); 
endmodule
