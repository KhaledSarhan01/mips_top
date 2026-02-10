package mips_pkg;
    // ISA Parameters
    parameter OPCODE_WIDTH  = 6;  // Opcode bit field width 
    parameter OPCODE_LSB    = 26; // Opcode LSB Location
    parameter RFADDR_WIDTH  = 5;  // Register file address bit field width
    
    parameter R_RD_LSB      = 11; // R Type: Destination Register LSB Location
    parameter R_RT_LSB      = 16; // R Type: Target Register LSB Location
    parameter R_RS_LSB      = 21; // R Type: Source Register LSB Location
    parameter R_SHMAT_WIDTH = 5;  // R Type: shmat bit field width
    parameter R_SHMAT_LSB   = 6;  // R Type: shmat LSB Location
    parameter R_FUNCT_WIDTH = 6;  // R Type: Funct bit field width
    parameter R_FUNCT_LSB   = 0;  // R Type: Funct LSB Location
    
    parameter J_ADDR_WIDTH  = 26; // J Type: Address bit field Width
    parameter J_ADDR_LSB    = 0;  // J Type: Address LSB Location
    
    parameter I_IMM_WIDTH   = 16; // I Type: Immediate bit field Width
    parameter I_IMM_LSB     = 16; // I Type: Immediate LSB Location
    parameter I_RT_LSB      = 16; // I Type: Target Register LSB Location
    parameter I_RS_LSB      = 21; // I Type: Source Register LSB Location
    
    // Opcode
    typedef enum logic[OPCODE_WIDTH-1:0] { 
        RType     = 6'd0,
        BLT_BGEZ  = 6'd1,
        J         = 6'd2,
        JAL       = 6'd3,
        BEQ       = 6'd4,
        BNE       = 6'd5,
        BLEZ      = 6'd6,
        BGTZ      = 6'd7,
        ADDI      = 6'd8,
        ADDIU     = 6'd9,
        SLTI      = 6'd10,
        SLTIU     = 6'd11,
        ANDI      = 6'd12,
        ORI       = 6'd13,
        XORI      = 6'd14,
        LUI       = 6'd15,
        MFC0      = 6'd16,
        MUL       = 6'd28,
        LB        = 6'd32,
        LH        = 6'd33,
        LW        = 6'd35,
        LBU       = 6'd36,
        LHU       = 6'd37,
        SB        = 6'd40,
        SH        = 6'd41,
        Sw        = 6'd43
    } opcode_t; 
    // Funct
    typedef enum logic [R_FUNCT_WIDTH-1:0] { 
        SLL     = 6'd0,
        SRL     = 6'd2,
        SRA     = 6'd3,
        SLLV    = 6'd4,
        SRLV    = 6'd6,
        SRAV    = 6'd7,
        JR      = 6'd8,
        JALR    = 6'd9,
        SYSCALL = 6'd12,
        BREAK   = 6'd13,
        MFHI    = 6'd16,
        MTHI    = 6'd17,
        MFLO    = 6'd18,
        MTLO    = 6'd19,
        MULT    = 6'd24,
        MULTU   = 6'd25,
        DIV     = 6'd26,
        DIVU    = 6'd27,
        ADD     = 6'd32,
        ADDU    = 6'd33,
        SUB     = 6'd34,
        SUBU    = 6'd35,
        AND     = 6'd36,
        OR      = 6'd37,
        XOR     = 6'd38,
        NOR     = 6'd39,
        SLT     = 6'd42,
        SLTU    = 6'd43
    } funct_t; 
    typedef logic [RFADDR_WIDTH-1:0]  rfaddr_t;      // Register File Address
    typedef logic [I_IMM_WIDTH-1:0]   immediate_t;   // Immediate 
    typedef logic [J_ADDR_WIDTH-1:0]  jaddress_t;    // Jump Address
    typedef logic [R_SHMAT_WIDTH-1:0] shmat_t;       // Shmat length
    
    // Design Parameters
    parameter PC_WIDTH          = 32;
    parameter INSTR_WITDTH      = 32;
    parameter DATA_MEM_WIDTH    = 32;
    parameter ALU_CTRL_WIDTH    = 4; 
    parameter ALU_SRC_WIDTH     = 2;
    parameter REG_WR_SRC_WIDTH  = 3;
    parameter REG_WR_ADDR_WIDTH = 2;
    parameter HI_LO_SEL_WIDTH   = 2;
endpackage