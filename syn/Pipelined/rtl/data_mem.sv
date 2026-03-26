module data_mem #(parameter MEM_SIZE = 512,DATA_WIDTH = 16 ) // Total Size = 8192 bit or 8kb 
(
	input  wire clk,
    // output for read operation
	input  wire [$clog2(MEM_SIZE)-1:0] read_addr,
	output reg  [DATA_WIDTH-1:0] data_out,
    // input for write operation
	input  wire [$clog2(MEM_SIZE)-1:0] write_addr,
	input  wire [DATA_WIDTH-1:0] data_in,
	input  wire write_enable  
	);
	
	(*ramstyle = "M10K"*) reg [DATA_WIDTH-1:0] M10k_mem [MEM_SIZE-1:0];
	//reg [DATA_WIDTH-1:0] M10k_mem [MEM_SIZE-1:0] /* synthesis ramstyle = "no_rw_check, M10k" */;
	//(*ramstyle = "MLAB"*) reg [DATA_WIDTH-1:0] M10k_mem [MEM_SIZE-1:0];
	// reg [DATA_WIDTH-1:0] M10k_mem [MEM_SIZE-1:0];
	
	always@(posedge clk)begin
			//Write Logic
			if(write_enable)begin 
				M10k_mem[write_addr] <= data_in;
			end
			// Read Logic 
			data_out <= M10k_mem[read_addr];
	end
endmodule 