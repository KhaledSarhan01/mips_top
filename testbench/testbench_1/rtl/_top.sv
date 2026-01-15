////////////////////////////////////////////////
///// Project   : mips_top             
///// Created on: 2025-11-20                   
////////////////////////////////////////////////
import mips_pkg::*;
module mips_top (
// Clock and active low Asynchronous Reset
    input logic clk,rst_n 
);

    // To instruction Memory
    logic [PC_WIDTH-1:0]     pc;
    logic [INSTR_WITDTH-1:0] instr;
    // To Data Memory
    logic memwrite;
    logic [DATA_MEM_WIDTH-1:0] memaddr,writedata;
    logic [DATA_MEM_WIDTH-1:0] readdata;

    instr_mem #(.DEPTH(256),.WIDTH(8)) u_instr_mem(
    .clk(clk),
    .rst_n(rst_n),
    .address(pc),
    .data_out(instr)
    );

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
endmodule
