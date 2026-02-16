// It works as instruction Memory 
import mips_isa_pkg::*;
import mips_pkg::*;
module mips_testbench (
    input  logic clk,
    output logic rst_n,
    // To instruction Memory
    input  logic [PC_WIDTH-1:0]     pc,
    output logic [INSTR_WITDTH-1:0] instr
);
//////////////////////////////////////
////////// Testbench Core ///////////
////////////////////////////////////

// Core
    initial begin
        Initialization();
        Reset();
        Main_Scenario();
        Finish();
    end
    
    task Reset;
        rst_n = 1'b0;
        @(negedge clk);
        rst_n = 1'b1;
    endtask
    
    task Finish;
        repeat(10) @(negedge clk);
        $stop;
    endtask
// Watch dog works after 10 ms in simulation time 
    initial begin
        #1000000;
        $display("Simulation is not working");
        $stop; 
    end  

//////////////////////////////////////
//////// Testbench Scenarios ////////
////////////////////////////////////
    mips_instruction mips_instr = new();
    task Initialization;
        // Initialize your Signals Here
        instr = mips_instr.get_Instr();
    endtask
    task Main_Scenario();
        // Direct Testing
            Phase1Part1();                                        
    endtask

    
    // Direct Testing
    task automatic Phase1Part1();
        // `lw`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(LW));
            // repeat(5) @(posedge clk);
        // `sw`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(Sw));
            // repeat(5) @(posedge clk);
        // `beq`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(BEQ));
            // repeat(5) @(posedge clk);
        // `addi`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(ADDI));
            // repeat(5) @(posedge clk);
        // `j`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(J));
            // repeat(5) @(posedge clk);
        //  `add`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(ADD));
            // repeat(5) @(posedge clk);
        // `sub`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(SUB));
            // repeat(5) @(posedge clk);
        //  `and`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(AND));
            // repeat(5) @(posedge clk);
        //  `or`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(OR));
            // repeat(5) @(posedge clk);
        //  `slt`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(SLT));
            // repeat(5) @(posedge clk);
    endtask 

    task automatic AluInstructions();
        //  `add`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(ADD));
        // `sub`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(SUB));
        //  `and`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(AND));
        //  `or`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(OR));
        //  `slt`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(SLT));
        // `xor`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(XOR));    
        
        // `nor`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(NOR));
        
        // `sll`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(SLL));
    
        // `srl`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(SRL));

        // `sra`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(SRA));
            
        // `sllv`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(SLLV));
        
        // `srlv`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(SRLV));
        
        // `srav`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(SRAV));                    
    endtask  
    
    task automatic HiLoReg_MoveOps();
        // `mfhi`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(MFHI));
        // `mthi`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(MTHI));
        // `mflo`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(MFLO));
        // `mtlo`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(MTLO));
    endtask
    task automatic AluUnsignedInstructions();
        // Register 
            // Register[1] = Very high postive Value
                RegFileValue(.register(1),.value('h7FFF));    
            // Register[2] = Very negative postive Value
                RegFileValue(.register(2),.value('h8000)); 
        //SLTI
            // `slti`: Very large Positive < Very large Negative: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(SLTI),.i_rs(1),.i_rt(3),.i_immediate('h8000));
            // `slti`: Very large Positive < Very large Positive: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(SLTI),.i_rs(1),.i_rt(3),.i_immediate('h7FFF));
            // `slti`: Very large Negative < Very large Negative: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(SLTI),.i_rs(2),.i_rt(3),.i_immediate('h8000));
            // `slti`: Very large Negative < Very large Positive: [rt] = 1
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(SLTI),.i_rs(2),.i_rt(3),.i_immediate('h7FFF));
        // SLTIU
            // `sltiu`: Very large Positive < Very large Negative: [rt] = 1
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(SLTIU),.i_rs(1),.i_rt(3),.i_immediate('h8000));
            // `sltiu`: Very large Positive < Very large Positive: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(SLTIU),.i_rs(1),.i_rt(3),.i_immediate('h7FFF));
            // `sltiu`: Very large Negative < Very large Negative: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(SLTIU),.i_rs(2),.i_rt(3),.i_immediate('h8000));
            // `sltiu`: Very large Negative < Very large Positive: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(SLTIU),.i_rs(2),.i_rt(3),.i_immediate('h7FFF));
        //ADDI
            // `addi`: Very large Positive < Very large Negative: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(ADDI),.i_rs(1),.i_rt(3),.i_immediate('h8000));
            // `addi`: Very large Positive < Very large Positive: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(ADDI),.i_rs(1),.i_rt(3),.i_immediate('h7FFF));
            // `addi`: Very large Negative < Very large Negative: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(ADDI),.i_rs(2),.i_rt(3),.i_immediate('h8000));
            // `addi`: Very large Negative < Very large Positive: [rt] = 1
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(ADDI),.i_rs(2),.i_rt(3),.i_immediate('h7FFF));
        // ADDIU
            // `addiu`: Very large Positive < Very large Negative: [rt] = 1
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(ADDIU),.i_rs(1),.i_rt(3),.i_immediate('h8000));
            // `addiu`: Very large Positive < Very large Positive: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(ADDIU),.i_rs(1),.i_rt(3),.i_immediate('h7FFF));
            // `addiu`: Very large Negative < Very large Negative: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(ADDIU),.i_rs(2),.i_rt(3),.i_immediate('h8000));
            // `addiu`: Very large Negative < Very large Positive: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(ADDIU),.i_rs(2),.i_rt(3),.i_immediate('h7FFF));
        //ADD
            // `add`: Very large Positive < Very large Negative: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(ADD),.i_opcode(RType),.i_rd(3),.i_rs(1),.i_rt(1));
            // `add`: Very large Positive < Very large Positive: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(ADD),.i_opcode(RType),.i_rd(3),.i_rs(1),.i_rt(2));
            // `add`: Very large Negative < Very large Negative: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(ADD),.i_opcode(RType),.i_rd(3),.i_rs(2),.i_rt(1));
            // `add`: Very large Negative < Very large Positive: [rt] = 1
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(ADD),.i_opcode(RType),.i_rd(3),.i_rs(2),.i_rt(2));
        // ADDU
            // `addu`: Very large Positive < Very large Negative: [rt] = 1
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(ADDU),.i_opcode(RType),.i_rd(3),.i_rs(1),.i_rt(1));
            // `addu`: Very large Positive < Very large Positive: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(ADDU),.i_opcode(RType),.i_rd(3),.i_rs(1),.i_rt(2));
            // `addu`: Very large Negative < Very large Negative: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(ADDU),.i_opcode(RType),.i_rd(3),.i_rs(2),.i_rt(1));
            // `addu`: Very large Negative < Very large Positive: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(ADDU),.i_opcode(RType),.i_rd(3),.i_rs(2),.i_rt(2));
        //SUB
            // `sub`: Very large Positive < Very large Negative: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(SUB),.i_opcode(RType),.i_rd(3),.i_rs(1),.i_rt(1));
            // `sub`: Very large Positive < Very large Positive: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(SUB),.i_opcode(RType),.i_rd(3),.i_rs(1),.i_rt(2));
            // `sub`: Very large Negative < Very large Negative: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(SUB),.i_opcode(RType),.i_rd(3),.i_rs(2),.i_rt(1));
            // `sub`: Very large Negative < Very large Positive: [rt] = 1
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(SUB),.i_opcode(RType),.i_rd(3),.i_rs(2),.i_rt(2));
        // SUBU
            // `subu`: Very large Positive < Very large Negative: [rt] = 1
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(SUBU),.i_opcode(RType),.i_rd(3),.i_rs(1),.i_rt(1));
            // `subu`: Very large Positive < Very large Positive: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(SUBU),.i_opcode(RType),.i_rd(3),.i_rs(1),.i_rt(2));
            // `subu`: Very large Negative < Very large Negative: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(SUBU),.i_opcode(RType),.i_rd(3),.i_rs(2),.i_rt(1));
            // `subu`: Very large Negative < Very large Positive: [rt] = 0
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_funct(SUBU),.i_opcode(RType),.i_rd(3),.i_rs(2),.i_rt(2));
    
    endtask 
    
    task automatic AluImmediateInstructions();
        // `slti`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(SLTI));
        // `andi`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(ANDI));
        // `ori`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(ORI));
        // `xori`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(XORI));
        // `addi`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(ADDI));
        // `lui`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(LUI));
        // `mul`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(MUL));     
    endtask 

    task automatic BranchInstructions();
        /*
            Assume Magic Number 1 = 10  (then less than = 9, greater than = 11)
            Assume Magic Number 2 = -10 (then less than = -11, greater than = -9)
            Test Sequence: 
            1-  Fill the register with (Magic Number + itself + its greater than 
                + smaller than) values.
            2-  Test instruction by 
                a-  compare it with itself
                b-  compare it with greater than value
                c-  compare it with very high postive value
                d-  compare it with less than value
                e-  compare it with very high postive value
            3- do it for every instruction
        */
        // First: Register Filling
            // Register[1] = Magic Number 1
                RegFileValue(.register(1),.value('d10));
            // Register[2] = Magic Number 1
                RegFileValue(.register(2),.value('d10));
            // Register[3] = Greater than Magic Number 1
                RegFileValue(.register(3),.value('d11));
            // Register[4] = Smaller than Magic Number 1
                RegFileValue(.register(4),.value('d9));
            // Register[5] = Very high postive Value
                RegFileValue(.register(5),.value('h7FFF));
            // Register[6]  = Magic Number 2
                RegFileValue(.register(6),.value('hFFFF_FFF6));
            // Register[7]  = Magic Number 2
                RegFileValue(.register(7),.value('hFFFF_FFF6));
            // Register[8] = Greater than Magic Number 2
                RegFileValue(.register(8),.value('hFFFF_FFF7));
            // Register[9] = Smaller than Magic Number 2 
                RegFileValue(.register(9),.value('hFFFF_FFF5));
            // Register[10] = Very negative postive Value
                RegFileValue(.register(10),.value('h8000));       
        // Second Instruction Testing
            // `blt`
                for (int i = 0; i<= 10; i++) begin
                    @(negedge clk);
                    assert (mips_instr.randomize());
                    instr = mips_instr.get_Instr(.i_opcode(BLT_BGEZ),.i_rt(0),.i_rs(i));    
                end
            // `blez`
                for (int i = 0; i<= 10; i++) begin
                    @(negedge clk);
                    assert (mips_instr.randomize());
                    instr = mips_instr.get_Instr(.i_opcode(BLEZ),.i_rs(i));    
                end       
            // `bgez`
                for (int i = 0; i<= 10; i++) begin
                    @(negedge clk);
                    assert (mips_instr.randomize());
                    instr = mips_instr.get_Instr(.i_opcode(BLT_BGEZ),.i_rt(1),.i_rs(i));    
                end
            // `bgtz`
                for (int i = 0; i<= 10; i++) begin
                    @(negedge clk);
                    assert (mips_instr.randomize());
                    instr = mips_instr.get_Instr(.i_opcode(BGTZ),.i_rs(i));    
                end                    
            // `beq`
                for (int i = 2; i<= 5; i++) begin
                    @(negedge clk);
                    assert (mips_instr.randomize());
                    instr = mips_instr.get_Instr(.i_opcode(BEQ),.i_rs(1),.i_rt(i));   
                end
                for (int i = 7; i<= 10; i++) begin
                    @(negedge clk);
                    assert (mips_instr.randomize());
                    instr = mips_instr.get_Instr(.i_opcode(BEQ),.i_rs(6),.i_rt(i));   
                end
            // `bne`
                for (int i = 2; i<= 5; i++) begin
                    @(negedge clk);
                    assert (mips_instr.randomize());
                    instr = mips_instr.get_Instr(.i_opcode(BNE),.i_rs(1),.i_rt(i));   
                end
                for (int i = 7; i<= 10; i++) begin
                    @(negedge clk);
                    assert (mips_instr.randomize());
                    instr = mips_instr.get_Instr(.i_opcode(BNE),.i_rs(6),.i_rt(i));   
                end                
    endtask 
    
    task automatic JumpInstructions();
        // `jal`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(JAL));
        // `jalr`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(JALR));               
        // `jr`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(JR));
        // `j`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(J));    
    endtask
    
    task automatic MultDivTesting();
        // `mult`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(MULT));
        // `div`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(RType),.i_funct(DIV));
    endtask 

    task automatic LoadStoreInstructions();
        // `lw`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(LW),.i_rs(0),.i_immediate('he));
        // `lb`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(LB),.i_rs(0),.i_immediate('he));
        // `lbu`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(LBU),.i_rs(0),.i_immediate('he));    
        // `lh`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(LH),.i_rs(0),.i_immediate('he));
        // `lhu`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(LHU),.i_rs(0),.i_immediate('he));    
        // `sw`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(Sw));
    endtask 
    
    // Helper Functions     
    task automatic RegFileValue
        (
            input bit [5:0] register,
            input logic [31:0] value = 'hxxxx_xxxx
        );
        if (value === 'hxxxx_xxxx) begin
           // `addi`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(ADDI),.i_rs(0),.i_rt(register)); 
        end else begin
            // `addi`
            @(negedge clk);
            instr = mips_instr.get_Instr(.i_opcode(ADDI),.i_rs(0),.i_rt(register),.i_immediate(value));
        end
    endtask

    task automatic RegisterFileFilling();
        for (int i = 0; i<= 32; i++) begin
            RegFileValue(.register(i));
        end
    endtask 
    
    // Random Testing
        task automatic RandomTesting(int RepeatNumber = 10);
                // Reset
                    Reset();
                // Phase 1 Part 1 Testing
                mips_instr.phase1_part1.constraint_mode(1);
                repeat(RepeatNumber)begin
                    @(negedge clk);
                    assert (mips_instr.randomize());
                    instr = mips_instr.get_Instr();
                end
        endtask 
endmodule