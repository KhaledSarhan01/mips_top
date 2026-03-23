module lo_hi_reg (
    // Clock and Active Low Reset
        input wire clk,rst_n,
    // Inputs 
        input [31:0] reg_file,
        input [31:0] mult_lo,mult_hi,
        input [31:0] div_lo,div_hi,
    // Controls
        input hi_write,lo_write,
        input [1:0] hi_select,lo_select,
    // Outputs
        output logic [31:0] lo_reg,hi_reg        
);
    // Register
    logic [31:0] lo_comb,hi_comb;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lo_reg <= 'b0;
            hi_reg <= 'b0; 
        end else begin
            if (hi_write) begin
                hi_reg <= hi_comb;
            end
            if (lo_write) begin
                lo_reg <= lo_comb;
            end
        end
    end
    // Combinational
    always_comb begin 
        case (hi_select)
            2'b00:   hi_comb = hi_reg;
            2'b01:   hi_comb = reg_file;
            2'b10:   hi_comb = div_hi;
            2'b11:   hi_comb = mult_hi; 
            default: hi_comb = hi_reg;
        endcase
    end
    always_comb begin 
        case (lo_select)
            2'b00:   lo_comb = lo_reg;
            2'b01:   lo_comb = reg_file;
            2'b10:   lo_comb = div_lo;
            2'b11:   lo_comb = mult_lo; 
            default: lo_comb = lo_reg;
        endcase
    end
endmodule