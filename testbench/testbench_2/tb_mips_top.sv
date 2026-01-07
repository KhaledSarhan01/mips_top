////////////////////////////////////////////////
///// Project   : mips_top             
///// Created on: 2025-11-20                   
////////////////////////////////////////////////

module tb_mips_top ;
import mips_isa_pkg::*;
import mips_pkg::*;
// import TestSequence::*;
//////////////////////////////////////
////////////// Signals //////////////
////////////////////////////////////
    logic clk,rst_n;
    // To instruction Memory
    logic [PC_WIDTH-1:0]     pc;
    logic [INSTR_WITDTH-1:0] instr;
    // To Data Memory
    logic memwrite;
    logic [DATA_MEM_WIDTH-1:0] memaddr,writedata;
    logic [DATA_MEM_WIDTH-1:0] readdata;

//////////////////////////////////////
///////// Clock Generation //////////
////////////////////////////////////
    localparam CLK_PERIOD = 10;
    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
//////////////////////////////////////
/////////// Instantiation ///////////
////////////////////////////////////

    data_mem #(.DEPTH(256),.WIDTH(8)) u_data_mem (
        .clk(clk),
        .rst_n(rst_n),
        .address(memaddr),
        // input for write operation
        .write_en(memwrite),
        .data_in(writedata),
        // output for read operation
        .data_out(readdata)
    );

    mips_core u_mips_core(
        .clk(clk),
        .rst_n(rst_n),
        // To instruction Memory
        .pc(pc),
        .instr(instr),
        // To Data Memory
        .memwrite(memwrite),
        .memaddr(memaddr),
        .writedata(writedata),
        .readdata(readdata)
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
            DirectTesting();
        // Randomized Testing
            RandomTesting(10);                                         
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
    task automatic DirectTesting();
        //Filling the Register with random Data 
            RegisterFileFilling();
        // Testing the already implemented instructions
            AluRemainingOpearations();
            Phase1Part1();
    endtask 
    task automatic RegisterFileFilling();
        for (int i = 0; i<= 32; i++) begin
            // `addi`
            @(negedge clk);
            assert (mips_instr.randomize());
            instr = mips_instr.get_Instr(.i_opcode(ADDI),.i_rs(0),.i_rt(i));
        end
    endtask //automatic
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
            // `j`
                @(negedge clk);
                assert (mips_instr.randomize());
                instr = mips_instr.get_Instr(.i_opcode(J));
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
    endtask //automatic
    task automatic AluRemainingOpearations();
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
            
    endtask //automatic 
endmodule
