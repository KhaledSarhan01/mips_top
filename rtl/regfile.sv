module reg_file (
    input logic clk_n, rst_n,
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
    input logic write_enable,
    // return address port
    input logic [31:0] pc_plus4,
    input logic ra_handle
);
    logic [31:0] registers [31:0];

    // Read logic (Asynchronous)
    assign read_data1 = registers[read_addr1];
    assign read_data2 = registers[read_addr2];
    assign s0 = registers[16];

    // Consolidated Write Logic
    always_ff @(negedge clk_n or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers to zero
            for (int i = 0; i < 32; i++) begin
                registers[i] <= 32'b0;
            end
        end else begin
            // 1. Handle standard writes for registers 1-30
            if (write_enable && (write_addr != 5'd0) && (write_addr != 5'd31)) begin
                registers[write_addr] <= write_data;
            end

            // 2. Specialized logic for Register 31 ($ra)
            // Priority: ra_handle (JAL/BGEZAL) usually takes precedence over standard writes
            if (ra_handle) begin
                registers[31] <= pc_plus4;
            end else if (write_enable && (write_addr == 5'd31)) begin
                registers[31] <= write_data;
            end
            
            // Register 0 is usually hardwired to 0. 
            // In synthesis, if you never drive it, it stays 0 from reset.
            registers[0] <= 32'b0; 
        end
    end
endmodule