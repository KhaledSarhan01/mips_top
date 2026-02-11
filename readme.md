# Phase 1: Single Cycle MIPS Processor
## Block Diagram
# Top 
![Top Design](docs/Phase1TopDesign.png)
# Datapath
![Datapath](docs/SingleCycleDatapath.png)
## Phase Overview
* Instruction Set: Supports 47 instructions from the MIPS ISA (including R-type, I-type, and J-type).
* Target Hardware: Fully synthesized on the Intel/Terasic DE1-SoC (Cyclone V FPGA).
* Performance: Achieved a Maximum Frequency ($F_{max}$) of 59.35 MHz.
> **Note:** Timing analysis excludes the `div` instruction to maintain a higher clock frequency. 
## Verification
A robust SystemVerilog environment was utilized to ensure architectural integrity and functional correctness:

* Object-Oriented Infrastructure: Built using a dedicated MIPS ISA Package and a randomized Instruction Class for flexible stimulus generation.
* Assertion-Based Scoreboard: Automated checking via SystemVerilog Assertions (SVA) to validate register file updates and memory transactions in real-time.
* Directed Testing: Successfully validated the core through a tiered test suite: [`Test_1`,..., `Test_5`].
## Plan
### Phase 1 Part 1
* Implement 10 instructions (`lw`, `sw`, `beq`, `addi`, `j`, `add`, `sub`, `and`, `or`, `slt`).
* Verify the functionality of the implemented instructions by running the `Direct Test_1` program.
* Synthesis on DE1 SoC development board and test the program manually on the Evaluation kit.

### Phase 1 Part 2
* Implement lo,hi registers and mul,div modules with all necessary modifications.
* Implement 26 additional instructions (all remaining instructions excepted the unsigned instruction,Load/Store Instructions,`syscall`,`break`).
* Verify the functionality of the implemented instructions by Creating System Verilog Testbench with MIPS ISA Package and MIPS Instruction Class.

### Phase 1 Part 3
* Implement Unsigned instructions.
* Implement Load Instruction Variations.
* Verify the functionality of the implemented instructions by building MIPS ISA Assertion-based Scoreboard.
* Verify the functionality of the implemented instructions by running the `[Test_1,..,Test_5]`Direct testing program.
* Synthesis on DE1 SoC development board and test the program manually on the Evaluation kit.

# Phase 2: Pipelined MIPS Processor
## Plan
### Phase 2 Part 1
* Implement the pipelined MIPS and solve all occurred hazards in pipeline.
* Implement the early branch decision hardware for branching, predicting branch is not taken.
* Do Necessary Modifications on MIPS ISA Assertion-based Scoreboard.
* Verify the functionality of the implemented instructions by running the `[Test_1,..,Test_5]`Direct testing program.