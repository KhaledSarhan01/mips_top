////////////////////////////////////////////////
///// Project   : mips_top             
///// Created on: 2025-11-20                   
////////////////////////////////////////////////

`define GET_REG(idx) u_mips_core.u_decode_regfile.registers[idx]
import mips_pkg::*;
module tb_mips_top ;
//////////////////////////////////////
////////////// Signals //////////////
////////////////////////////////////
    logic clk,rst_n;
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

    parameter test_name = "Test1";

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
endmodule
