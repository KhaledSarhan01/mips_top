module reg_file (
    input logic clk,rst_n,
    output logic [31:0] s0,
    // Read port 1
    input logic [4:0] read_addr1,
    output logic [31:0] read_data1,
    // Read port 2
    input logic [4:0] read_addr2,    
    output logic [31:0] read_data2,
    // Write port
    input logic [4:0] write_addr,
    input logic [31:0] write_data,
    input logic write_enable
);
    reg [31:0] registers [31:0];
    // Read logic
    assign read_data1 = registers[read_addr1];
    assign read_data2 = registers[read_addr2];
    // Write logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers to zero
            for (int i = 0; i < 32; i++) begin
                registers[i] <= 32'b0;
            end
        end else if (write_enable && write_addr != 5'b0) begin
            // Write data to the specified register (except register 0)
            registers[write_addr] <= write_data;
        end
    end
    assign s0 = registers[16];
endmodule