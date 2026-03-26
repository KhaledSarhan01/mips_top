module bin2hex (
    input wire [3:0] i_bin,
    output reg [6:0] o_hex 
);
    always @(*) begin
        case (i_bin)
            4'h0: o_hex = 7'b1000000;
            4'h1: o_hex = 7'b1111001;
            4'h2: o_hex = 7'b0100100;
            4'h3: o_hex = 7'b0110000; 
            4'h4: o_hex = 7'b0011001;
            4'h5: o_hex = 7'b0010010;
            4'h6: o_hex = 7'b0000010;
            4'h7: o_hex = 7'b1111000;
            4'h8: o_hex = 7'b0000000;
            4'h9: o_hex = 7'b0010000;
            4'ha: o_hex = 7'b0001000;
            4'hb: o_hex = 7'b0000011;
            4'hc: o_hex = 7'b1000110;
            4'hd: o_hex = 7'b0100001;
            4'he: o_hex = 7'b0000110;
            4'hf: o_hex = 7'b0001110;
            default: o_hex = 7'b1111111;
        endcase
    end
endmodule