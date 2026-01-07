import mips_pkg::*;
module mips_controller (
        input clk,rst_n,
        input [INSTR_WITDTH-1:0] instr,
        input zero,
        output logic memtoreg,
        output logic memwrite,
        output logic pcsrc,
        output logic alusrc,
        output logic regdst,
        output logic regwrite,
        output logic jump,
        output logic [ALU_CTRL_WIDTH-1:0] alucontrl
    );


    // Main Decoder
        logic [8:0] controls;
        logic branch;
        logic [1:0] aluop;
        logic [5:0] instr_funct;
        logic [5:0] instr_opcode;
        assign instr_opcode = instr[31:26];
        assign instr_funct  = instr[5:0];
        assign {regwrite, regdst, alusrc, branch, memwrite, memtoreg, jump, aluop} = controls;

        always_comb begin
            case(instr_opcode)
                6'b000000: controls = 9'b110000010; //Rtyp
                6'b100011: controls = 9'b101001000; //LW
                6'b101011: controls = 9'b001010000; //SW
                6'b000100: controls = 9'b000100001; //BEQ
                6'b001000: controls = 9'b101000000; //ADDI
                6'b000010: controls = 9'b000000100; //J
                default:   controls = 9'bxxxxxxxxx; //???
            endcase
        end 

    // ALU Decoder 
        always_comb begin
            case(aluop)
                2'b00: alucontrl = 3'b010; // add
                2'b01: alucontrl = 3'b110; // sub
                default: begin 
                    case(instr_funct)        // RTYPE
                        6'b000000: alucontrl = 3'b010; // NOP 
                        6'b100000: alucontrl = 3'b010; // ADD
                        6'b100010: alucontrl = 3'b110; // SUB
                        6'b100100: alucontrl = 3'b000; // AND
                        6'b100101: alucontrl = 3'b001; // OR
                        6'b101010: alucontrl = 3'b111; // SLT
                        default:   alucontrl = 3'bxxx; // ???
                    endcase
                end
            endcase
        end
    // PC Source
        assign pcsrc = branch & zero;    
    endmodule