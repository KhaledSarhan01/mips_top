////////////////////////////////////////////////
///// Project   : mips_top             
///// Created on: 2025-11-20                   
////////////////////////////////////////////////

`define GET_REG(idx) u_mips_core.u_mips_decode_stage.u_decode_regfile.registers[idx]
import mips_pkg::*;
module tb_mips_top ;
//////////////////////////////////////
////////////// Signals //////////////
////////////////////////////////////
    logic clk,rst_n;
    logic [31:0] s0;
    // To instruction Memory
    logic [PC_WIDTH-1:0]     pc;
    logic [INSTR_WITDTH-1:0] instr;
    logic arth_overflow_exception;
    // To Data Memory
    logic memwrite;
    logic [DATA_MEM_WIDTH-1:0] memaddr,writedata;
    logic [DATA_MEM_WIDTH-1:0] readdata;
    
//////////////////////////////////////
//////////////// Test ///////////////
////////////////////////////////////
    /*
        - [x] Test 1
        - [x] Test 2
        - [] Test 3
        - [] Test 4
        - [] Test 5
    */
    parameter test_name = "Test3";

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

instr_mem #(.DEPTH(4096),.WIDTH(8),.test_name(test_name)) u_instr_mem(
    .clk(clk),
    .rst_n(rst_n),
    .address(pc),
    .data_out(instr)
);

data_mem #(.DEPTH(4096),.WIDTH(8)) u_data_mem (
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
        repeat(100) @(negedge clk);
        $display("$s0= %h",`GET_REG(16));
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
    task Initialization;
        // Initialize your Signals Here
        
    endtask
    task Main_Scenario();
        // Write your Test Scenario Here
    endtask
// For Wave Debuging
    logic [31:0] f_instr,d_instr,e_instr,m_instr,wb_instr;
    assign f_instr  = instr;
    assign d_instr  = u_mips_core.d_instr;
    assign e_instr  = u_mips_core.e_instr;
    assign m_instr  = u_mips_core.m_instr;
    assign wb_instr = u_mips_core.wb_instr;
    
    opcode_t    f_opcode,d_opcode,e_opcode,m_opcode,wb_opcode;
    funct_t     f_funct,d_funct,e_funct,m_funct,wb_funct;
    rfaddr_t    f_rs,d_rs,e_rs,m_rs,wb_rs;
    rfaddr_t    f_rt,d_rt,e_rt,m_rt,wb_rt;
    rfaddr_t    f_rd,d_rd,e_rd,m_rd,wb_rd;
    shmat_t     f_shmat,d_shmat,e_shmat,m_shmat,wb_shmat;
    immediate_t f_imm,d_imm,e_imm,m_imm,wb_imm;
    jaddress_t  f_jaddr,d_jaddr,e_jaddr,m_jaddr,wb_jaddr;
    
    assign f_opcode = opcode_t'(f_instr[31:26]);
    assign f_rs     = rfaddr_t'(f_instr[25:21]);
    assign f_rt     = rfaddr_t'(f_instr[20:16]);
    assign f_rd     = rfaddr_t'(f_instr[15:11]);
    assign f_funct  = funct_t'( f_instr[5:0]);
    assign f_shmat  = shmat_t'( f_instr[10:6]);  
    assign f_imm    = immediate_t'(f_instr[15:0]);
    assign f_jaddr  = jaddress_t'( f_instr[25:0]);
    
    assign d_opcode = opcode_t'(d_instr[31:26]);
    assign d_rs     = rfaddr_t'(d_instr[25:21]);
    assign d_rt     = rfaddr_t'(d_instr[20:16]);
    assign d_rd     = rfaddr_t'(d_instr[15:11]);
    assign d_funct  = funct_t'( d_instr[5:0]);
    assign d_shmat  = shmat_t'( d_instr[10:6]);  
    assign d_imm    = immediate_t'(d_instr[15:0]);
    assign d_jaddr  = jaddress_t'( d_instr[25:0]);
    
    assign e_opcode = opcode_t'(e_instr[31:26]);
    assign e_rs     = rfaddr_t'(e_instr[25:21]);
    assign e_rt     = rfaddr_t'(e_instr[20:16]);
    assign e_rd     = rfaddr_t'(e_instr[15:11]);
    assign e_funct  = funct_t'( e_instr[5:0]);
    assign e_shmat  = shmat_t'( e_instr[10:6]);  
    assign e_imm    = immediate_t'(e_instr[15:0]);
    assign e_jaddr  = jaddress_t'( e_instr[25:0]);
    
    assign m_opcode = opcode_t'(m_instr[31:26]);
    assign m_rs     = rfaddr_t'(m_instr[25:21]);
    assign m_rt     = rfaddr_t'(m_instr[20:16]);
    assign m_rd     = rfaddr_t'(m_instr[15:11]);
    assign m_funct  = funct_t'( m_instr[5:0]);
    assign m_shmat  = shmat_t'( m_instr[10:6]);  
    assign m_imm    = immediate_t'(m_instr[15:0]);
    assign m_jaddr  = jaddress_t'( m_instr[25:0]);
    
    assign wb_opcode = opcode_t'(wb_instr[31:26]);
    assign wb_rs     = rfaddr_t'(wb_instr[25:21]);
    assign wb_rt     = rfaddr_t'(wb_instr[20:16]);
    assign wb_rd     = rfaddr_t'(wb_instr[15:11]);
    assign wb_funct  = funct_t'( wb_instr[5:0]);
    assign wb_shmat  = shmat_t'( wb_instr[10:6]);  
    assign wb_imm    = immediate_t'(wb_instr[15:0]);
    assign wb_jaddr  = jaddress_t'( wb_instr[25:0]);
endmodule
