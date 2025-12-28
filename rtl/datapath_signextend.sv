module sign_extended (
    input logic [15:0] in_data,
    output logic [31:0] out_data
);
    assign out_data = {{16{in_data[15]}}, in_data};
endmodule