import mips_pkg::*;
module mips_controller (
        input clk,rst_n,
        input [INSTR_WITDTH-1:0] instr,
        input zero,
        output logic memwrite,
        output logic pcsrc,
        output logic [1:0] alusrc,
        output logic regdst,
        output logic regwrite,
        output logic jump,    
        output logic [ALU_CTRL_WIDTH-1:0] alucontrl,
        output logic [REG_WR_SRC_WIDTH-1:0] select_regwrite,
        output logic hi_write,lo_write,
        output logic [HI_LO_SEL_WIDTH-1:0] hi_select,lo_select
    );

    // Main Decoder
        logic memtoreg;
        logic [1:0] aluop;
        logic [5:0] instr_funct;
        logic [5:0] instr_opcode;
        assign instr_opcode = instr[31:26];
        assign instr_funct  = instr[5:0];
        
        always_comb begin
            case(instr_opcode)
                6'b000000: begin 
                    if (instr_funct == 6'b010000 || instr_funct == 6'b010010) begin 
                    // Move From Hi/Lo
                        regwrite = 1'b1;
                        regdst   = 1'b1; 
                        alusrc   = 2'b0; 
                        pcsrc = 1'b0;
                        memwrite = 1'b0;
                        memtoreg = 1'b0;
                        jump     = 1'b0;
                        aluop    = 2'b00;
                    end else if (instr_funct == 6'b010001 || instr_funct == 6'b010011 ||instr_funct == 6'b011010 || instr_funct == 6'b011000 ) begin 
                    // Move into Hi/Lo OR mult/div
                        regwrite = 1'b0;
                        regdst   = 1'b0; 
                        alusrc   = 2'b0; 
                        pcsrc    = 1'b0;
                        memwrite = 1'b0;
                        memtoreg = 1'b0;
                        jump     = 1'b0;
                        aluop    = 2'b00;
                    end else if(instr_funct == 6'b001000)begin
                    // Jump Register
                        regwrite = 1'b0;
                        regdst   = 1'b0; 
                        alusrc   = 2'b10;
                        aluop    = 2'b00; 
                        memwrite = 1'b0;
                        memtoreg = 1'b0;
                        pcsrc    = 1'b1;
                        jump     = 1'b1;
                    end else begin
                    //Rtype
                        regwrite = 1'b1;
                        regdst   = 1'b1; 
                        alusrc   = 2'b0; 
                        pcsrc    = 1'b0;
                        memwrite = 1'b0;
                        memtoreg = 1'b0;
                        jump     = 1'b0;
                        aluop    = 2'b10;
                    end
                end 
                6'b100011: begin //LW
                    regwrite = 1'b1;
                    regdst   = 1'b0; 
                    alusrc   = 2'b1; 
                    pcsrc    = 1'b0;
                    memwrite = 1'b0;
                    memtoreg = 1'b1;
                    jump     = 1'b0;
                    aluop    = 2'b00;
                end
                6'b101011:begin //SW
                    regwrite = 1'b0;
                    regdst   = 1'b0; 
                    alusrc   = 2'b1; 
                    pcsrc    = 1'b0;
                    memwrite = 1'b1;
                    memtoreg = 1'b0;
                    jump     = 1'b0;
                    aluop    = 2'b00;
                end
                6'b000100:begin //BEQ
                    regwrite = 1'b0;
                    regdst   = 1'b0; 
                    alusrc   = 2'b0; 
                    pcsrc    = zero;
                    memwrite = 1'b0;
                    memtoreg = 1'b0;
                    jump     = 1'b0;
                    aluop    = 2'b01;
                end
                6'b001000:begin //ADDI
                    regwrite = 1'b1;
                    regdst   = 1'b0; 
                    alusrc   = 2'b1; 
                    pcsrc    = 1'b0;
                    memwrite = 1'b0;
                    memtoreg = 1'b0;
                    jump     = 1'b0;
                    aluop    = 2'b00;
                end
                6'b000010: begin //J
                    regwrite = 1'b0;
                    regdst   = 1'b0; 
                    alusrc   = 2'b0; 
                    pcsrc    = 1'b0;
                    memwrite = 1'b0;
                    memtoreg = 1'b0;
                    jump     = 1'b1;
                    aluop    = 2'b00;
                end
                default: begin
                    regwrite = 1'bx;
                    regdst   = 1'bx; 
                    alusrc   = 2'bx; 
                    pcsrc    = 1'bx;
                    memwrite = 1'bx;
                    memtoreg = 1'bx;
                    jump     = 1'bx;
                    aluop    = 2'bxx;
                end
            endcase
        end 

    // ALU Decoder 
        always_comb begin
            case(aluop)
                2'b00: alucontrl = 4'b0010; // add
                2'b01: alucontrl = 4'b0110; // sub
                2'b10,2'b11: begin 
                    case(instr_funct)        // RTYPE
                        6'b000000: alucontrl = 4'b1000; // SLL 
                        6'b000010: alucontrl = 4'b1001; // SRL 
                        6'b000011: alucontrl = 4'b1010; // SRA 
                        6'b000100: alucontrl = 4'b1011; // SLLV 
                        6'b000110: alucontrl = 4'b1100; // SRLV 
                        6'b000111: alucontrl = 4'b1101; // SRAV 
                        6'b100000: alucontrl = 4'b0010; // ADD
                        6'b100010: alucontrl = 4'b0110; // SUB
                        6'b100100: alucontrl = 4'b0000; // AND
                        6'b100101: alucontrl = 4'b0001; // OR
                        6'b100110: alucontrl = 4'b0011; // XOR
                        6'b100111: alucontrl = 4'b0100; // NOR
                        6'b101010: alucontrl = 4'b0111; // SLT
                        default:   alucontrl = 4'bxxxx; // ???
                    endcase
                end
            endcase
        end
    // LO & HI Register Controls
        logic [1:0] lo_hi_select;
        logic [7:0] controls_lo_hi; 
        assign {lo_hi_select,hi_write,lo_write,hi_select,lo_select} = controls_lo_hi; 
        assign select_regwrite = lo_hi_select[1]? {1'b1,lo_hi_select[0]}:{1'b0,memtoreg};

        always_comb begin 
            case (instr_funct)
                6'b010000: controls_lo_hi = 8'b10_0_0_00_00; //MFHI  
                6'b010001: controls_lo_hi = 8'b00_1_0_01_00; //MTHI
                6'b010010: controls_lo_hi = 8'b11_0_0_00_00; //MFLO
                6'b010011: controls_lo_hi = 8'b00_0_1_00_01; //MTLO
                6'b011000: controls_lo_hi = 8'b00_1_1_11_11; //MULT
                6'b011010: controls_lo_hi = 8'b00_1_1_10_10; //DIV
                default: controls_lo_hi = 'b0;
            endcase
        end
endmodule