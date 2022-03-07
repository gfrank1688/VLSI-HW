`ifndef __DECODER__
`define __DECODER__

`include "../../include/AXI_define.svh"

module Decoder (
	input [`AXI_ADDR_BITS-1:0] addr_i,
    input        valid_i, 
    input        ready_s0_i,
    input        ready_s1_i,
    input        ready_s2_i,
    output logic valid_s0_o,
    output logic valid_s1_o,
    output logic valid_s2_o,
    output logic ready_o
);
	always_comb begin
		case (addr_i[`AXI_ADDR_BITS-1:16])
			16'h0  : begin
				ready_o    = valid_i ? ready_s0_i : 1'b1;
				valid_s0_o = valid_i;
				valid_s1_o = 1'b0;
				valid_s2_o = 1'b0;
			end
			16'h1   : begin
				ready_o    = valid_i ? ready_s1_i : 1'b1;
				valid_s0_o = 1'b0;
				valid_s1_o = valid_i;
				valid_s2_o = 1'b0;
			end
			default :begin
				ready_o    = valid_i ? ready_s2_i : 1'b1;
				valid_s0_o = 1'b0;
				valid_s1_o = 1'b0;
				valid_s2_o = valid_i;
			end
		endcase
	end

endmodule

`endif