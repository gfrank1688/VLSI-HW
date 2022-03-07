`include "../../include/AXI_define.svh"
`include "./AR_ch.sv"
`include "./AW_ch.sv"
`include "./W_ch.sv"
`include "./B_ch.sv"
`include "./R_ch.sv"
`include "./DefaultSlave.sv"

module AXI(

	input ACLK,
	input ARESETn,

	//SLAVE INTERFACE FOR MASTERS
	//WRITE ADDRESS
	input [`AXI_ID_BITS-1:0] AWID_M1,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	input [1:0] AWBURST_M1,
	input AWVALID_M1,
	output AWREADY_M1,
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_M1,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	input WLAST_M1,
	input WVALID_M1,
	output WREADY_M1,
	//WRITE RESPONSE
	output [`AXI_ID_BITS-1:0] BID_M1,
	output [1:0] BRESP_M1,
	output BVALID_M1,
	input BREADY_M1,

	//READ ADDRESS0
	input [`AXI_ID_BITS-1:0] ARID_M0,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
	input [1:0] ARBURST_M0,
	input ARVALID_M0,
	output ARREADY_M0,
	//READ DATA0
	output [`AXI_ID_BITS-1:0] RID_M0,
	output [`AXI_DATA_BITS-1:0] RDATA_M0,
	output [1:0] RRESP_M0,
	output RLAST_M0,
	output RVALID_M0,
	input RREADY_M0,
	//READ ADDRESS1
	input [`AXI_ID_BITS-1:0] ARID_M1,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
	input [1:0] ARBURST_M1,
	input ARVALID_M1,
	output ARREADY_M1,
	//READ DATA1
	output [`AXI_ID_BITS-1:0] RID_M1,
	output [`AXI_DATA_BITS-1:0] RDATA_M1,
	output [1:0] RRESP_M1,
	output RLAST_M1,
	output RVALID_M1,
	input RREADY_M1,

	//MASTER INTERFACE FOR SLAVES
	//WRITE ADDRESS0
	output [`AXI_IDS_BITS-1:0] AWID_S0,
	output [`AXI_ADDR_BITS-1:0] AWADDR_S0,
	output [`AXI_LEN_BITS-1:0] AWLEN_S0,
	output [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
	output [1:0] AWBURST_S0,
	output AWVALID_S0,
	input AWREADY_S0,
	//WRITE DATA0
	output [`AXI_DATA_BITS-1:0] WDATA_S0,
	output [`AXI_STRB_BITS-1:0] WSTRB_S0,
	output WLAST_S0,
	output WVALID_S0,
	input WREADY_S0,
	//WRITE RESPONSE0
	input [`AXI_IDS_BITS-1:0] BID_S0,
	input [1:0] BRESP_S0,
	input BVALID_S0,
	output BREADY_S0,
	
	//WRITE ADDRESS1
	output [`AXI_IDS_BITS-1:0] AWID_S1,
	output [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output [1:0] AWBURST_S1,
	output AWVALID_S1,
	input AWREADY_S1,
	//WRITE DATA1
	output [`AXI_DATA_BITS-1:0] WDATA_S1,
	output [`AXI_STRB_BITS-1:0] WSTRB_S1,
	output WLAST_S1,
	output WVALID_S1,
	input WREADY_S1,
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S1,
	input [1:0] BRESP_S1,
	input BVALID_S1,
	output BREADY_S1,
	
	//READ ADDRESS0
	output [`AXI_IDS_BITS-1:0] ARID_S0,
	output [`AXI_ADDR_BITS-1:0] ARADDR_S0,
	output [`AXI_LEN_BITS-1:0] ARLEN_S0,
	output [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
	output [1:0] ARBURST_S0,
	output ARVALID_S0,
	input ARREADY_S0,
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S0,
	input [`AXI_DATA_BITS-1:0] RDATA_S0,
	input [1:0] RRESP_S0,
	input RLAST_S0,
	input RVALID_S0,
	output RREADY_S0,
	//READ ADDRESS1
	output [`AXI_IDS_BITS-1:0] ARID_S1,
	output [`AXI_ADDR_BITS-1:0] ARADDR_S1,
	output [`AXI_LEN_BITS-1:0] ARLEN_S1,
	output [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
	output [1:0] ARBURST_S1,
	output ARVALID_S1,
	input ARREADY_S1,
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S1,
	input [`AXI_DATA_BITS-1:0] RDATA_S1,
	input [1:0] RRESP_S1,
	input RLAST_S1,
	input RVALID_S1,
	output RREADY_S1
	
);
    //---------- you should put your design here ----------//

logic [`AXI_MASTER_BITS-1:0] MASTER;
// default Slave
logic [`AXI_IDS_BITS  -1:0] ARID_S2;
logic [`AXI_ADDR_BITS -1:0] ARADDR_S2;
logic [`AXI_LEN_BITS  -1:0] ARLEN_S2;
logic [`AXI_SIZE_BITS -1:0] ARSIZE_S2;
logic [`AXI_BURST_BITS-1:0] ARBURST_S2;
logic ARVALID_S2;
logic ARREADY_S2;
logic [`AXI_IDS_BITS  -1:0 ] AWID_S2;
logic [`AXI_ADDR_BITS -1:0] AWADDR_S2;
logic [`AXI_LEN_BITS  -1:0 ] AWLEN_S2;
logic [`AXI_SIZE_BITS -1:0] AWSIZE_S2;
logic [`AXI_BURST_BITS-1:0] AWBURST_S2;
logic AWVALID_S2;
logic AWREADY_S2;
logic [`AXI_DATA_BITS-1:0] WDATA_S2;
logic [`AXI_STRB_BITS-1:0] WSTRB_S2;
logic WLAST_S2;
logic WVALID_S2;
logic WREADY_S2;
logic [`AXI_IDS_BITS -1:0] BID_S2;
logic [`AXI_RESP_BITS-1:0] BRESP_S2;
logic BVALID_S2;
logic BREADY_S2;
logic [`AXI_IDS_BITS -1:0] RID_S2;
logic [`AXI_DATA_BITS-1:0] RDATA_S2;
logic [`AXI_RESP_BITS-1:0] RRESP_S2;
logic RLAST_S2;
logic RVALID_S2;
logic RREADY_S2;


	AR_ch i_ar (
		.clk        (ACLK      ),
		.rst        (ARESETn   ),
		// M0
		.id_m0_i    (ARID_M0  ),
		.addr_m0_i  (ARADDR_M0),
		.len_m0_i   (ARLEN_M0 ),
		.size_m0_i  (ARSIZE_M0),
		.burst_m0_i (ARBURST_M0),
		.valid_m0_i (ARVALID_M0),
		.ready_m0_o (ARREADY_M0),
		// M1
		.id_m1_i    (ARID_M1   ),
		.addr_m1_i  (ARADDR_M1 ),
		.len_m1_i   (ARLEN_M1  ),
		.size_m1_i  (ARSIZE_M1 ),
		.burst_m1_i (ARBURST_M1),
		.valid_m1_i (ARVALID_M1),
		.ready_m1_o (ARREADY_M1),
		// S0
		.id_s0_o    (ARID_S0   ),
		.addr_s0_o  (ARADDR_S0 ),
		.len_s0_o   (ARLEN_S0  ),
		.size_s0_o  (ARSIZE_S0 ),
		.burst_s0_o (ARBURST_S0),
		.valid_s0_o (ARVALID_S0),
		.ready_s0_i (ARREADY_S0),
		// S1
		.id_s1_o    (ARID_S1   ),
		.addr_s1_o  (ARADDR_S1 ),
		.len_s1_o   (ARLEN_S1  ),
		.size_s1_o  (ARSIZE_S1 ),
		.burst_s1_o (ARBURST_S1),
		.valid_s1_o (ARVALID_S1),
		.ready_s1_i (ARREADY_S1),
		// S2
		.id_s2_o    (ARID_S2   ),
		.addr_s2_o  (ARADDR_S2 ),
		.len_s2_o   (ARLEN_S2  ),
		.size_s2_o  (ARSIZE_S2 ),
		.burst_s2_o (ARBURST_S2),
		.valid_s2_o (ARVALID_S2),
		.ready_s2_i (ARREADY_S2)
	);

	R_ch i_r (
		.clk        (ACLK     ),
		.rst        (ARESETn  ),
		.id_m0_o    (RID_M0   ),
		.data_m0_o  (RDATA_M0 ),
		.resp_m0_o  (RRESP_M0 ),
		.last_m0_o  (RLAST_M0 ),
		.valid_m0_o (RVALID_M0),
		.ready_m0_i (RREADY_M0),
		.id_m1_o    (RID_M1   ),
		.data_m1_o  (RDATA_M1 ),
		.resp_m1_o  (RRESP_M1 ),
		.last_m1_o  (RLAST_M1 ),
		.valid_m1_o (RVALID_M1),
		.ready_m1_i (RREADY_M1),

		.id_s0_i    (RID_S0   ),
		.data_s0_i  (RDATA_S0 ),
		.resp_s0_o  (RRESP_S0 ),
		.last_s0_i  (RLAST_S0 ),
		.valid_s0_i (RVALID_S0),
		.ready_s0_o (RREADY_S0),
		.id_s1_i    (RID_S1   ),
		.data_s1_i  (RDATA_S1 ),
		.resp_s1_o  (RRESP_S1 ),
		.last_s1_i  (RLAST_S1 ),
		.valid_s1_i (RVALID_S1),
		.ready_s1_o (RREADY_S1),
		.id_s2_i    (RID_S2   ),
		.data_s2_i  (RDATA_S2 ),
		.resp_s2_o  (RRESP_S2 ),
		.last_s2_i  (RLAST_S2 ),
		.valid_s2_i (RVALID_S2),
		.ready_s2_o (RREADY_S2)
	);
	AW_ch i_aw (
		.clk        (ACLK      ),
		.rst        (ARESETn   ),
		// M0
		.id_m1_i    (AWID_M1   ),
		.addr_m1_i  (AWADDR_M1 ),
		.len_m1_i   (AWLEN_M1  ),
		.size_m1_i  (AWSIZE_M1 ),
		.burst_m1_i (AWBURST_M1),
		.valid_m1_i (AWVALID_M1),
		.ready_m1_o (AWREADY_M1),
		// S0
		.id_s0_o    (AWID_S0   ),
		.addr_s0_o  (AWADDR_S0 ),
		.len_s0_o   (AWLEN_S0  ),
		.size_s0_o  (AWSIZE_S0 ),
		.burst_s0_o (AWBURST_S0),
		.valid_s0_o (AWVALID_S0),
		.ready_s0_i (AWREADY_S0),
		// S1
		.id_s1_o    (AWID_S1   ),
		.addr_s1_o  (AWADDR_S1 ),
		.len_s1_o   (AWLEN_S1  ),
		.size_s1_o  (AWSIZE_S1 ),
		.burst_s1_o (AWBURST_S1),
		.valid_s1_o (AWVALID_S1),
		.ready_s1_i (AWREADY_S1),
		// S2
		.id_s2_o    (AWID_S2   ),
		.addr_s2_o  (AWADDR_S2 ),
		.len_s2_o   (AWLEN_S2  ),
		.size_s2_o  (AWSIZE_S2 ),
		.burst_s2_o (AWBURST_S2),
		.valid_s2_o (AWVALID_S2),
		.ready_s2_i (AWREADY_S2)
	);

	W_ch i_w (
		.clk        (ACLK     ),
		.rst        (ARESETn  ),
		.data_m1_i  (WDATA_M1 ),
		.strb_m1_i  (WSTRB_M1 ),
		.last_m1_i  (WLAST_M1 ),
		.valid_m1_i (WVALID_M1),
		.ready_m1_o (WREADY_M1),

		.data_s0_o  (WDATA_S0 ),
		.strb_s0_o  (WSTRB_S0 ),
		.last_s0_o  (WLAST_S0 ),
		.valid_s0_o (WVALID_S0),
		.ready_s0_i (WREADY_S0),
		.data_s1_o  (WDATA_S1 ),
		.strb_s1_o  (WSTRB_S1 ),
		.last_s1_o  (WLAST_S1 ),
		.valid_s1_o (WVALID_S1),
		.ready_s1_i (WREADY_S1),
		.data_s2_o  (WDATA_S2 ),
		.strb_s2_o  (WSTRB_S2 ),
		.last_s2_o  (WLAST_S2 ),
		.valid_s2_o (WVALID_S2),
		.ready_s2_i (WREADY_S2),

		.awvalid_s0_i(AWVALID_S0),
		.awvalid_s1_i(AWVALID_S1),
		.awvalid_s2_i(AWVALID_S2)
	);

	B_ch i_b(
		.clk        (ACLK     ),
		.rst        (ARESETn  ),
		.id_m1_o    (BID_M1   ),
		.resp_m1_o  (BRESP_M1 ),
		.valid_m1_o (BVALID_M1),
		.ready_m1_i (BREADY_M1),
		.ids_s0_i   (BID_S0   ),
		.resp_s0_i  (BRESP_S0 ),
		.valid_s0_i (BVALID_S0),
		.ready_s0_o (BREADY_S0),
		.ids_s1_i   (BID_S1   ),
		.resp_s1_i  (BRESP_S1 ),
		.valid_s1_i (BVALID_S1),
		.ready_s1_o (BREADY_S1),
		.ids_s2_i   (BID_S2   ),
		.resp_s2_i  (BRESP_S2 ),
		.valid_s2_i (BVALID_S2),
		.ready_s2_o (BREADY_S2)

	);

	DefaultSlave i_slave(
		.clk       (ACLK      ),
		.rst       (ARESETn   ),
		.awid_i    (AWID_S2   ),
		.awaddr_i  (AWADDR_S2 ),
		.awlen_i   (AWLEN_S2  ),
		.awsize_i  (AWSIZE_S2 ),
		.awburst_i (AWBURST_S2),
		.awvalid_i (AWVALID_S2),
		.awready_o (AWREADY_S2),
		.wdata_i   (WDATA_S2  ),
		.wstrb_i   (WSTRB_S2  ),
		.wlast_i   (WLAST_S2  ),
		.wvalid_i  (WVALID_S2 ),
		.wready_o  (WREADY_S2 ),
		.bid_o     (BID_S2    ),
		.bresp_o   (BRESP_S2  ),
		.bvalid_o  (BVALID_S2 ),
		.bready_i  (BREADY_S2 ),
		.arid_i    (ARID_S2   ),  
		.araddr_i  (ARADDR_S2 ),
		.arlen_i   (ARLEN_S2  ),
		.arsize_i  (ARSIZE_S2 ),
		.arburst_i (ARBURST_S2),
		.arvalid_i (ARVALID_S2),
		.arready_o (ARREADY_S2),
		.rid_o     (RID_S2    ),
		.rdata_o   (RDATA_S2  ),
		.rresp_o   (RRESP_S2  ),
		.rlast_o   (RLAST_S2  ),
		.rvalid_o  (RVALID_S2 ),
		.rready_i  (RREADY_S2 )
	);


endmodule
