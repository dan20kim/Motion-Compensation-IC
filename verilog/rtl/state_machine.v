module state_machine
			(
			clk, 
			clk_s2p, 
			clk_write, 
			clk_transfer, 
			clk_out, 
			clk_calc,
			addr_write, 
			addr_read, 
			web,
			rst_n);

	localparam STATE_Initial = 2'b0,
		   STATE_WRITE = 2'b01,
		   STATE_READ = 2'b10,
		   STATE_DUMMY = 2'b11;
	


	input wire clk;
	output reg clk_s2p; 
	output reg clk_write; 
	output reg clk_transfer; 
	output reg clk_out;
	output reg clk_calc;
	output reg [7:0] addr_write;
	output reg [7:0] addr_read;
	output reg web;
	input wire rst_n;

	reg en_s2p;
	reg en_write;
	reg en_transfer;
	reg en_out;
	reg en_calc;

	reg [1:0] state;

	reg [7:0] count0;
	reg [7:0] count1;

	
	always @(clk) begin
		clk_s2p <= en_s2p & clk;
		clk_write <= en_write & clk;
		clk_transfer <= en_transfer & clk;
		clk_out <= en_out & clk;
		clk_calc <= en_calc & clk;
	end
	/*
	initial begin
		count0 = 8'b0;
		count1 = 8'b0;
		state = STATE_Initial;
		addr_write = 8'd24;
		addr_read = 8'd6;
		web = 1'b0;
		en_s2p = 1'b1;
		en_write = 1'b0;
		en_transfer = 1'b0;
		en_out = 1'b0;
		en_calc = 1'b0;
	end
	*/

	always @(posedge clk) begin
		if (!rst_n) begin
			count0 <= 8'b0;
			count1 <= 8'b0;
			state <= STATE_Initial;
			addr_write <= 8'd24;
			addr_read <= 8'd6;
			web <= 1'b0;
			en_s2p <= 1'b1;
			en_write <= 1'b0;
			en_transfer <= 1'b0;
			en_out <= 1'b0;
			en_calc <= 1'b0;
		end
		else begin
			case(state)
				STATE_Initial: begin
					count0 <= count0+8'b1;	
					en_transfer <= 1'b0;
					en_write <= 1'b0;
					if (count1 == 8'd24 && count0 == 8'd3) begin
						en_write <= 1'b1;
						state <= STATE_WRITE;
						//en_transfer <= 1'b1;
						count1 <= 8'b0;
						count0 <= 8'b0;
						//addr_write <= 8'b0;
						//addr_write <= addr_write + 8'b1;	
					end
					else if (count0 == 8'd3) begin
						en_write <= 1'b1;
						count0 <= 0;
						count1 <= count1+8'b1;
					end
					else if (count0 == 8'd2) begin
						if(addr_write == 8'd24) begin
							addr_write <= 8'b0;
						end
						else begin 
							addr_write <= addr_write + 8'b1;	
						end
					end
				end
				STATE_WRITE: begin
					en_calc <= 1'b0;
					count0 <= count0+8'b1;
					en_transfer <= 1'b0;
					en_write <= 1'b0;
					if (count1 == 8'd25) begin
						state <= STATE_READ;
						web <= 1'b0;
						count1 <= 8'b0;
						count0 <= 8'b0;
						en_s2p <= 1'b0;
						en_out <= 1'b1;
						addr_read <= 8'd5;
					end
					else if (count0 == 8'd3) begin
						en_write <= 1'b1;
						count0 <= 0;
						count1 <= count1+8'b1;
						en_transfer <= 1'b0;
					end
					else if (count0 == 8'd2) begin
						en_transfer <= 1'b1;
						if(addr_write == 8'd24) begin
							addr_write <= 8'b0;
						end
						else begin 
							addr_write <= addr_write + 8'b1;	
						end
					end
				end
				STATE_READ: begin
					if (addr_read % 8'd5 == 8'd3) begin
						addr_read <= addr_read + 8'b00000011;
					end
					else begin
						addr_read <= addr_read + 8'b1;
					end

					en_calc <= 1'b1;
					en_write <=1'b0;
					if (addr_read == 8'd17) begin
						en_s2p <= 1'b1;
						en_write <= 1'b0;
						en_out <= 1'b0;
						count0 <= 0;
						count1 <= 0;
						state <= STATE_WRITE;	
						web <= 1'b1;
					end
				end
				STATE_DUMMY: begin
					state <= STATE_Initial;
				end
			endcase
		end
	end
	


endmodule
