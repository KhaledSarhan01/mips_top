module mips_testbench (
    input logic clk,rst_n,
    // To instruction Memory
    input  logic [PC_WIDTH-1:0]     pc,
    output logic [INSTR_WITDTH-1:0] instr
);
// It works as instruction Memory 
import mips_isa_pkg::*;
import mips_pkg::*;
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
            //Filling the Register with random Data 
                RegisterFileFilling();
            // Testing the already implemented instructions
                JumpInstructions();
                MultDivTesting();
                HiLoReg_MoveOps();
                AluInstructions();
                Phase1Part1();
        // Randomized Testing
            // RandomTesting(10);                                         
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
    // Direct Testing
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
        task automatic RegisterFileFilling();
            for (int i = 0; i<= 32; i++) begin
                // `addi`
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(ADDI),.i_rs(0),.i_rt(i));
            end
        endtask 
        task automatic Phase1Part1();
                // `lw`
                    @(negedge clk);
                    assert (mips_instr.randomize());
                    instr = mips_instr.get_Instr(.i_opcode(LW));
                // `sw`
                    @(negedge clk);
                    assert (mips_instr.randomize());
                    instr = mips_instr.get_Instr(.i_opcode(Sw));
                // `beq`
                    @(negedge clk);
                    assert (mips_instr.randomize());
                    instr = mips_instr.get_Instr(.i_opcode(BEQ));
                // `addi`
                    @(negedge clk);
                    assert (mips_instr.randomize());
                    instr = mips_instr.get_Instr(.i_opcode(ADDI));
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
    
endmodule