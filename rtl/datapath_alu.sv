module alu (
    // input operands 
    input logic [31:0] operand_a,
    input logic [31:0] operand_b,
    // ALU control signal
    input logic [2:0] alu_control,
    // output result
    output logic [31:0] alu_result,
    // Flag 
    output logic zero_flag
);
    // ALU operation
    always_comb begin 
        case (alu_control)
            3'b000: alu_result = operand_a & operand_b;     // AND
            3'b001: alu_result = operand_a | operand_b;     // OR 
            3'b010: alu_result = operand_a + operand_b;     // ADD
            3'b011: alu_result = operand_a;                 // Not used
            3'b100: alu_result = operand_a & ~(operand_b);  // AND NOT
            3'b101: alu_result = operand_a | ~(operand_b);  // OR NOT
            3'b110: alu_result = operand_a - operand_b;     // SUB  
            3'b111: alu_result = (operand_a < operand_b);   // SLT
            default: alu_result = operand_a;
        endcase
    end
    // Flags
    assign zero_flag = (alu_result == 32'b0) ? 1'b1 : 1'b0;
endmodule