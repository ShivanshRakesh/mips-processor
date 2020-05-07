# 2-stage Pipelined MIPS Processor

## Architectural Diagrams:

#### 2-stage Pipelined Design:
![](./pipelined-design.png)

#### Fetch Stage:
![](./fetch.png)

#### Decode/Execute Stage:
![](./execute.png)

## Main Memory Design:

* It follows Little Endian type of storage policy.
* One memory block is of 1 byte.
* All read operations are asyncronous, all write operations are syncronous.
* There is separate Data Memory and Instruction Memory.
* Data Memory Size: 1024 bytes.
* Instruction Memory Size: 1024 bytes.



## Instructions Supported:

* ADD, SUB, ADDI, AND, ANDI, OR, ORI, XOR, XORI, NOR
* SLL, SLLV, SRA, SRAV, SRL, SRLV, SLT, SLTU, SLTI, SLTIU
* BEQ, BGTZ, BLEZ, BNE, J, JAL
* LB, SB



## Highlights

* The processor is designed in a modular way. That is, the codebase has each component as a separate module. This makes it easier to debug errors in existing code, as well as, add new features to the design.
* The above also makes the RTL of this project way more organised. Each functioning block can be seen as a different component.
* Number of Branch Delay Slots: 1
* Well formatted console logging for testing the working of processor.



## FOR TESTING:
* Edit the memory file `inst_mem.mem` which is the instruction memory.
* Make sure to use **LITTLE ENDIAN** encoding of instructions. In case you prefer **BIG ENDIAN** encoding, uncomment line #50 and comment out line #53 in file `fetch.v`.
* Uncomment the lines ending with `// FOR TESTING PURPOSE` to see testing outputs in the console.
* Use the console to see the output.


* **[NOTE]** Some test instructions are stored in the file `test_inst`.
* **[NOTE]** Currently, the instructions in `test_inst` and `inst_mem.mem` are in **BIG ENDIAN** format for ease of understanding the instruction.

---
