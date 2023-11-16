module processor_block
			(
			clk, 
			block_A, 
			block_B_1,
			block_B_2, 
			block_B_3, 
			block_B_4, 
			block_B_5, 
			block_B_6, 
			block_B_7, 
			block_B_8, 
			block_B_9, 
			motion_vec_x,
			motion_vec_y,
			min_sae);

localparam BLOCK_WIDTH = 2;
localparam BLOCK_SIZE = 4;
localparam WORD_SIZE = 8;


input wire clk;
input [BLOCK_SIZE*WORD_SIZE-1:0]block_A;
input wire [BLOCK_SIZE*WORD_SIZE-1:0] block_B_1;
input wire [BLOCK_SIZE*WORD_SIZE-1:0] block_B_2; 
input wire [BLOCK_SIZE*WORD_SIZE-1:0] block_B_3; 
input wire [BLOCK_SIZE*WORD_SIZE-1:0] block_B_4; 
input wire [BLOCK_SIZE*WORD_SIZE-1:0] block_B_5; 
input wire [BLOCK_SIZE*WORD_SIZE-1:0] block_B_6;
input wire [BLOCK_SIZE*WORD_SIZE-1:0] block_B_7; 
input wire [BLOCK_SIZE*WORD_SIZE-1:0] block_B_8; 
input wire [BLOCK_SIZE*WORD_SIZE-1:0] block_B_9; 

reg [BLOCK_SIZE*WORD_SIZE-1:0] block_A_reg;
reg [BLOCK_SIZE*WORD_SIZE-1:0] block_B_1_reg;
reg [BLOCK_SIZE*WORD_SIZE-1:0] block_B_2_reg; 
reg [BLOCK_SIZE*WORD_SIZE-1:0] block_B_3_reg; 
reg [BLOCK_SIZE*WORD_SIZE-1:0] block_B_4_reg; 
reg [BLOCK_SIZE*WORD_SIZE-1:0] block_B_5_reg; 
reg [BLOCK_SIZE*WORD_SIZE-1:0] block_B_6_reg;
reg [BLOCK_SIZE*WORD_SIZE-1:0] block_B_7_reg; 
reg [BLOCK_SIZE*WORD_SIZE-1:0] block_B_8_reg; 
reg [BLOCK_SIZE*WORD_SIZE-1:0] block_B_9_reg; 

wire [BLOCK_SIZE*WORD_SIZE-1:0] block_A_wire;

output reg [2:0] motion_vec_x;
output reg [2:0] motion_vec_y;
output reg [9:0] min_sae;

always @(posedge clk) begin
	block_B_1_reg <= block_B_1;
	block_B_2_reg <= block_B_2;
	block_B_3_reg <= block_B_3;
	block_B_4_reg <= block_B_4;
	block_B_5_reg <= block_B_5;
	block_B_6_reg <= block_B_6;
	block_B_7_reg <= block_B_7;
	block_B_8_reg <= block_B_8;
	block_B_9_reg <= block_B_9;
	block_A_reg <= block_A;
end



genvar r, c, i, j;
wire [9:0] sae[2*BLOCK_WIDTH:0][2*BLOCK_WIDTH:0];
wire [WORD_SIZE-1:0] block_B [(BLOCK_WIDTH*3)-1:0][(BLOCK_WIDTH*3)-1:0];
wire [BLOCK_SIZE*WORD_SIZE-1:0] block_B_wire [2*BLOCK_WIDTH:0][2*BLOCK_WIDTH:0];

generate
for (r = 0; r < BLOCK_WIDTH; r = r + 1) begin
	for (c = 0; c < BLOCK_WIDTH; c = c + 1) begin
		assign block_B[r][c][WORD_SIZE-1:0] = block_B_1_reg[WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r+WORD_SIZE-1:WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r];
	end
end

for (r = 0; r < BLOCK_WIDTH; r = r + 1) begin
	for (c = 0; c < BLOCK_WIDTH; c = c + 1) begin
		assign block_B[r][c+BLOCK_WIDTH][WORD_SIZE-1:0] = block_B_2_reg[WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r+WORD_SIZE-1:WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r];
	end
end

for (r = 0; r < BLOCK_WIDTH; r = r + 1) begin
	for (c = 0; c < BLOCK_WIDTH; c = c + 1) begin
		assign block_B[r][c+2*BLOCK_WIDTH][WORD_SIZE-1:0] = block_B_3_reg[WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r+WORD_SIZE-1:WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r];
	end
end

for (r = 0; r < BLOCK_WIDTH; r = r + 1) begin
	for (c = 0; c < BLOCK_WIDTH; c = c + 1) begin
		assign block_B[r+BLOCK_WIDTH][c][WORD_SIZE-1:0] = block_B_4_reg[WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r+WORD_SIZE-1:WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r];
	end
end

for (r = 0; r < BLOCK_WIDTH; r = r + 1) begin
	for (c = 0; c < BLOCK_WIDTH; c = c + 1) begin
		assign block_B[r+BLOCK_WIDTH][c+BLOCK_WIDTH][WORD_SIZE-1:0] = block_B_5_reg[WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r+WORD_SIZE-1:WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r];
	end
end

for (r = 0; r < BLOCK_WIDTH; r = r + 1) begin
	for (c = 0; c < BLOCK_WIDTH; c = c + 1) begin
		assign block_B[r+BLOCK_WIDTH][c+2*BLOCK_WIDTH][WORD_SIZE-1:0] = block_B_6_reg[WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r+WORD_SIZE-1:WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r];
	end
end

