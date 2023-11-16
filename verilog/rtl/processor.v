module processor
			(
			i_current_block,
			i_search_window,
			o_sae_result); 


localparam BLOCK_WIDTH = 2;
localparam BLOCK_SIZE = 4;
localparam WORD_SIZE = 8;

input wire [BLOCK_SIZE*WORD_SIZE-1:0] i_current_block;
input wire [BLOCK_SIZE*WORD_SIZE-1:0] i_search_window;
output wire [9:0] o_sae_result;




// local variables 
reg [1:0] idx,jdx; 
wire [7:0] current_block [0:BLOCK_WIDTH-1] [0:BLOCK_WIDTH-1]; 
wire [7:0] search_window [0:BLOCK_WIDTH-1] [0:BLOCK_WIDTH-1]; 
wire[7:0] sae_result [0:BLOCK_WIDTH-1] [0:BLOCK_WIDTH-1]; 
reg [9:0] sae_accumulator [3:0]; 
// genvar statement 
genvar i,j; 
generate
	for(i = 0 ; i < BLOCK_WIDTH ; i = i + 1) begin 
		for(j = 0 ; j < BLOCK_WIDTH ; j = j + 1) begin 
			assign current_block[i][j] = i_current_block[(WORD_SIZE*(i+1)+BLOCK_WIDTH*WORD_SIZE*j-1) : (8*i+BLOCK_WIDTH*WORD_SIZE*j)]; 
			assign search_window[i][j] = i_search_window[(WORD_SIZE*(i+1)+BLOCK_WIDTH*WORD_SIZE*j-1) : (8*i+BLOCK_WIDTH*WORD_SIZE*j)]; 
			assign sae_result[i][j] = (current_block[i][j] > search_window[i][j]) ? (current_block[i][j] - search_window[i][j]) : (search_window[i][j] - current_block[i][j]); 
		end 
	end
endgenerate


always @(*) begin
        for(idx = 0; idx < 2; idx = idx + 1) begin
            for(jdx = 0; jdx < 2; jdx = jdx + 1) begin
				if (idx == 0 && jdx == 0) begin
                	sae_accumulator[0] = {{(2){1'b0}}, sae_result[idx[0]][jdx[0]]};
				end
				else begin
					sae_accumulator[idx*2 + jdx] = sae_accumulator[idx*2 +jdx -1] + {{(2){1'b0}}, sae_result[idx[0]][jdx[0]]}; 
				end
			end
        end
end
  
assign o_sae_result = sae_accumulator[3];

endmodule
