`include "SRAM_wrapper.sv"
`include "CPU.sv"
`include "AXI_define.svh"
`include "AXI/AXI.sv"
`include "CPU_wrapper.sv"
module top(
	input clk,
	input rst
);

    logic [`AXI_ID_BITS-1:0] AWID_M0;
	logic [`AXI_ADDR_BITS-1:0] AWADDR_M0;
	logic [`AXI_LEN_BITS-1:0] AWLEN_M0;
	logic [`AXI_SIZE_BITS-1:0] AWSIZE_M0;
	logic [1:0] AWBURST_M0;
	logic AWVALID_M0;
	logic AWREADY_M0;
    logic [`AXI_DATA_BITS-1:0] WDATA_M0;
	logic [`AXI_STRB_BITS-1:0] WSTRB_M0;
	logic WLAST_M0;
	logic WVALID_M0;
	logic WREADY_M0;
    logic [`AXI_ID_BITS-1:0] BID_M0;
	logic [1:0] BRESP_M0;
	logic BVALID_M0;
	logic BREADY_M0;
    //SLAVE INTERFACE FOR MASTERS
	//WRITE ADDRESS
	logic [`AXI_ID_BITS-1:0] AWID_M1;
	logic [`AXI_ADDR_BITS-1:0] AWADDR_M1;
	logic [`AXI_LEN_BITS-1:0] AWLEN_M1;
	logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1;
	logic [1:0] AWBURST_M1;
	logic AWVALID_M1;
	logic AWREADY_M1;
	//WRITE DATA
	logic [`AXI_DATA_BITS-1:0] WDATA_M1;
	logic [`AXI_STRB_BITS-1:0] WSTRB_M1;
	logic WLAST_M1;
	logic WVALID_M1;
	logic WREADY_M1;
	//WRITE RESPONSE
	logic [`AXI_ID_BITS-1:0] BID_M1;
	logic [1:0] BRESP_M1;
	logic BVALID_M1;
	logic BREADY_M1;

	//READ ADDRESS0
	logic [`AXI_ID_BITS-1:0] ARID_M0;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_M0;
	logic [`AXI_LEN_BITS-1:0] ARLEN_M0;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0;
	logic [1:0] ARBURST_M0;
	logic ARVALID_M0;
	logic ARREADY_M0;
	//READ DATA0
	logic [`AXI_ID_BITS-1:0] RID_M0;
	logic [`AXI_DATA_BITS-1:0] RDATA_M0;
	logic [1:0] RRESP_M0;
	logic RLAST_M0;
	logic RVALID_M0;
	logic RREADY_M0;
	//READ ADDRESS1
	logic [`AXI_ID_BITS-1:0] ARID_M1;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_M1;
	logic [`AXI_LEN_BITS-1:0] ARLEN_M1;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1;
	logic [1:0] ARBURST_M1;
	logic ARVALID_M1;
	logic ARREADY_M1;
	//READ DATA1
	logic [`AXI_ID_BITS-1:0] RID_M1;
	logic [`AXI_DATA_BITS-1:0] RDATA_M1;
	logic [1:0] RRESP_M1;
	logic RLAST_M1;
	logic RVALID_M1;
	logic RREADY_M1;

	//MASTER INTERFACE FOR SLAVES
	//WRITE ADDRESS0
	logic [`AXI_IDS_BITS-1:0] AWID_S0;
	logic [`AXI_ADDR_BITS-1:0] AWADDR_S0;
	logic [`AXI_LEN_BITS-1:0] AWLEN_S0;
	logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0;
	logic [1:0] AWBURST_S0;
	logic AWVALID_S0;
	logic AWREADY_S0;
	//WRITE DATA0
	logic [`AXI_DATA_BITS-1:0] WDATA_S0;
	logic [`AXI_STRB_BITS-1:0] WSTRB_S0;
	logic WLAST_S0;
	logic WVALID_S0;
	logic WREADY_S0;
	//WRITE RESPONSE0
	logic [`AXI_IDS_BITS-1:0] BID_S0;
	logic [1:0] BRESP_S0;
	logic BVALID_S0;
	logic BREADY_S0;
	
	//WRITE ADDRESS1
	logic [`AXI_IDS_BITS-1:0] AWID_S1;
	logic [`AXI_ADDR_BITS-1:0] AWADDR_S1;
	logic [`AXI_LEN_BITS-1:0] AWLEN_S1;
	logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1;
	logic [1:0] AWBURST_S1;
	logic AWVALID_S1;
	logic AWREADY_S1;
	//WRITE DATA1
	logic [`AXI_DATA_BITS-1:0] WDATA_S1;
	logic [`AXI_STRB_BITS-1:0] WSTRB_S1;
	logic WLAST_S1;
	logic WVALID_S1;
	logic WREADY_S1;
	//WRITE RESPONSE1
	logic [`AXI_IDS_BITS-1:0] BID_S1;
	logic [1:0] BRESP_S1;
	logic BVALID_S1;
	logic BREADY_S1;
	
	//READ ADDRESS0
	logic [`AXI_IDS_BITS-1:0] ARID_S0;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_S0;
	logic [`AXI_LEN_BITS-1:0] ARLEN_S0;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0;
	logic [1:0] ARBURST_S0;
	logic ARVALID_S0;
	logic ARREADY_S0;
	//READ DATA0
	logic [`AXI_IDS_BITS-1:0] RID_S0;
	logic [`AXI_DATA_BITS-1:0] RDATA_S0;
	logic [1:0] RRESP_S0;
	logic RLAST_S0;
	logic RVALID_S0;
	logic RREADY_S0;
	//READ ADDRESS1
	logic [`AXI_IDS_BITS-1:0] ARID_S1;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_S1;
	logic [`AXI_LEN_BITS-1:0] ARLEN_S1;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1;
	logic [1:0] ARBURST_S1;
	logic ARVALID_S1;
	logic ARREADY_S1;
	//READ DATA1
	logic [`AXI_IDS_BITS-1:0] RID_S1;
	logic [`AXI_DATA_BITS-1:0] RDATA_S1;
	logic [1:0] RRESP_S1;
	logic RLAST_S1;
	logic RVALID_S1;
	logic RREADY_S1;
    
	assign AWREADY_M0=1'b0;
	assign WREADY_M0=1'b0;
	assign BID_M0=`AXI_ID_BITS'b0;
	assign BRESP_M0=`AXI_RESP_OKAY;
	assign BVALID_M0=1'b0;

    CPU_wrapper cpu_wrapper(
        clk,~rst,
        AWID_M1,AWADDR_M1,AWLEN_M1,AWSIZE_M1,AWBURST_M1,AWVALID_M1,AWREADY_M1,
        WDATA_M1,WSTRB_M1,WLAST_M1,WVALID_M1,WREADY_M1,
        BID_M1,BRESP_M1,BVALID_M1,BREADY_M1,
        ARID_M1,ARADDR_M1,ARLEN_M1,ARSIZE_M1,ARBURST_M1,ARVALID_M1,ARREADY_M1,
        RID_M1,RDATA_M1,RRESP_M1,RLAST_M1,RVALID_M1,RREADY_M1,
        AWID_M0,AWADDR_M0,AWLEN_M0,AWSIZE_M0,AWBURST_M0,AWVALID_M0,AWREADY_M0,
        WDATA_M0,WSTRB_M0,WLAST_M0,WVALID_M0,WREADY_M0,
        BID_M0,BRESP_M0,BVALID_M0,BREADY_M0,
        ARID_M0,ARADDR_M0,ARLEN_M0,ARSIZE_M0,ARBURST_M0,ARVALID_M0,ARREADY_M0,
        RID_M0,RDATA_M0,RRESP_M0,RLAST_M0,RVALID_M0,RREADY_M0
    );

    AXI axi(
        clk,~rst,
        AWID_M1,AWADDR_M1,AWLEN_M1,AWSIZE_M1,AWBURST_M1,AWVALID_M1,AWREADY_M1,
        WDATA_M1,WSTRB_M1,WLAST_M1,WVALID_M1,WREADY_M1,
        BID_M1,BRESP_M1,BVALID_M1,BREADY_M1,
        ARID_M0,ARADDR_M0,ARLEN_M0,ARSIZE_M0,ARBURST_M0,ARVALID_M0,ARREADY_M0,
        RID_M0,RDATA_M0,RRESP_M0,RLAST_M0,RVALID_M0,RREADY_M0,
        ARID_M1,ARADDR_M1,ARLEN_M1,ARSIZE_M1,ARBURST_M1,ARVALID_M1,ARREADY_M1,
        RID_M1,RDATA_M1,RRESP_M1,RLAST_M1,RVALID_M1,RREADY_M1,
        AWID_S0,AWADDR_S0,AWLEN_S0,AWSIZE_S0,AWBURST_S0,AWVALID_S0,AWREADY_S0,
        WDATA_S0,WSTRB_S0,WLAST_S0,WVALID_S0,WREADY_S0,
        BID_S0,BRESP_S0,BVALID_S0,BREADY_S0,
        AWID_S1,AWADDR_S1,AWLEN_S1,AWSIZE_S1,AWBURST_S1,AWVALID_S1,AWREADY_S1,
        WDATA_S1,WSTRB_S1,WLAST_S1,WVALID_S1,WREADY_S1,
        BID_S1,BRESP_S1,BVALID_S1,BREADY_S1,
        ARID_S0,ARADDR_S0,ARLEN_S0,ARSIZE_S0,ARBURST_S0,ARVALID_S0,ARREADY_S0,
        RID_S0,RDATA_S0,RRESP_S0,RLAST_S0,RVALID_S0,RREADY_S0,
        ARID_S1,ARADDR_S1,ARLEN_S1,ARSIZE_S1,ARBURST_S1,ARVALID_S1,ARREADY_S1,
        RID_S1,RDATA_S1,RRESP_S1,RLAST_S1,RVALID_S1,RREADY_S1
    );

    SRAM_wrapper IM1(
        clk,~rst,
        AWID_S0,AWADDR_S0,AWLEN_S0,AWSIZE_S0,AWBURST_S0,AWVALID_S0,AWREADY_S0,
        WDATA_S0,WSTRB_S0,WLAST_S0,WVALID_S0,WREADY_S0,
        BID_S0,BRESP_S0,BVALID_S0,BREADY_S0,
        ARID_S0,ARADDR_S0,ARLEN_S0,ARSIZE_S0,ARBURST_S0,ARVALID_S0,ARREADY_S0,
        RID_S0,RDATA_S0,RRESP_S0,RLAST_S0,RVALID_S0,RREADY_S0
    );

    SRAM_wrapper DM1(
        clk,~rst,
        AWID_S1,AWADDR_S1,AWLEN_S1,AWSIZE_S1,AWBURST_S1,AWVALID_S1,AWREADY_S1,
        WDATA_S1,WSTRB_S1,WLAST_S1,WVALID_S1,WREADY_S1,
        BID_S1,BRESP_S1,BVALID_S1,BREADY_S1,
        ARID_S1,ARADDR_S1,ARLEN_S1,ARSIZE_S1,ARBURST_S1,ARVALID_S1,ARREADY_S1,
        RID_S1,RDATA_S1,RRESP_S1,RLAST_S1,RVALID_S1,RREADY_S1
    );

    //Instruction mem
    //SRAM_wrapper IM1(~clk,1'b1,1'b1,4'b1111,pc_out[15:2],32'd0,instr);

    
    //SRAM_wrapper DM1(~clk,chip,MEM_Memread,mmwrite,MEM_alu_out[15:2],MEM_data_in,MEM_data_out);

endmodule