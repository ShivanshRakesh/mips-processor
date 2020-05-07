`timescale 1ns/1ns

module alu(alu_ctr, inp_a, inp_b, zero, v_flg, c_out, out);
    
    /* 
        -------------------------------------------------------------
         INPUTS-
          alu_ctr: Tells the ALU which operation to perform
          inp_a: First input operand
          inp_b: Second input operand
        
         OUTPUTS-
          zero: Flag which tells whether the output is all zeros
          v_flg: Flag which tells whether bus width overflow occured
          c_out: Carry output of the ALU 
          out: Output of the ALU
        -------------------------------------------------------------
    */
    
    input [3:0] alu_ctr;
    input [31:0] inp_a;
    input [31:0] inp_b;
    output reg zero;
    output reg v_flg;
    output reg c_out;
    output reg [31:0] out;
    
    always @(*) begin
        case (alu_ctr)
            4'b0000: begin                  // OUPUT ZERO
                out <= 0;
            end
            4'b0001: begin                  // ADD OPERATION
                {c_out, out} <= {1'b0, $signed(inp_a)} + {1'b0, $signed(inp_b)};
                v_flg <= ({c_out, out[31]} == 2'b01);
            end 
            4'b0010: begin                  // SUBTRACT OPERATION
                {c_out, out} <= {1'b0, $signed(inp_a)} - {1'b0, $signed(inp_b)};
                v_flg <= ({c_out, out[31]} == 2'b01);
            end 
            4'b0011: begin                  // LEFT-SHIFT OPERATION
                out <= inp_b << inp_a; 
            end
            4'b0100: begin                  // RIGHT-SHIFT OPERATION
                out <= inp_b >> inp_a;
            end
            4'b0101: begin                  // SIGNED RIGHT-SHIFT OPERATION
                out <= inp_b >>> inp_a;
            end
            4'b0110: begin                  // AND OPERATION
                out <= inp_a & inp_b;
            end
            4'b0111: begin                  // OR OPERATION
                out <= inp_a | inp_b;
            end
            4'b1000: begin                  // XOR OPERATION
                out <= inp_a ^ inp_b;
            end
            4'b1001: begin                  // DO NOTHING
                
            end
            4'b1010: begin                  // NOR OPERATION
                out <= ~(inp_a | inp_b);
            end
            4'b1011: begin                                          // SIGNED LESS THAN OPERATION
                out <= ($signed(inp_a) < $signed(inp_b)) ? 1 : 0;   // Output 1 if A < B
            end
            4'b1100: begin                                          // LESS THAN OPERATION (INVERTED)
                out <= (inp_a < inp_b) ? 0 : 1;                     // Output 0 if A < B (INVERTED OUTPUT FOR ZERO SIGNAL FOR BRANCH INST)
            end
            4'b1101: begin                                          // GREATER THAN OPERATION (INVERTED)
                out <= (inp_a > inp_b) ? 0 : 1;                     // Output 0 if A > B (INVERTED OUTPUT FOR ZERO SIGNAL FOR BRANCH INST)
            end 
            4'b1110: begin                                          // EQUAL TO OPERATION
                out <= (inp_a == inp_b) ? 1 : 0;                    // Output 1 if A == B
            end
            4'b1111: begin                                          // LESS THAN OPERATION
                out <= (inp_a < inp_b) ? 1 : 0;                     // Output 1 if A < B
            end
              
        endcase
        // ASSIGNING ZERO OUTPUT
        zero <= ~(|out);
    end
endmodule