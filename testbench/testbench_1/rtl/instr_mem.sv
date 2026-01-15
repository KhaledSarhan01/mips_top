module instr_mem #(parameter DEPTH = 256,parameter WIDTH = 8)(
    input  logic clk,rst_n,
    input  logic [31:0] address,
    output logic [31:0] data_out
);
    // Memory declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Memory initialization
        initial begin
            $readmemh("../testbench/Test1.mem", mem);
        end
    // Address width fixing 
    logic [$clog2(DEPTH)-1:0] addr_reg;
    assign addr_reg = address[$clog2(DEPTH)-1:0];

    // Read operation
    assign data_out = {mem[addr_reg+3], mem[addr_reg+2], mem[addr_reg+1], mem[addr_reg]};
endmodule