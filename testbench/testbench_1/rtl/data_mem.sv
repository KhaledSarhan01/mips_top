module data_mem #(parameter DEPTH = 256,parameter WIDTH = 8)(
    input  logic clk,rst_n,
    input  logic [31:0] address,
    // input for write operation
    input  logic write_en,
    input  logic [31:0] data_in,
    // output for read operation
    output logic [31:0] data_out
);
    // Memory declaration
    reg [WIDTH-1:0] mem [DEPTH-1:0];

    // Address width fixing 
    logic [$clog2(DEPTH)-1:0] addr_reg;
    assign addr_reg = address[$clog2(DEPTH)-1:0];

    // Write operation
        always_ff @( posedge clk or negedge rst_n ) begin 
            if (!rst_n) begin
                for (int i = 0; i <= DEPTH-1; i++) begin
                    mem[i] <= $random();
                end
            end else begin
                if (write_en) begin
                    {mem[addr_reg+3], mem[addr_reg+2], mem[addr_reg+1], mem[addr_reg]} <= data_in;
                end
            end
        end
    // Read operation
    assign data_out = {mem[addr_reg+3], mem[addr_reg+2], mem[addr_reg+1], mem[addr_reg]};
endmodule