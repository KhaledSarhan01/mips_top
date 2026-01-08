module mux4 #(parameter DATA_WIDTH = 32) (
    input  logic [DATA_WIDTH-1:0] in0,in1,in2,in3,
    output logic [DATA_WIDTH-1:0] out,
    input  logic [1:0] sel
);
    always_comb begin 
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
            default: out = 'b0;
        endcase
    end
endmodule