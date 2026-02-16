
package mips_isa_pkg;
    import mips_pkg::*;
    class mips_instruction;
        // Dividing OpCode According to Their Instruction Type 
            const static opcode_t R_group[] = '{RType,MUL};
            const static opcode_t J_group[] = '{J,JAL};
            const static opcode_t I_group[] = '{BLT_BGEZ,BEQ,BNE,BLEZ,BGTZ,ADDI,ADDIU,SLTI,SLTIU,ANDI,ORI,XORI,LUI,MFC0,LB,LH,LW,LBU,LHU,SB,SH,Sw};
        // Opearands
            rand opcode_t    opcode;
            rand funct_t     funct;
            rand rfaddr_t    rs,rt,rd;
            rand immediate_t immediate;
            rand jaddress_t  address;
            rand shmat_t     shmat; 
        // Constriants
            // Constraint 1: Phase 1 Part 1
            // implement the following 10 instructions:
            //(`lw`, `sw`, `beq`, `addi`, `j`, `add`, `sub`, `and`, `or`, `slt`)
            const static opcode_t phase1_part1_opcode[] = '{RType,LW,Sw,BEQ,ADDI,J};
            const static funct_t  phase1_part1_funct[]  = '{ADD,SUB,AND,OR,SLT};
            constraint phase1_part1 {
                opcode  inside {phase1_part1_opcode};
                funct   inside {phase1_part1_funct}; 
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
        function bit [31:0] get_Instr(
            input opcode_t    i_opcode = opcode_t'('hxx),
            input funct_t     i_funct = funct_t'('hxx),
            input rfaddr_t    i_rs = rfaddr_t'('hxx),
            input rfaddr_t    i_rt = rfaddr_t'('hxx),
            input rfaddr_t    i_rd = rfaddr_t'('hxx),
            input immediate_t i_immediate = immediate_t'('hxx),
            input jaddress_t  i_address = jaddress_t'('hxx),
            input shmat_t     i_shmat = shmat_t'('hxx)
            );
            if (i_opcode === opcode_t'('hxx)) begin
                i_opcode = this.opcode;
            end 
            if (i_opcode inside {R_group}) begin // R Type 
                if (i_funct === funct_t'('hxx)) begin
                    i_funct = this.funct;
                end 
                if (i_rd === rfaddr_t'('hxx)) begin
                    i_rd = this.rd;
                end 
                if (i_rs === rfaddr_t'('hxx)) begin
                    i_rs = this.rs;
                end 
                if (i_rt === rfaddr_t'('hxx)) begin
                    i_rt = this.rt;
                end                    
                if (i_shmat === shmat_t'('hxx)) begin
                    i_shmat = this.shmat;
                end 
                return {i_opcode,i_rs,i_rt,i_rd,i_shmat,i_funct};
            end else if (i_opcode inside {J_group})begin // J Type                  
                if (i_address === jaddress_t'('hxx)) begin
                    i_address = this.address;
                end 
                return {i_opcode,i_address};
            end else if (i_opcode inside {I_group}) begin // I Type
                if (i_rs === rfaddr_t'('hxx)) begin
                    i_rs = this.rs;
                end 
                if (i_rt === rfaddr_t'('hxx)) begin
                    i_rt = this.rt;
                end  
                if (i_immediate === immediate_t'('hxx)) begin
                    i_immediate = this.immediate;
                end 
                return {i_opcode,i_rs,i_rt,i_immediate};
            end
        endfunction
    endclass 
endpackage