import mips_pkg::*;
module fetch_stage (
    input  logic clk,rst_n, 
    // instruction Memory
    output [PC_WIDTH-1:0]     pc,
    input  [INSTR_WITDTH-1:0] instr, 
    // Pipeline inputs
    input logic [1:0]  f_pcsrc,
    input logic [31:0] f_regfile,
    input logic [31:0] f_BTA,f_JTA,
    // Pipeline outputs
    output logic [31:0] d_pc,
    output logic [31:0] d_instr,
    output logic [31:0] d_pc_plus4,
    // Hazard
    input  logic pc_stall,
    input  logic f2d_flush,
    input  logic f2d_stall  
);
// PC
    logic [31:0] f_pc_plus4;
    logic [31:0] f_pc;
    pc_reg u_fetch_pc(
        .clk(clk),
        .rst_n(rst_n),
        .pcsrc(f_pcsrc),
        .regfile(f_regfile),
        .BTA(f_BTA),
        .JTA(f_JTA),
        .pc_stall(pc_stall),
        .pc_plus4(f_pc_plus4),
        .pc_next(f_pc) 
    ); 
// Instruction Memory 
    logic [INSTR_WITDTH-1:0] f_instr;
    assign pc      = f_pc;
    assign f_instr = instr;
// Fetch Decode Register
    always_ff @( posedge clk or negedge rst_n ) begin 
        if (!rst_n) begin
            d_pc       <= 'b0;
            d_instr    <= 'b0;
            d_pc_plus4 <= 'b0;
        end else begin
            if(f2d_flush)begin
                d_pc       <= 'b0;
                d_instr    <= 'b0;
                d_pc_plus4 <= 'b0;
            end else if(~f2d_stall)begin
                d_pc       <= f_pc;
                d_instr    <= f_instr;
                d_pc_plus4 <= f_pc_plus4; 
            end
        end
    end
endmodule