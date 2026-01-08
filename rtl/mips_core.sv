import mips_pkg::*;
module mips_core (
    input clk,rst_n,
    // To instruction Memory
    output [PC_WIDTH-1:0]     pc,
    input  [INSTR_WITDTH-1:0] instr,
    output [31:0] s0,
    // To Data Memory
    output memwrite,
    output [DATA_MEM_WIDTH-1:0] memaddr,writedata,
    input  [DATA_MEM_WIDTH-1:0] readdata
);
    // Control Signals 
        logic pcsrc;
        logic [1:0] alusrc;
        logic regdst;
        logic regwrite;
        logic jump;
        logic [ALU_CTRL_WIDTH-1:0] alucontrl;
        logic [REG_WR_SRC_WIDTH-1:0] select_regwrite;
        logic hi_write,lo_write;
        logic [HI_LO_SEL_WIDTH-1:0] hi_select,lo_select;

    // Status Signals
        logic zero;
    
    mips_controller u_mips_control (
        .clk(clk),
        .rst_n(rst_n),
        .instr(instr),
        .zero(zero),
        .memwrite(memwrite),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrl(alucontrl),
        .select_regwrite(select_regwrite),
        .hi_write(hi_write),
        .lo_write(lo_write),
        .hi_select(hi_select),
        .lo_select(lo_select)
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
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrl(alucontrl),
        .select_regwrite(select_regwrite),
        .hi_write(hi_write),
        .lo_write(lo_write),
        .hi_select(hi_select),
        .lo_select(lo_select),
        .s0(s0)
    );
endmodule