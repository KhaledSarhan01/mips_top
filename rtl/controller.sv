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
    // PC Source
        assign pcsrc = branch & zero;    
    endmodule