for (r = 0; r < BLOCK_WIDTH; r = r + 1) begin
	for (c = 0; c < BLOCK_WIDTH; c = c + 1) begin
		assign block_B[r+2*BLOCK_WIDTH][c][WORD_SIZE-1:0] = block_B_7_reg[WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r+WORD_SIZE-1:WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r];
	end
end

for (r = 0; r < BLOCK_WIDTH; r = r + 1) begin
	for (c = 0; c < BLOCK_WIDTH; c = c + 1) begin
		assign block_B[r+2*BLOCK_WIDTH][c+BLOCK_WIDTH][WORD_SIZE-1:0] = block_B_8_reg[WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r+WORD_SIZE-1:WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r];
	end
end

for (r = 0; r < BLOCK_WIDTH; r = r + 1) begin
	for (c = 0; c < BLOCK_WIDTH; c = c + 1) begin
		assign block_B[r+2*BLOCK_WIDTH][c+2*BLOCK_WIDTH][WORD_SIZE-1:0] = block_B_9_reg[WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r+WORD_SIZE-1:WORD_SIZE*c+BLOCK_WIDTH*WORD_SIZE*r];
	end
end
endgenerate

assign block_A_wire = block_A_reg;

generate
	for (i = 0; i < 2*BLOCK_WIDTH+1; i = i + 1) begin
		for  (j = 0; j < 2*BLOCK_WIDTH+1; j = j + 1) begin
			for (r = i; r < i + BLOCK_WIDTH; r = r + 1) begin
				for (c = j; c < j + BLOCK_WIDTH; c = c + 1) begin
					assign block_B_wire[i][j][WORD_SIZE*(c-j)+BLOCK_WIDTH*WORD_SIZE*(r-i)+WORD_SIZE-1:WORD_SIZE*(c-j)+BLOCK_WIDTH*WORD_SIZE*(r-i)] = block_B[r][c];
				end
			end
			processor 
					p(
					.i_current_block(block_A_wire), 
					.i_search_window(block_B_wire[i][j]), 
					.o_sae_result(sae[i][j])); 
		end
	end
endgenerate


//reg [7:0] x, y;

reg signed [2:0] index_y [24:0];
reg signed [2:0] index_x [24:0];
reg unsigned [9:0] min_sae_reg [24:0];

reg [2:0] y;
reg [2:0] x;
always @(*) begin
	for (x = 0; x < 5; x = x + 1) begin 
		for (y = 0; y < 5; y = y + 1) begin
			if (y == 0 && x == 0) begin
				index_x[0] = 3'b110;
				index_y[0] = 3'b110;
				min_sae_reg[0] = 10'b1111111111;
			end
			else begin
				if(sae[y][x] < min_sae_reg[5*x + y -1]) begin
					min_sae_reg[5*x + y] = sae[y][x];
					index_x[5*x + y] = x-3'b010;
					index_y[5*x + y] = y-3'b010;
				end
				else begin
					min_sae_reg[5*x + y] = min_sae_reg[5*x + y -1];
					index_x[5*x + y] = index_x[5*x + y - 1];
					index_y[5*x + y] = index_y[5*x + y - 1];
				end
			end
		end
	end
end

always @(*) begin 
	min_sae = min_sae_reg[24];
	motion_vec_x = index_x[24];
	motion_vec_y = index_y[24];
end
/*
generate
	for (row=0; row<33; row=row+1) begin
		processor p(clk, block_A_reg, block_B_wire[row], sae[row]);
	end
endgenerate



reg [7:0] col_count =0;
reg [7:0] r, c;
reg [15:0] min='b1111111111111111;
reg trigger = 1'b0;



always @(negedge trigger) begin
	min = 'b1111111111111111;
	for (r=0;r<33;r=r+1) begin
		for (c=0;c<33;c=c+1) begin
			if (saeReg[15:0] < BLOCK_WIDTHmin) begin
				min = saeReg[15:0];
				motion_vec[0] = r;
				motion_vec[1] = c;
				$display("Value of min: %h", min);

			saeReg = {'b1, saeReg[17423:BLOCK_SIZE]};
		end
	end
	$display("Value of motionvector[0]: %d", motion_vec[0]);
	$display("Value of motionvector[1]: %d", motion_vec[1]);

end

always @(posedge clk) begin
	trigger = 1'b0;
	col_count <= col_count+1;
		for (r=0; r<33;r=r+1) begin
			$display("SAE: %d", sae[r]);
		end
		saeReg <= {saeReg[WORD_SIZE95:0], sae};
		block_B_reg <= {4WORD_SIZE'b0, block_B_reg[1WORD_SIZE4BLOCK_SIZE*WORD_SIZE-1:4WORD_SIZE]};
		trigger = 1'b0;
		$display("Value of count: %d", col_count);	
		$display("Value of block_B_reg[0]: %h", block_B_reg[0]);
		$display("Value of block_B_reg[1]: %h", block_B_reg[1]);
		$display("Value of block_B_reg[2]: %h", block_B_reg[2]);
		$display("Value of block_A_reg: %h", block_A_reg);
		$display("Value of block_B_reg: %h", block_B_reg);
		$display("------------------");	
end

always @(negedge clk) begin
	if (col_count == 33) begin
		trigger = 1'b1;
		col_count <= 0;
	end
end

always @(posedge clk1) begin
	count <= count + 1; 
	block_B_reg <= {block_B_reg[3WORD_SIZE3:0], block_B};
	block_A_reg <= block_A;
	if (count == S1_LENGTH) begin
		count <= 0;
	end
end

always @(negedge clk1) begin
end
*/
endmodule
