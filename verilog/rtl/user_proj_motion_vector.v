// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_motion_vector(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
    
    input wb_clk_i,
    input wb_rst_i,


    // IOs
    input  [7:0]io_in,
    output [15:0] io_out,
    output [23:0] io_oeb

);

    wire [9:0] min_sae;
    wire [2:0] motion_vec_x;
    wire [2:0] motion_vec_y;
    wire [7:0] s_data;

    top_level
            top(
                .s_data(s_data),
                .clk(wb_clk_i),
                .motion_vec_x(motion_vec_x),
                .motion_vec_y(motion_vec_y),
                .min_sae(min_sae),
                .rst_n(wb_rst_i));

    assign io_out = {min_sae, motion_vec_y, motion_vec_x};
    assign s_data = io_in;
    assign io_oeb[7:0] = 8'b11111111;
    assign io_oeb[23:8] = {(16){1'b0}};

endmodule
`default_nettype wire
