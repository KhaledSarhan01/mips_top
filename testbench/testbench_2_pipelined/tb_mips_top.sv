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
    logic arth_overflow_exception;
    logic [31:0] s0;
    
    // For Wave Debuging
    opcode_t    instr_opcode;
    funct_t     instr_funct;
    rfaddr_t    instr_rs,instr_rt,instr_rd;
    shmat_t     instr_shmat;
    immediate_t instr_imm;
    jaddress_t  instr_jaddr;
    
    assign instr_opcode = opcode_t'(instr[31:26]);
    assign instr_funct  = funct_t'(instr[5:0]);
    assign instr_rs  = rfaddr_t'(instr[25:21]);
    assign instr_rt  = rfaddr_t'(instr[20:16]);
    assign instr_rd  = rfaddr_t'(instr[15:11]);
    assign instr_imm = immediate_t'(instr[15:0]);
    assign instr_shmat = shmat_t'(instr[10:6]);
    assign instr_jaddr = jaddress_t'(instr[25:0]);
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
        .s0(s0),
        .arth_overflow_exception(arth_overflow_exception),
        // To instruction Memory
        .pc(pc),
        .instr(instr),
        // To Data Memory
        .memwrite(memwrite),
        .memaddr(memaddr),
        .writedata(writedata),
        .readdata(readdata)
    );

    mips_testbench u_mips_tb( // act as Virtual instruction Memory
        .clk(clk),
        .rst_n(rst_n),
        // To instruction Memory
        .pc(pc),
        .instr(instr)
    );
//////////////////////////////////////
///////////// Assertions ////////////
////////////////////////////////////
    `ifdef ASSERTIONS
        bind mips_core mips_sva u_mips_sva(
        .clk(clk),
        .rst_n(rst_n),
        // To instruction Memory
        .pc(pc),
        .instr(instr),
        .arth_overflow_exception(arth_overflow_exception),
        // To Data Memory
        .memwrite(memwrite),
        .memaddr(memaddr),
        .writedata(writedata),
        .readdata(readdata)
        ); 
    `endif    
endmodule
