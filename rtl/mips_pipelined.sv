import mips_pkg::*;
module mips_core (
    input clk,rst_n,
    // To instruction Memory
    output [PC_WIDTH-1:0]     pc,
    input  [INSTR_WITDTH-1:0] instr,
    output logic arth_overflow_exception,
    output [31:0] s0,
    // To Data Memory
    output memwrite,
    output [DATA_MEM_WIDTH-1:0] memaddr,writedata,
    input  [DATA_MEM_WIDTH-1:0] readdata
);
    // Fetch Stage 
    // Decode Stage
    // Execute Stage
    // Memory Stage
    // Write Back Stage 
    
endmodule