import mips_pkg::*;
module mips_core (
    input clk,rst_n,
    // To instruction Memory
    output [PC_WIDTH-1:0]     pc,
    input  [INSTR_WITDTH-1:0] instr,
   // output [31:0] s0,
    // To Data Memory
    output memwrite,
    output [DATA_MEM_WIDTH-1:0] memaddr,writedata,
    input  [DATA_MEM_WIDTH-1:0] readdata
);
    // Control Signals 
        logic pcsrc;
        logic [ALU_SRC_WIDTH-1:0] alusrc;
        logic [REG_WR_ADDR_WIDTH-1:0] regdst;
        logic regwrite;
        logic jump; // To be removed in future    
        logic [ALU_CTRL_WIDTH-1:0] alucontrl;
        logic [REG_WR_SRC_WIDTH-1:0] write_back_sel;
        logic hi_write,lo_write;
        logic [HI_LO_SEL_WIDTH-1:0] hi_select,lo_select;

    // Status Signals
        logic zero_flag,neg_flag;
    
    mips_controller u_mips_control (
        .clk(clk),
        .rst_n(rst_n),
        .instr(instr),
        .zero_flag(zero_flag),
        .neg_flag(neg_flag),
        .memwrite(memwrite),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrl(alucontrl),
        .write_back_sel(write_back_sel),
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
        .zero_flag(zero_flag),
        .neg_flag(neg_flag),
        .pcsrc(pcsrc),
        //.s0(s0),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrl(alucontrl),
        .write_back_sel(write_back_sel),
        .hi_write(hi_write),
        .lo_write(lo_write),
        .hi_select(hi_select),
        .lo_select(lo_select)
    );
endmodule