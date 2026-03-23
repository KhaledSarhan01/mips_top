module sign_extended (
    input logic [2:0] se_select,
    input logic [15:0] in_data,
    output logic [31:0] out_data
);
    always_comb begin 
        case (se_select)
            3'b000: out_data = {{16{in_data[15]}}, in_data};           // 16 bit Sign Extention
            3'b001: out_data = {{16{1'b0}}, in_data};                  // 16 bit Zero Extention
            3'b010: out_data = {in_data,{16{1'b0}}};                   // Load Upper Immediate
            3'b011: out_data = {{24{in_data[15]}}, in_data[7:0]};      // 8 bit Sign Extention
            3'b100: out_data = {{24{1'b0}}, in_data[7:0]};             // 8 bit Zero Extention
            default: out_data = {{16{in_data[15]}}, in_data};
        endcase
    end
endmodule