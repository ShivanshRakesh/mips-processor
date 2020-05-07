`timescale 1ns / 1ps

module mux(
    input [31:0] inp_a,
    input [31:0] inp_b,
    input select,
    output [31:0] out
    );
    
    assign out = ({32{~select}} & inp_a[31:0]) | ({32{select}} & inp_b[31:0]);
endmodule
