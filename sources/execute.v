`timescale 1ns / 1ps

module execute(
    input clk,
    input [31:0] inst,
    input [29:0] pc_seq,
    output wire branch,
    output wire jump,
    output wire zero
    );
    
    // SPLITTING INSTRUCTION
    wire [5:0] opcode;
    wire [4:0] rs, rt, rd, shamt;
    wire [5:0] func;
    wire [15:0] imm16;
    wire [25:0] target;
    // IF INSTRUCTION IS JAL, RD IS ASSIGNED TO BE 31
    inst_split uut_inst_split(inst, opcode, rs, rt, rd, shamt, func, imm16, target);
    
    // ASSIGNING CONTROL SIGNALS
    wire reg_dst, alu_src, mem_to_reg, reg_wr, mem_wr, ext_op;
    wire [3:0] alu_op;
    main_control uut_main_control(inst, reg_dst, alu_src, mem_to_reg, reg_wr, mem_wr, branch, jump, ext_op, alu_op);
    wire [3:0] alu_ctr;
    alu_control uut_alu_control(alu_op, func, alu_ctr);
    
   /////////////////////////////////////////////////////////
   // -------- SETTING-UP REGISTERS & DATA MEMORY --------//

    wire [31:0] busA, busB, busW_tmp, busW;
    // INITIALIZE A 32X32 BIT REGISTER
    reg [31:0] register [31:0];
    // INITIALIZE A 4096X8 BIT MEMORY
    reg [7:0] data_mem [4095:0];
    integer i;
    initial begin
        for(i=0; i<32; i=i+1) begin
            register[i] = 32'b0;
        end
        for(i=0; i<4096; i=i+1) begin
            data_mem[i] = 8'b0;
        end
//        register[2] = 32'b1;      // FOR TESTING PURPOSE
//        data_mem[0] = 8'd4;		// FOR TESTING PURPOSE
//        data_mem[1] = 8'd2;		// FOR TESTING PURPOSE
//        data_mem[2] = 8'd3;		// FOR TESTING PURPOSE
//        data_mem[3] = 8'd0;		// FOR TESTING PURPOSE
//        data_mem[4] = 8'd1;       // FOR TESTING PURPOSE
    end
    
    // PUT CONTENTS OF REGISTER WITH ADDRESS 'rs' ON 
    // 'busA' AND THAT WITH ADDRESS 'rt' ON 'busB'
    assign busA = ({32{(opcode==6'b0 && (func==6'b0 || func==6'b000011 || func==6'b000010))}} & {{27'b0}, shamt}) | ({32{~(opcode==6'b0 && (func==6'b0 || func==6'b000011 || func==6'b000010))}} & register[rs]);
    assign busB = register[rt];
    // ---------------------------------------------------//
    ////////////////////////////////////////////////////////
    
    // CALLING EXTENDER
    wire [31:0] extender_out;
    extender uut_extender(imm16, ext_op, extender_out);
    
    // DECIDING ALU SOURCE B
    wire [31:0] alu_busB;
    mux uut0_mux(busB, extender_out, alu_src, alu_busB); 

    // CALLING ALU
    wire [31:0] alu_out;
    wire v_flg, c_out;
    alu uut_alu(alu_ctr, busA, alu_busB, zero, v_flg, c_out, alu_out);
    
    // IF 'reg_wr' IS HIGH, WRITE CONTENTS OF 'busW' TO THE
    // REGISTER SPECIFIED BY 'reg_dst' 
    // IF 'mem_wr' IS HIGH, WRITE CONTENTS OF 'busB' TO THE
    // MEM LOCATION SPECIFIED BY 'alu_out' 
    // ON EVERY NEGEDGE OF 'clk'
    always @(negedge clk) begin
        if (reg_wr)
            register[({5{reg_dst}}&rd) | ({5{~reg_dst}}&rt)] <= busW;
        if(mem_wr)
            data_mem[alu_out] <= busB[7:0]; 
        
        $display("----------------- EXECUTE STAGE -----------------");
        $display("Executing Instruction: %b %b %b %b %b %b", opcode, rs, rt, rd, shamt, func);
        $display("Control Signals:");
        $display("  REG_DST: %b, ALU_SRC: %b, MEM_TO_REG: %b, REG_WR: %b", reg_dst, alu_src, mem_to_reg, reg_wr);
        $display("  MEM_WR: %b, BRANCH: %b, JUMP: %b, EXT_OP: %b, ZERO: %b", mem_wr, branch, jump, ext_op, zero);
        $display("ALU InpA: %b", busA);
        $display("ALU InpB: %b", alu_busB);
        $display("ALU Output: %b", alu_out);
        $display("BusW: %b", busW);
        $display("Array: %d %d %d %d %d", data_mem[0], data_mem[1], data_mem[2], data_mem[3], data_mem[4]);
//        $display("DATA_MEM[alu_out]: %b", data_mem[alu_out]);     // FOR TESTING PURPOSE
//        $display("REG[1]: %d", register[1]);        // FOR TESTING PURPOSE
//        $display("REG[2]: %d", register[2]);        // FOR TESTING PURPOSE
//        $display("REG[3]: %d", register[3]);        // FOR TESTING PURPOSE
//        $display("REG[4]: %d", register[4]);        // FOR TESTING PURPOSE
//        $display("REG[5]: %d", register[5]);        // FOR TESTING PURPOSE
//        $display("REG[6]: %d", register[6]);        // FOR TESTING PURPOSE
//        $display("REG[7]: %d", register[7]);        // FOR TESTING PURPOSE
        $display("-------------------------------------------------");
        $display(" ");
    end

    // PUT CONTENTS OF 4 MEMORY LOCATIONS WITH STARTING 
    // ADDRESS 'alu_out' ON BUS 'data_mem_out'
    wire [31:0] data_mem_out;
//    IN CASE OF LOAD/STORE WORD
//    assign data_mem_out = {{data_mem[alu_out]},{data_mem[alu_out+1]},{data_mem[alu_out+2]},{data_mem[alu_out+3]}};
    assign data_mem_out = {{24{1'b0}},{data_mem[alu_out]}};
    
    
    // PUT CONTENTS ON busW
    mux uut1_mux(alu_out, data_mem_out, mem_to_reg, busW_tmp);
//    assign pc_seq = pc_seq + 1;  
    mux uut2_mux(busW_tmp, {pc_seq, 2'b00}, (opcode==6'b000011), busW);
        
endmodule
