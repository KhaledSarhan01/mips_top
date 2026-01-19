module sign_extended (
    input logic [1:0] se_select,
    input logic [15:0] in_data,
    output logic [31:0] out_data
);
    always_comb begin 
        case (se_select)
            2'b00: out_data = {{16{in_data[15]}}, in_data};      // Arithmetic Sign Extention
            2'b01: out_data = {{16{1'b0}}, in_data};             // Zero Sign Extention
            2'b10: out_data = {in_data,{16{1'b0}}};              // Load Upper Immediate
            2'b11: out_data = {in_data,{16{1'b0}}};              // Load Upper Immediate
            default: out_data = {{16{in_data[15]}}, in_data};
        endcase
    end
endmodule