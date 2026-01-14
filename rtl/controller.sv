import mips_pkg::*;
module mips_controller (
        input clk,rst_n,
        input [INSTR_WITDTH-1:0] instr,
        input zero,
        output logic memwrite,
        output logic pcsrc,
        output logic [ALU_SRC_WIDTH-1:0] alusrc,
        output logic [REG_WR_ADDR_WIDTH-1:0] regdst,
        output logic regwrite,
        output logic jump, // To be removed in future    
        output logic [ALU_CTRL_WIDTH-1:0] alucontrl,
        output logic [REG_WR_SRC_WIDTH-1:0] write_back_sel,
        output logic hi_write,lo_write,
        output logic [HI_LO_SEL_WIDTH-1:0] hi_select,lo_select
    );

    // Main Decoder
        // logic write_back_sel;
        logic [1:0] aluop;
        opcode_t instr_opcode;
        funct_t instr_funct;
        assign instr_opcode = opcode_t'(instr[31:26]);
        assign instr_funct  = funct_t'(instr[5:0]);
        
        always_comb begin
            // Defualt Values
                regwrite        = 'b0;
                regdst          = 'b0; 
                alusrc          = 'b0; 
                pcsrc           = 'b0;
                memwrite        = 'b0;
                write_back_sel  = 'b000;
                jump            = 'b0;
                aluop           = 'b00;
                hi_write        = 'b0;
                lo_write        = 'b0;
                hi_select       = 'b00;
                lo_select       = 'b00;
            // Override by case statement
            case(instr_opcode)
                RType:  
                    case (instr_funct) 
                        JALR: begin //JALR
                            regwrite = 'b1;
                            regdst   = 'b10;
                            alusrc   = 'b10;
                            write_back_sel = 'b100;
                            jump = 'b1;
                            pcsrc = 'b1; 
                        end
                        MFHI: begin //MFHI 
                            regwrite = 'b1;
                            regdst   = 'b1;
                            write_back_sel = 'b10;
                        end
                        MFLO: begin //MFLO
                            regwrite = 'b1;
                            regdst   = 'b1;
                            write_back_sel = 'b11;
                        end
                        MTHI: begin //MTHI
                            hi_write = 'b1;
                            hi_select = 'b01;
                        end
                        MTLO: begin //MTLO 
                            lo_write = 'b1;
                            lo_select = 'b01;
                        end
                        DIV: begin //DIV
                            hi_write = 'b1;
                            lo_write = 'b1;
                            hi_select = 'b10;
                            lo_select = 'b10;
                        end
                        MULT: begin //MULT
                            hi_write = 'b1;
                            lo_write = 'b1;
                            hi_select = 'b11;
                            lo_select = 'b11;
                        end
                        JR:begin// Jump Register
                            alusrc   = 'b10;
                            pcsrc    = 'b1;
                            jump     = 'b1;
                        end 
                        default: begin //Rtype
                            regwrite = 'b1;
                            regdst   = 'b1;
                            aluop    = 'b10;
                        end
                    endcase
                JAL: begin // JAL
                    regwrite = 'b1;
                    regdst   = 'b10;
                    write_back_sel = 'b100;
                    jump = 1'b1;
                end
                LW: begin //LW
                    regwrite = 'b1; 
                    alusrc   = 'b1;
                    write_back_sel = 'b1;
                end
                Sw:begin //SW 
                    alusrc   = 'b1; 
                    memwrite = 'b1;
                end
                BEQ:begin //BEQ
                    pcsrc    = zero;
                    aluop    = 'b01;
                end
                ADDI:begin //ADDI
                    regwrite = 'b1; 
                    alusrc   = 'b1;
                end
                J: begin //J
                    jump     = 'b1;
                end
                default: begin
                    regwrite = 'bx;
                    regdst   = 'bx; 
                    alusrc   = 'bx; 
                    pcsrc    = 'bx;
                    memwrite = 'bx;
                    write_back_sel = 'bx;
                    jump     = 'bx;
                    aluop    = 'bxx;

                    hi_write = 'bx;
                    lo_write = 'bx;
                    hi_select = 'bxx;
                    lo_select = 'bxx;
                end
            endcase
        end 

    // ALU Decoder 
        always_comb begin
            case(aluop)
                2'b00: alucontrl = 'b0010; // add
                2'b01: alucontrl = 'b0110; // sub
                2'b10,2'b11: begin 
                    case(instr_funct)        // RTYPE
                        SLL:  alucontrl = 'b1000; // SLL 
                        SRL:  alucontrl = 'b1001; // SRL 
                        SRA:  alucontrl = 'b1010; // SRA 
                        SLLV: alucontrl = 'b1011; // SLLV 
                        SRLV: alucontrl = 'b1100; // SRLV 
                        SRAV: alucontrl = 'b1101; // SRAV 
                        ADD:  alucontrl = 'b0010; // ADD
                        SUB:  alucontrl = 'b0110; // SUB
                        AND:  alucontrl = 'b0000; // AND
                        OR:   alucontrl = 'b0001; // OR
                        XOR:  alucontrl = 'b0011; // XOR
                        NOR:  alucontrl = 'b0100; // NOR
                        SLT:  alucontrl = 'b0111; // SLT
                        default:   alucontrl = 'bxxxx; // ???
                    endcase
                end
            endcase
        end
    // // LO & HI Register Controls
    //     logic [1:0] lo_hi_select;
    //     logic [7:0] controls_lo_hi; 
    //     assign {lo_hi_select,hi_write,lo_write,hi_select,lo_select} = controls_lo_hi; 
    //     // assign write_back_sel = lo_hi_select[1]? {1'b1,lo_hi_select[0]}:{1'b0,write_back_sel};

    //     always_comb begin 
    //         case (instr_funct)
    //             6'b010000: controls_lo_hi = 'b10_0_0_00_00; //MFHI  
    //             6'b010001: controls_lo_hi = 'b00_1_0_01_00; //MTHI
    //             6'b010010: controls_lo_hi = 'b11_0_0_00_00; //MFLO
    //             6'b010011: controls_lo_hi = 'b00_0_1_00_01; //MTLO
    //             6'b011000: controls_lo_hi = 'b00_1_1_11_11; //MULT
    //             6'b011010: controls_lo_hi = 'b00_1_1_10_10; //DIV
    //             default: controls_lo_hi = 'b0;
    //         endcase
    //     end
endmodule