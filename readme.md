# Phase 1: Single Cycle MIPS Processor

## Part 1
* Implement 10 instructions (`lw`, `sw`, `beq`, `addi`, `j`, `add`, `sub`, `and`, `or`, `slt`).
* Verify the functionality of the implemented instructions by running the `Direct Test_1` program.
* Synthesis on DE1 SoC development board and test the program manually on the Evaluation kit.

## Part 2
* Implement lo,hi registers and mul,div modules with all necessary modifications.
* Implement 26 additional instructions (all remaining instructions excepted the unsigned instruction,Load/Store Instructions,`syscall`,`break`).
* Verify the functionality of the implemented instructions by Creating System Verilog Testbench with MIPS ISA Package and MIPS Instruction Class.

## Part 3
* Implement Unsigned instructions.
* Implement Load Instruction Variations.
* Verify the functionality of the implemented instructions by building MIPS ISA Assertion-based Scoreboard.
* Verify the functionality of the implemented instructions by running the `[Test_1,..,Test_6]`Direct testing program.
* Synthesis on DE1 SoC development board and test the program manually on the Evaluation kit.

# Phase 2: Pipelined MIPS Processor