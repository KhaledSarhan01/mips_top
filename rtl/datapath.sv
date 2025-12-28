import mips_pkg::*;
module mips_datapath(
    input  logic clk,rst_n,
    // Instruction Memory Signals
    input  logic [INSTR_WITDTH-1:0] instr,
    output logic [PC_WIDTH-1:0] pc,
    // Data Memory Signals 
    output logic [DATA_MEM_WIDTH-1:0] aluout,
    output logic [DATA_MEM_WIDTH-1:0] writedata,
    input  logic [DATA_MEM_WIDTH-1:0] readdata,
    // Status signals 
    output logic zero,
    // Control Signals
    input  logic memtoreg,
    input  logic pcsrc,
    input  logic alusrc,
    input  logic regdst,
    input  logic regwrite,
    input  logic jump,
    input  logic [ALU_CTRL_WIDTH-1:0] alucontrl
);
    wire [4:0]  writereg;
    wire [31:0] signimm;
    wire [31:0] srca, srcb;
    wire [31:0] result;
    
    wire [4:0] instr_rs,instr_rt,instr_rd;
    wire [15:0] instr_imm;
    assign instr_rs  = instr[25:21];
    assign instr_rt  = instr[20:16];
    assign instr_rd  = instr[15:11];
    assign instr_imm = instr[15:0];
    // wire [4:0] instr_shamt;
    // assign instr_shamt = instr[10:6];

    // next PC logic
        pc_reg u_mips_datapath_pc(
            .clk(clk),
            .rst_n(rst_n),
            .pcsrc(pcsrc),
            .signimm(signimm),
            .jump(jump),
            .instr(instr),
            .pc_next(pc)
        );
    // register file logic
        reg_file u_mips_datapath_regfile(
            .clk(clk),
            .rst_n(rst_n),
            // Read port 1
            .read_addr1(instr_rs),
            .read_data1(srca),
            // Read port 2
            .read_addr2(instr_rt),    
            .read_data2(writedata),
            // Write port
            .write_addr(writereg),
            .write_data(result),
            .write_enable(regwrite)
        );
        
        mux2 #(5) u_mips_datapath_wrmux(
            .in0(instr[20:16]), 
            .in1(instr_rd),
            .sel(regdst), 
            .out(writereg)
        );
        
        mux2 #(32) u_mips_datapath_resmux(
            .in0(aluout), 
            .in1(readdata),
            .sel(memtoreg), 
            .out(result)
        );
        
        sign_extended u_mips_datapath_se (
            .in_data(instr_imm),
            .out_data(signimm)
        );
        
    // ALU logic
        mux2 #(32) u_mips_datapath_srcbmux (   
            .in0(writedata),
            .in1(signimm), 
            .sel(alusrc),
            .out(srcb)
        );
        alu u_mips_datapath_alu(
            // input operands 
            .operand_a(srca),
            .operand_b(srcb),
            // ALU control signal
            .alu_control(alucontrl),
            // output result
            .alu_result(aluout),
            // Flag 
            .zero_flag(zero)
        );

endmodule