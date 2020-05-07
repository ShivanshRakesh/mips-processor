`timescale 1ns / 1ps

module adder(
    input [29:0] inp_a,
    input [29:0] inp_b,
    output [29:0] out 
    );
    assign out = inp_a + inp_b;
endmodule

module mux30(
    input [29:0] inp_a,
    input [29:0] inp_b,
    input select,
    output [29:0] out
    );
    assign out = ({30{~select}} & inp_a) | ({30{select}} & inp_b);
endmodule

module fetch(
    input clk,
    input branch,
    input jump,
    input zero,
    input [31:0] prev_inst,
    output wire [31:0] inst,
    output wire [29:0] tmp1
    );
    
    wire [29:0] curr, next;
    wire [29:0] jump_target;
    reg [29:0] pc;
    reg [7:0] inst_mem [127:0];
    
    initial begin
        $readmemb("inst_mem.mem", inst_mem);
        pc <= 30'b0;
    end
    
    always@(negedge clk) begin
        pc <= next;
        $display("------------------ FETCH STAGE ------------------");
        $display("TIME: %t", $time);
        $display("Current PC: %b", pc);
        $display("Control Signals- Branch: %b, Jump: %b, Zero: %b", branch, jump, zero);
        $display("Current Instruction: %b", inst);
    end

//    BIG ENDIAN
    assign inst = {inst_mem[{pc, 2'b00}], inst_mem[{pc, 2'b01}], inst_mem[{pc, 2'b10}], inst_mem[{pc, 2'b11}]};
    
//    LITTLE ENDIAN
//    assign inst = {inst_mem[{pc, 2'b11}], inst_mem[{pc, 2'b10}], inst_mem[{pc, 2'b01}], inst_mem[{pc, 2'b00}]};
    assign jump_target = {pc[29:26], prev_inst[25:0]};
    
    wire [29:0] tmp2, tmp3;
    adder a1(pc, 30'b1, tmp1);
    adder a2(pc, {{14{prev_inst[15]}}, prev_inst[15:0]}, tmp2);
    mux30 m1(tmp1, tmp2, (branch&zero), tmp3);
    mux30 m2(tmp3, jump_target, jump, next);
    
endmodule
