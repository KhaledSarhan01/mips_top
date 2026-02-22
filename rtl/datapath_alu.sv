import mips_pkg::*;
module alu (
    // input operands 
    input logic [31:0] operand_a, // [rs]
    input logic [31:0] operand_b, // [rt] or signimm
    input logic [4:0]  shmat,
    // ALU control signal
    input logic [ALU_CTRL_WIDTH-1:0] alu_control,
    // output result
    output logic [31:0] alu_result,
    // Flag 
    output logic zero_flag,
    output logic overflow_flag,
    output logic neg_flag
);
    // ALU operation
    logic [31:0] sum_result,sub_result;
    logic sum_carry,sub_carry;
    assign {sum_carry,sum_result} = operand_a + operand_b;
    assign {sub_carry,sub_result} = operand_a - operand_b;
    always_comb begin 
        case (alu_control)
            4'b0000: alu_result = operand_a & operand_b;                        // AND
            4'b0001: alu_result = operand_a | operand_b;                        // OR 
            4'b0010: alu_result = sum_result;                                   // ADD
            4'b0011: alu_result = operand_a ^ operand_b;                        // XOR
            4'b0100: alu_result = ~(operand_a | operand_b);                     // NOR
            4'b0101: alu_result = (operand_a < operand_b);                      // SLTU
            4'b0110: alu_result = sub_result;                                   // SUB  
            4'b0111: alu_result = ($signed(operand_a) < $signed(operand_b));    // SLT
            4'b1000: alu_result = operand_b <<  shmat;                          // Shift Constant Left Logical
            4'b1001: alu_result = operand_b >>  shmat;                          // Shift Constant Right Logical 
            4'b1010: alu_result = $signed(operand_b) >>> shmat;                 // Shift Constant Right Arthmetic
            4'b1011: alu_result = operand_b <<  operand_a[4:0];                 // Shift Variable Left Logical
            4'b1100: alu_result = operand_b >>  operand_a[4:0];                 // Shift Variable Right Logical 
            4'b1101: alu_result = $signed(operand_b) >>> operand_a[4:0];        // Shift Variable Right Arthmetic
            default: alu_result = operand_a;
        endcase
    end
    // Flags
    assign zero_flag     = (alu_result == 32'b0) ? 1'b1 : 1'b0;
    assign neg_flag      = alu_result[31]; // MSB is one to determine negitive sign
    // assign overflow_flag = (alu_result[31] != operand_a[31]) & (operand_a[31] == operand_b[31]);
    always_comb begin
        overflow_flag = 'b0; 
        case (alu_control)
            4'b0010: overflow_flag = sum_carry; // ADD
            4'b0110: overflow_flag = sub_carry; // SUB
            default: overflow_flag = 'b0;
        endcase
    end
endmodule