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
        RType = 0,
        BLT   = 1,
        J     = 2,
        JAL   = 3,
        BEQ   = 4,
        BNQ   = 5,
        BLEZ  = 6,
        BGTZ  = 7,
        ADDI  = 8,
        ADDIU = 9,
        SLTI  = 10,
        SLTIU = 11,
        ANDI  = 12,
        ORI   = 13,
        XORI  = 14,
        LUI   = 15,
        MFC0  = 16,
        MUL   = 28,
        LB    = 32,
        LH    = 33,
        LW    = 35,
        LBU   = 36,
        LHU   = 37,
        SB    = 40,
        SH    = 41,
        Sw    = 43
    } opcode_t; 
    // Funct
    typedef enum logic [R_FUNCT_WIDTH-1:0] { 
        SLL     = 0,
        SRL     = 2,
        SRA     = 3,
        SLLV    = 4,
        SRLV    = 6,
        SRAV    = 7,
        JR      = 8,
        JALR    = 9,
        SYSCALL = 12,
        BREAK   = 13,
        MFHI    = 16,
        MTHI    = 17,
        MFLO    = 18,
        MTLO    = 19,
        MULT    = 24,
        MULTU   = 25,
        DIV     = 26,
        DIVU    = 27,
        ADD     = 32,
        ADDU    = 33,
        SUB     = 34,
        SUBU    = 35,
        AND     = 36,
        OR      = 37,
        XOR     = 38,
        NOR     = 39,
        SLT     = 42,
        SLTU    = 43
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
    parameter REG_WR_SRC_WIDTH  = 2;
    parameter HI_LO_SEL_WIDTH   = 2;
endpackage