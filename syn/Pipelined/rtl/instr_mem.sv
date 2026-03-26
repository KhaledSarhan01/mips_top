module instr_mem #(parameter DEPTH = 256,parameter WIDTH = 8)(
    input  logic clk,rst_n,
    input  logic [31:0] address,
    output logic [31:0] data_out
);
    // Memory declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1]/*ramstyle = "M10k"*/;

    // Memory initialization
        always_ff @( posedge clk) begin
            mem[0]   <= 8'hf0;
            mem[1]   <= 8'h0a;
            mem[2]   <= 8'h10;
            mem[3]   <= 8'h20;
            mem[4]   <= 8'hb0;
            mem[5]   <= 8'h04;
            mem[6]   <= 8'h11;
            mem[7]   <= 8'h20;
            mem[8]   <= 8'h20;
            mem[9]   <= 8'h90;
            mem[10]  <= 8'h11;
            mem[11]  <= 8'h02;
            mem[12]  <= 8'ha0;
            mem[13]  <= 8'h0f;
            mem[14]  <= 8'h08;
            mem[15]  <= 8'h20;
            mem[16]  <= 8'h01;
            mem[17]  <= 8'h00;
            mem[18]  <= 8'h48;
            mem[19]  <= 8'h12;
            mem[20]  <= 8'h16;
            mem[21]  <= 8'h00;
            mem[22]  <= 8'h00;
            mem[23]  <= 8'h08;
            mem[24]  <= 8'h22;
            mem[25]  <= 8'h98;
            mem[26]  <= 8'h11;
            mem[27]  <= 8'h02;
            mem[28]  <= 8'h40;
            mem[29]  <= 8'h06;
            mem[30]  <= 8'h09;
            mem[31]  <= 8'h20;
            mem[32]  <= 8'h01;
            mem[33]  <= 8'h00;
            mem[34]  <= 8'h69;
            mem[35]  <= 8'h12;
            mem[36]  <= 8'h16;
            mem[37]  <= 8'h00;
            mem[38]  <= 8'h00;
            mem[39]  <= 8'h08;
            mem[40]  <= 8'h24;
            mem[41]  <= 8'ha0;
            mem[42]  <= 8'h11;
            mem[43]  <= 8'h02;
            mem[44]  <= 8'hb0;
            mem[45]  <= 8'h00;
            mem[46]  <= 8'h0a;
            mem[47]  <= 8'h20;
            mem[48]  <= 8'h01;
            mem[49]  <= 8'h00;
            mem[50]  <= 8'h8a;
            mem[51]  <= 8'h12;
            mem[52]  <= 8'h16;
            mem[53]  <= 8'h00;
            mem[54]  <= 8'h00;
            mem[55]  <= 8'h08;
            mem[56]  <= 8'h25;
            mem[57]  <= 8'ha8;
            mem[58]  <= 8'h11;
            mem[59]  <= 8'h02;
            mem[60]  <= 8'hf0;
            mem[61]  <= 8'h0e;
            mem[62]  <= 8'h0b;
            mem[63]  <= 8'h20;
            mem[64]  <= 8'h01;
            mem[65]  <= 8'h00;
            mem[66]  <= 8'hab;
            mem[67]  <= 8'h12;
            mem[68]  <= 8'h16;
            mem[69]  <= 8'h00;
            mem[70]  <= 8'h00;
            mem[71]  <= 8'h08;
            mem[72]  <= 8'h64;
            mem[73]  <= 8'h00;
            mem[74]  <= 8'h0c;
            mem[75]  <= 8'h20;
            mem[76]  <= 8'h32;
            mem[77]  <= 8'h00;
            mem[78]  <= 8'h90;
            mem[79]  <= 8'had;
            mem[80]  <= 8'h32;
            mem[81]  <= 8'h00;
            mem[82]  <= 8'h8d;
            mem[83]  <= 8'h8d;
            mem[84]  <= 8'h02;
            mem[85]  <= 8'h00;
            mem[86]  <= 8'h0d;
            mem[87]  <= 8'h12;
            mem[88]  <= 8'had;
            mem[89]  <= 8'hde;
            mem[90]  <= 8'h10;
            mem[91]  <= 8'h20;
            mem[92]  <= 8'h19;
            mem[93]  <= 8'h00;
            mem[94]  <= 8'h00;
            mem[95]  <= 8'h08;
            mem[96]  <= 8'h8e;
            mem[97]  <= 8'hd0;
            mem[98]  <= 8'h10;
            mem[99]  <= 8'h20;
            mem[100] <= 8'h00;
            mem[101] <= 8'h00;
            mem[102] <= 8'h00;
            mem[103] <= 8'h00;
        end
    // Address width <fixing 
    logic [$clog2(DEPTH)-1:0] addr_reg;
    assign addr_reg = address[$clog2(DEPTH)-1:0];

    // Read operation
    assign data_out = {mem[addr_reg+3], mem[addr_reg+2], mem[addr_reg+1], mem[addr_reg]};
endmodule