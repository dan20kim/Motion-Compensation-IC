module top_level


(`ifdef USE_POWER_PINS
    vccd1,
    vssd1,
`endif
		    s_data, 
			clk, 
			motion_vec_x, 
			motion_vec_y,
			min_sae,
			rst_n);
	`ifdef USE_POWER_PINS
    	inout vccd1;
    	inout vssd1;
	`endif

	localparam BLOCK_SIZE = 4; 
	localparam WORD_SIZE = 8;
	
	input wire rst_n;
	input wire [7:0] s_data;
	input wire clk;
	output wire [2:0] motion_vec_x;
	output wire [2:0] motion_vec_y;
	output wire [9:0] min_sae;


	wire [BLOCK_SIZE*WORD_SIZE-1:0] p_data;
	wire clk_s2p;
	wire clk_write;
	wire clk_transfer;
	wire clk_out;
	wire clk_calc;
	wire [7:0] addr_write, addr_read;
	wire web;
	//wire [BLOCK_SIZE*WORD_SIZE-1:0] dout0A_1, dout0A_2, dout0B_1, dout0B_2, dout0B_3, dout0B_4, dout0B_5, dout0B_6, dout0B_7, dout0B_8, dout0B_9;
	(* keep="soft" *)
	wire [BLOCK_SIZE*WORD_SIZE-1:0] _unused_doutA1, _unused_doutA2;
	(* keep="soft" *)
	wire [BLOCK_SIZE*WORD_SIZE-1:0] _unused_doutB1, _unused_doutB2, _unused_doutB3, _unused_doutB4, _unused_doutB5, _unused_doutB6, _unused_doutB7, _unused_doutB8, _unused_doutB9;
	wire [BLOCK_SIZE*WORD_SIZE-1:0] t_data, block_A;
	wire [BLOCK_SIZE*WORD_SIZE-1:0]  block_B_1, block_B_2, block_B_3, block_B_4, block_B_5, block_B_6, block_B_7, block_B_8, block_B_9;
	reg csb0 = 0;
	//reg csb1 = 1;
	reg [3:0] wmask0 = 4'b1111;
	wire [7:0] addr_read_1, addr_read_2, addr_read_3, addr_read_4, addr_read_5, addr_read_6, addr_read_7, addr_read_8, addr_read_9;

	state_machine 
			s( 
			.clk(clk), 
			.clk_s2p(clk_s2p), 
			.clk_write(clk_write), 
			.clk_transfer(clk_transfer), 
			.clk_out(clk_out),  
			.clk_calc(clk_calc),
			.addr_write(addr_write), 
			.addr_read(addr_read), 
			.web(web),
			.rst_n(rst_n));
	
	s2p
			convert(
			.clk(clk_s2p), 
			.s_data(s_data), 
			.p_data(p_data),
			.rst_n(rst_n));
	
	sky130_sram_1kbyte_1rw1r_32x256_8		sram_A_1(
			.clk0(clk_write), 
			.csb0(csb0), 
			.web0(web), 
			.wmask0(wmask0), 
			.addr0(addr_write), 
			.din0(p_data), 
			.dout0(_unused_doutA1), 
			.clk1(clk_transfer), 
			.csb1(csb0), 
			.addr1(addr_write), 
			.dout1(t_data)); 

	sky130_sram_1kbyte_1rw1r_32x256_8		sram_A_2(
			.clk0(clk_write), 
			.csb0(csb0), 
			.web0(web), 
			.wmask0(wmask0), 
			.addr0(addr_write), 
			.din0(p_data), 
			.dout0(_unused_doutA2), 
			.clk1(clk_out), 
			.csb1(csb0), 
			.addr1(addr_read_5), 
			.dout1(block_A)); 
	
	assign addr_read_1 = addr_read-5-8'b1;	
	assign addr_read_2 = addr_read-5;	
	assign addr_read_3 = addr_read-5+8'b1;	
	assign addr_read_4 = addr_read-8'b1;	
	assign addr_read_5 = addr_read;	
	assign addr_read_6 = addr_read+8'b1;	
	assign addr_read_7 = addr_read+5-8'b1;	
	assign addr_read_8 = addr_read+5;	
	assign addr_read_9 = addr_read+5+8'b1;	
	
	sky130_sram_1kbyte_1rw1r_32x256_8		sram_B_1(
			.clk0(clk_write), 
			.csb0(csb0), 
			.web0(web), 
			.wmask0(wmask0), 
			.addr0(addr_write), 
			.din0(t_data), 
			.dout0(_unused_doutB1), 
			.clk1(clk_out), 
			.csb1(csb0), 
			.addr1(addr_read_1), 
			.dout1(block_B_1)); 
		
	sky130_sram_1kbyte_1rw1r_32x256_8		sram_B_2(
			.clk0(clk_write), 
			.csb0(csb0), 
			.web0(web), 
			.wmask0(wmask0), 
			.addr0(addr_write), 
			.din0(t_data), 
			.dout0(_unused_doutB2), 
			.clk1(clk_out), 
			.csb1(csb0), 
			.addr1(addr_read_2), 
			.dout1(block_B_2)); 

	sky130_sram_1kbyte_1rw1r_32x256_8		sram_B_3(
			.clk0(clk_write), 
			.csb0(csb0), 
			.web0(web), 
			.wmask0(wmask0), 
			.addr0(addr_write), 
			.din0(t_data), 
			.dout0(_unused_doutB3), 
			.clk1(clk_out), 
			.csb1(csb0), 
			.addr1(addr_read_3), 
			.dout1(block_B_3)); 

	sky130_sram_1kbyte_1rw1r_32x256_8		sram_B_4(
			.clk0(clk_write), 
			.csb0(csb0), 
			.web0(web), 
			.wmask0(wmask0), 
			.addr0(addr_write), 
			.din0(t_data), 
			.dout0(_unused_doutB4), 
			.clk1(clk_out), 
			.csb1(csb0), 
			.addr1(addr_read_4), 
			.dout1(block_B_4)); 

	sky130_sram_1kbyte_1rw1r_32x256_8		sram_B_5(
			.clk0(clk_write), 
			.csb0(csb0), 
			.web0(web), 
			.wmask0(wmask0), 
			.addr0(addr_write), 
			.din0(t_data), 
			.dout0(_unused_doutB5), 
			.clk1(clk_out), 
			.csb1(csb0), 
			.addr1(addr_read_5), 
			.dout1(block_B_5)); 
	
	sky130_sram_1kbyte_1rw1r_32x256_8		sram_B_6(
			.clk0(clk_write), 
			.csb0(csb0), 
			.web0(web), 
			.wmask0(wmask0), 
			.addr0(addr_write), 
			.din0(t_data), 
			.dout0(_unused_doutB6), 
			.clk1(clk_out), 
			.csb1(csb0), 
			.addr1(addr_read_6), 
			.dout1(block_B_6)); 
	
	sky130_sram_1kbyte_1rw1r_32x256_8		sram_B_7(
			.clk0(clk_write), 
			.csb0(csb0), 
			.web0(web), 
			.wmask0(wmask0), 
			.addr0(addr_write), 
			.din0(t_data), 
			.dout0(_unused_doutB7), 
			.clk1(clk_out), 
			.csb1(csb0), 
			.addr1(addr_read_7), 
			.dout1(block_B_7)); 

	sky130_sram_1kbyte_1rw1r_32x256_8		sram_B_8(
			.clk0(clk_write), 
			.csb0(csb0), 
			.web0(web), 
			.wmask0(wmask0), 
			.addr0(addr_write), 
			.din0(t_data), 
			.dout0(_unused_doutB8), 
			.clk1(clk_out), 
			.csb1(csb0), 
			.addr1(addr_read_8), 
			.dout1(block_B_8)); 

	sky130_sram_1kbyte_1rw1r_32x256_8		sram_B_9(
			.clk0(clk_write), 
			.csb0(csb0), 
			.web0(web), 
			.wmask0(wmask0), 
			.addr0(addr_write), 
			.din0(t_data), 
			.dout0(_unused_doutB9), 
			.clk1(clk_out), 
			.csb1(csb0), 
			.addr1(addr_read_9), 
			.dout1(block_B_9)); 




	processor_block
			pb(  
	.clk(clk_calc),
	.block_A(block_A), 
	.block_B_1(block_B_1), 
	.block_B_2(block_B_2), 
	.block_B_3(block_B_3), 
	.block_B_4(block_B_4), 
	.block_B_5(block_B_5), 
	.block_B_6(block_B_6), 
	.block_B_7(block_B_7), 
	.block_B_8(block_B_8), 
	.block_B_9(block_B_9), 
	.motion_vec_x(motion_vec_x),
	.motion_vec_y(motion_vec_y),
	.min_sae(min_sae));



	
endmodule
