module s2p( 
			clk, 
			s_data, 
			p_data,
			rst_n);


localparam BLOCK_SIZE = 4;
localparam WORD_SIZE = 8;

input wire rst_n;
input wire clk;
input wire [WORD_SIZE-1:0] s_data;
output reg [BLOCK_SIZE*WORD_SIZE-1:0] p_data;

initial begin
	p_data = {(BLOCK_SIZE*WORD_SIZE){1'b0}};
end

always @(posedge clk) begin
	if (!rst_n) begin
		p_data <= {(BLOCK_SIZE*WORD_SIZE){1'b0}};
	end
	else begin
		p_data <= {s_data, p_data[BLOCK_SIZE*WORD_SIZE-1:WORD_SIZE]};
	end
end

endmodule
