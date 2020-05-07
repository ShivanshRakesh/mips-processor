import sys
import data

def main(argv):
    fin = open(argv)
    lines = fin.readlines()
    with open("inst_mem.mem", "w") as fout:
        for line in lines:
            instr = ""
            if line.isspace() or len(line) == 0:
                continue

            instr_name = line.split(" ")[0].upper()
            opcode = data.OPCODE_MAP[instr_name]

            # J-type Instructions
            if instr_name.startswith('J'):
                target_addr = format(int(line[len(instr_name)+1::]), "026b")
                instr = opcode + target_addr

            # R-type instructions
            elif opcode == "000000":
                regs = [format(int(reg.strip("$ ")), "05b") for reg in line[len(instr_name)+1:].split(',')]
                if instr_name in ["SRA", "SRL", "SLL"]:
                    instr = opcode + "00000" + regs[1] + regs[0] + regs[2] + data.FUNCTION_MAP[instr_name]
                else:
                    instr = opcode + regs[1] + regs[2] + regs[0] + "00000" + data.FUNCTION_MAP[instr_name]

            # I-type instructions
            else:
                args = line[len(instr_name)+1:].split(',')
                if len(args) == 3: 
                    regs = [format(int(reg.strip("$ ")), "05b") for reg in args[:-1]]
                    if '-' in args[-1]:
                        imm16 = format((1<<16) - int(args[-1].split('-')[1]), "016b")
                    else:
                        imm16 = format(int(args[-1]), "016b")
                    instr = opcode + regs[1] + regs[0] + imm16

                elif instr_name in ["BLEZ", "BGTZ"]:
                    reg = format(int(args[0].strip("$ ")), "05b")
                    offset = format(int(args[1]), "016b")
                    instr = opcode + reg + "00000" + offset

                elif instr_name in ["LB", "SB"]:
                    reg = format(int(args[0].strip("$ ")), "05b")
                    offset = format(int(args[1].split('(')[0]), "016b")
                    base = format(int(args[1].split('(')[1].split(')')[0].strip("$ ")), "05b")
                    instr = opcode + base + reg + offset
                
            fout.write(instr[0:8]   + '\n')
            fout.write(instr[8:16]  + '\n')
            fout.write(instr[16:24] + '\n')
            fout.write(instr[24:32] + '\n')

if __name__ == '__main__':
    main(sys.argv[1])

