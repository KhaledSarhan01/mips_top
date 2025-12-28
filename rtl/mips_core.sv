import mips_pkg::*;
module mips_core (
    input clk,rst_n,
    // To instruction Memory
    output [PC_WIDTH-1:0]     pc,
    input  [INSTR_WITDTH-1:0] instr,
    // To Data Memory
    output memwrite,
    output [DATA_MEM_WIDTH-1:0] memaddr,writedata,
    input  [DATA_MEM_WIDTH-1:0] readdata
);
    // Control Signals 
        logic memtoreg;
        logic pcsrc;
        logic alusrc;
        logic regdst;
        logic regwrite;
        logic jump;
        logic [ALU_CTRL_WIDTH-1:0] alucontrl;

    // Status Signals
        logic zero;
    
    mips_controller u_mips_control (
        .clk(clk),
        .rst_n(rst_n),
        .instr(instr),
        .zero(zero),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrl(alucontrl)
    );

    mips_datapath u_mips_datapath(
        .clk(clk),    
        .rst_n(rst_n),
        .instr(instr),
        .pc(pc),
        .aluout(memaddr),
        .writedata(writedata),
        .readdata(readdata),
        .zero(zero),
        .memtoreg(memtoreg),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrl(alucontrl)
    );
endmodule