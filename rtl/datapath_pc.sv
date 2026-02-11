module pc_reg(
    input logic clk,
    input logic rst_n,
    input logic [1:0] pcsrc,
    input logic [31:0] regfile,
    input logic [31:0] BTA,JTA,
    output logic [31:0] pc_plus4,
    output logic [31:0] pc_next
);
    
    logic [31:0] pc_next_comb;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_next <= 32'b0;
        end else begin
            pc_next <= pc_next_comb;
        end
    end
    always_comb begin
        case (pcsrc)
            2'b00: pc_next_comb = pc_plus4;     // Sequential execution
            2'b01: pc_next_comb = BTA;          // Branch target
            2'b10: pc_next_comb = JTA;          // Jump target
            2'b11: pc_next_comb = regfile;      // PC = [rs]  
            default: pc_next_comb = pc_plus4; 
        endcase
    end
    assign pc_plus4 = pc_next + 4;
endmodule