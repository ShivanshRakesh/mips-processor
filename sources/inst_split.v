`timescale 1ns / 1ps

// Module for splitting up the instruction 
// into different sections

module inst_split(
    input [31:0] inst,
    output [5:0] opcode,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [4:0] shamt,
    output [5:0] func,
    output [15:0] imm16,
    output [25:0] target
    );
    
    assign opcode = inst[31:26];
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    // IF INSTRUCTION IS JAL, ASSIGN RD = 31
    assign rd = (inst[31:26]==6'b000011) ? 5'b11111 : inst[15:11];
    assign shamt = inst[10:6];
    assign func = inst[5:0];
    assign imm16 = inst[15:0];
    assign target = inst[25:0];

endmodule