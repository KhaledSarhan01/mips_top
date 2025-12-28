module mux2 #(parameter DATA_WIDTH = 32) (
    input  logic [DATA_WIDTH-1:0] in0,in1,
    output logic [DATA_WIDTH-1:0] out,
    input  logic sel
);
    assign out = (sel)? in1:in0;
endmodule