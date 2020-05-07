`timescale 1ns / 1ps

// MODULE TO ASSIGN ALU CONTROL SIGNAL
module alu_control(
    input [3:0] alu_op,
    input [5:0] func,
    output reg [3:0] alu_ctr
    );
    
    always @(*) begin
        case (alu_op)
            4'b0000: alu_ctr <= 4'b0001;     // ADD
            4'b0001: alu_ctr <= 4'b0010;     // SUBTRACT
            4'b0010: alu_ctr <= 4'b0111;     // OR
            4'b0011: alu_ctr <= 4'b0110;     // AND
            4'b0101: alu_ctr <= 4'b0001;     // ADD (FOR ADDI)
            4'b0110: alu_ctr <= 4'b1101;     // BGTZ
            4'b0111: alu_ctr <= 4'b1000;     // XOR
            4'b1000: alu_ctr <= 4'b1100;     // BLEZ
            4'b1001: alu_ctr <= 4'b1110;     // BNE
            4'b1010: alu_ctr <= 4'b1011;     // SLTI
            4'b1011: alu_ctr <= 4'b1111;     // SLTIU
           
            4'b0100: begin                   // R-TYPE
                case(func)
                    6'b100000: alu_ctr <= 4'b0001;    // ADD
                    6'b100010: alu_ctr <= 4'b0010;    // SUB
                    6'b100100: alu_ctr <= 4'b0110;    // AND
                    6'b100101: alu_ctr <= 4'b0111;    // OR
                    6'b100110: alu_ctr <= 4'b1000;    // XOR
                    6'b100111: alu_ctr <= 4'b1010;    // NOR
                    6'b000011: alu_ctr <= 4'b0100;    // SRA
                    6'b000111: alu_ctr <= 4'b0100;    // SRAV
                    6'b000010: alu_ctr <= 4'b0101;    // SRL
                    6'b000110: alu_ctr <= 4'b0101;    // SRLV
                    6'b000000: alu_ctr <= 4'b0011;    // SLL
                    6'b000100: alu_ctr <= 4'b0011;    // SLLV
                    6'b101010: alu_ctr <= 4'b1011;    // SLT
                    6'b101001: alu_ctr <= 4'b1111;    // SLTU
                endcase   
            end
        endcase
    end
endmodule
