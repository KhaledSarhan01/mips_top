
package mips_isa_pkg;
    import mips_pkg::*;
    class mips_instruction;
        // Dividing OpCode According to Their Instruction Type 
            const static opcode_t R_group[] = '{RType,MUL};
            const static opcode_t J_group[] = '{J,JAL};
            const static opcode_t I_group[] = '{BLT,BEQ,BNQ,BLEZ,BGTZ,ADDI,ADDIU,SLTI,SLTIU,ANDI,ORI,XORI,LUI,MFC0,LB,LH,LW,LBU,LHU,SB,SH,Sw};
        // Opearands
            rand opcode_t    opcode;
            rand funct_t     funct;
            rand rfaddr_t    rs,rt,rd;
            rand immediate_t immediate;
            rand jaddress_t  address;
            rand shmat_t     shmat; 
        // Constriants
            // Constraint 1: Syntax Correctness (The "Shape" of the instruction)
                constraint c_syntax_rules {
                    
                    // --- R-Type Rules ---
                    // Active: rs, rt, rd
                    // Inactive: imm, address. (shamt is 0 for add/sub, used only for shifts)
                    (opcode inside {R_group}) -> {
                        imm     == 0;
                        address == 0;
                        // shamt   == 0; // Assuming standard arithmetic, not shifts
                    };

                    // --- I-Type Rules ---
                    // Active: rs, rt, imm
                    // Inactive: rd, shamt, address
                    (opcode inside {I_group}) -> {
                        rd      == 0;
                        shamt   == 0;
                        address == 0;
                    };

                    // --- J-Type Rules ---
                    // Active: address
                    // Inactive: rs, rt, rd, shamt, imm
                    (opcode inside {J_group}) -> {
                        rs      == 0;
                        rt      == 0;
                        rd      == 0;
                        shamt   == 0;
                        imm     == 0;
                    };
                }
        function new();
        //NOP Opearation
            opcode      = RType;// all zeros
            funct       = SLL;  // all zeros
            rs          = 'b0;
            rt          = 'b0;
            rd          = 'b0;
            immediate   = 'b0;
            address     = 'b0;
            shmat       = 'b0;
        endfunction 

        // General Instruction with random Fields
        function bit [31:0] get_Instr();
            
        endfunction

        // Specific R Type Instruction
        function bit [31:0] get_R_Instr();
            
        endfunction

        // Specific I Type Instruction        
        function bit [31:0] get_I_Instr();
            
        endfunction

        // Specific J Type Instruction
        function bit [31:0] get_J_Instr();
            
        endfunction


    endclass 
endpackage