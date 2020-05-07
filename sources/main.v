`timescale 1ns / 1ps

// FOR CLOCK DIVISION
//module clk_divider(clk_in, clk_out);
//    input clk_in;
//    output clk_out;
//    reg[27:0] counter=28'd0;
//    parameter DIVISOR = 28'd10;

//    always @(posedge clk_in)
//    begin
//        counter <= counter + 28'd1;
//        if(counter>=(DIVISOR-1))
//            counter <= 28'd0;
//    end
//    assign clk_out = (counter<DIVISOR/2)?1'b0:1'b1;
//endmodule

module main(
    input clk
    );
    reg [31:0] inst;
    wire [31:0] next_inst;
    wire branch, jump, zero;
    wire [29:0] pc_seq;
    
//    FOR CLOCK DIVISION
//    wire clk_new;
//    clk_divider uut_clk_divider(clk, clk_new);
    
    initial begin 
        inst <= 32'b0;
    end

    fetch fetch_uut(clk, branch, jump, zero, inst, next_inst, pc_seq);
    execute exec_uut(clk, inst, pc_seq, branch, jump, zero);

    always@(negedge clk) begin
        inst <= next_inst;
    end
    
endmodule
