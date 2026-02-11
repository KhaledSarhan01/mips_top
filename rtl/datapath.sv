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
    output logic [31:0] s0,
    // Status signals 
    output logic zero_flag,
    output logic neg_flag,
    output logic overflow_flag,
    // Control Signals
    input logic [1:0] pcsrc,
    input logic [2:0] se_select,wb_se_select,
    input logic [ALU_SRC_WIDTH-1:0] alusrc,
    input logic [REG_WR_ADDR_WIDTH-1:0] regdst,
    input logic regwrite,  
    input logic [ALU_CTRL_WIDTH-1:0] alucontrl,
    input logic [REG_WR_SRC_WIDTH-1:0] write_back_sel,
    input logic hi_write,lo_write,
    input logic unsigned_mult,unsigned_div,
    input logic [HI_LO_SEL_WIDTH-1:0] hi_select,lo_select
);
    wire [4:0]  writereg;
    wire [31:0] signimm;
    wire [31:0] pc_plus4;
    wire [31:0] data_rs, data_rt;
    wire [31:0] srcb;
    wire [31:0] hi_reg,lo_reg;
    wire [31:0] data_regwrite;
    wire [31:0] mult_lo,mult_hi;
    wire [31:0] div_lo,div_hi;
    wire [31:0] mem_se_data;

    wire [4:0] instr_rs,instr_rt,instr_rd;
    wire [4:0] instr_shmat;
    wire [15:0] instr_imm;
    wire [25:0] instr_jaddress ;
    assign instr_rs         = instr[25:21];
    assign instr_rt         = instr[20:16];
    assign instr_rd         = instr[15:11];
    assign instr_imm        = instr[15:0];
    assign instr_shmat      = instr[10:6];
    assign instr_jaddress   = instr[25:0];

    // next PC logic
        // next PC logic
        logic [31:0] BTA,JTA;
        assign BTA = pc_plus4 + (signimm << 2);                // Branch target
        assign JTA = {pc[31:28], instr_jaddress, 2'b00};       // Jump target
            
        pc_reg u_mips_datapath_pc(
            .clk(clk),
            .rst_n(rst_n),
            .pcsrc(pcsrc),
            .BTA(BTA),
            .JTA(JTA),
            .regfile(data_rs),
            .pc_plus4(pc_plus4),
            .pc_next(pc)
        );
    // register file logic
        reg_file u_mips_datapath_regfile(
            .clk(clk),
            .rst_n(rst_n),
            .s0(s0),
            // Read port 1
            .read_addr1(instr_rs),
            .read_data1(data_rs),
            // Read port 2
            .read_addr2(instr_rt),    
            .read_data2(data_rt),
            // Write port
            .write_addr(writereg),
            .write_data(data_regwrite),
            .write_enable(regwrite)
        );
        
        mux4 #(5) u_mips_datapath_wrmux(
            .in0(instr_rt), 
            .in1(instr_rd),
            .in2(5'd31),
            .in3(5'd0),
            .sel(regdst), 
            .out(writereg)
        );

        sign_extended u_mips_datapath_se (
            .in_data(instr_imm),
            .se_select(se_select),
            .out_data(signimm)
        );
        
    // ALU logic
        mux4 #(32) u_mips_datapath_srcbmux (   
            .in0(data_rt),
            .in1(signimm),
            .in2('b0),
            .in3('b0), 
            .sel(alusrc),
            .out(srcb)
        );
        alu u_mips_datapath_alu(
            // input operands 
            .operand_a(data_rs),
            .operand_b(srcb),
            .shmat(instr_shmat),
            // ALU control signal
            .alu_control(alucontrl),
            // output result
            .alu_result(aluout),
            // Flag 
            .zero_flag(zero_flag),
            .overflow_flag(overflow_flag),
            .neg_flag(neg_flag)
        );
    // Multipler and Divider
        multipler u_mips_datapath_mult(
            // input clk,rst_n
            .operand_a(data_rs),
            .operand_b(data_rt),
            .unsigned_mult(unsigned_mult),
            .out_hi(mult_hi),
            .out_lo(mult_lo)
        ); 
//        divider u_mips_datapath_div(
//            // input clk,rst_n,
//            .operand_a(data_rs),
//            .operand_b(data_rt),
//            .unsigned_div(unsigned_div),
//            .out_hi(div_hi),
//            .out_lo(div_lo)
//        ); 
        assign div_hi = 'b0;
        assign div_lo = 'b0;
    // LO and HI Registers
        lo_hi_reg u_mips_datapath_lo_hi_reg(
            // Clock and Active Low Reset
                .clk(clk),
                .rst_n(rst_n),
            // Inputs 
                .reg_file(data_rs),
                .mult_lo(mult_lo),
                .mult_hi(mult_hi),
                .div_lo(div_lo),
                .div_hi(div_hi),
            // Controls
                .hi_write(hi_write),
                .lo_write(lo_write),
                .hi_select(hi_select),
                .lo_select(lo_select),
            // Outputs
                .lo_reg(lo_reg),
                .hi_reg(hi_reg)        
        );
    // Write Back Logic     
        mux8 #(32) u_mips_datapath_wbmux(
            .in0(aluout), 
            .in1(readdata),
            .in2(hi_reg),
            .in3(lo_reg),
            .in4(pc_plus4),
            .in5(signimm),
            .in6(mult_lo),
            .in7(mem_se_data),
            .sel(write_back_sel), 
            .out(data_regwrite)
        ); 
    sign_extended u_mips_datapath_write_back_signextent (
            .in_data(readdata[15:0]),
            .se_select(wb_se_select),
            .out_data(mem_se_data)
        );    
    // Data Memory Output    
        assign writedata = data_rt;
       
endmodule