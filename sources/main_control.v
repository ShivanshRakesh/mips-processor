`timescale 1ns / 1ps

// MODULE TO ASSIGN DIFFERENT CONTROL SIGNALS
module main_control(
    input [31:0] inst,
    output reg_dst,
    output alu_src,
    output mem_to_reg,
    output reg_wr,
    output mem_wr,
    output branch,
    output jump,
    output ext_op,
    output [3:0] alu_op
    );
    
    // ASSIGN CONTROL SIGNALS BASED ON THE OPCODE
    // -- FOLLOWED SLIDE 41 OF 'SingleCycleCPUDesign-cso2012.pdf' 
    // UPLOADED ON MOODLE + SOME EXTRA FUNCTIONS --
    wire [5:0] opcode;
    assign opcode = inst[31:26];
    assign reg_dst    = (inst!=32'b0) && (opcode == 6'b000000 | opcode == 6'b000011);
    assign alu_src    = (inst!=32'b0) && (opcode == 6'b001101 | opcode == 6'b100000 | opcode == 6'b101000 | opcode == 6'b001100 | opcode == 6'b001000 | opcode == 6'b001110 | opcode == 6'b001010 | opcode == 6'b001011); 
    assign mem_to_reg = (inst!=32'b0) && (opcode == 6'b100000);
    assign reg_wr     = (inst!=32'b0) && (opcode == 6'b000000 | opcode == 6'b000011 | opcode == 6'b001101 | opcode == 6'b100000 | opcode == 6'b001100 | opcode == 6'b001000 | opcode == 6'b001110 | opcode == 6'b001010 | opcode == 6'b001011); 
    assign mem_wr     = (inst!=32'b0) && (opcode == 6'b101000); 
    assign branch     = (inst!=32'b0) && (opcode == 6'b000100 | opcode == 6'b000111 | opcode == 6'b000110); 
    assign jump       = (inst!=32'b0) && (opcode == 6'b000010 | opcode == 6'b000011); 
    assign ext_op     = (inst!=32'b0) && (opcode == 6'b100000 | opcode == 6'b101000 | opcode == 6'b001010); 
    assign alu_op[3]  = (inst!=32'b0) && (opcode == 6'b000110 | opcode == 6'b000101 | opcode == 6'b001010 | opcode == 6'b001011);
    assign alu_op[2]  = (inst!=32'b0) && (opcode == 6'b000000 | opcode == 6'b001000 | opcode == 6'b001110 | opcode == 6'b000111); 
    assign alu_op[1]  = (inst!=32'b0) && (opcode == 6'b001101 | opcode == 6'b001100 | opcode == 6'b001110 | opcode == 6'b000111 | opcode == 6'b001010 | opcode == 6'b001011); 
    assign alu_op[0]  = (inst!=32'b0) && (opcode == 6'b000100 | opcode == 6'b001100 | opcode == 6'b001000 | opcode == 6'b001110 | opcode == 6'b000101 | opcode == 6'b001011); 
    
endmodule
