`include "AXI_define.svh"
`include "Master.sv"
`include "CPU.sv"
module CPU_wrapper(
    ACLK,ARESETn,
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
    input ACLK,ARESETn;
    output logic [`AXI_ID_BITS-1:0] AWID_M1;
    output logic [`AXI_ADDR_BITS-1:0] AWADDR_M1;
    output logic [`AXI_LEN_BITS-1:0] AWLEN_M1;
    output logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1;
    output logic [1:0] AWBURST_M1;
    output logic AWVALID_M1;
    input AWREADY_M1;

    output logic [`AXI_DATA_BITS-1:0] WDATA_M1;
    output logic [`AXI_STRB_BITS-1:0] WSTRB_M1;
    output logic WLAST_M1;
    output logic WVALID_M1;
    input WREADY_M1;

    input [`AXI_ID_BITS-1:0] BID_M1;
    input [1:0] BRESP_M1;
    input BVALID_M1;
    output logic BREADY_M1;

    output logic [`AXI_ID_BITS-1:0] ARID_M1;
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_M1;
    output logic [`AXI_LEN_BITS-1:0] ARLEN_M1;
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1;
    output logic [1:0] ARBURST_M1;
    output logic ARVALID_M1;
    input ARREADY_M1;

    input [`AXI_ID_BITS-1:0] RID_M1;
    input [`AXI_DATA_BITS-1:0] RDATA_M1;
    input [1:0] RRESP_M1;
    input RLAST_M1;
    input RVALID_M1;
    output logic RREADY_M1;

    output logic [`AXI_ID_BITS-1:0] AWID_M0;
    output logic [`AXI_ADDR_BITS-1:0] AWADDR_M0;
    output logic [`AXI_LEN_BITS-1:0] AWLEN_M0;
    output logic [`AXI_SIZE_BITS-1:0] AWSIZE_M0;
    output logic [1:0] AWBURST_M0;
    output logic AWVALID_M0;
    input AWREADY_M0;

    output logic [`AXI_DATA_BITS-1:0] WDATA_M0;
    output logic [`AXI_STRB_BITS-1:0] WSTRB_M0;
    output logic WLAST_M0;
    output logic WVALID_M0;
    input WREADY_M0;

    input [`AXI_ID_BITS-1:0] BID_M0;
    input [1:0] BRESP_M0;
    input BVALID_M0;
    output logic BREADY_M0;

    output logic [`AXI_ID_BITS-1:0] ARID_M0;
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_M0;
    output logic [`AXI_LEN_BITS-1:0] ARLEN_M0;
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0;
    output logic [1:0] ARBURST_M0;
    output logic ARVALID_M0;
    input ARREADY_M0;

    input [`AXI_ID_BITS-1:0] RID_M0;
    input [`AXI_DATA_BITS-1:0] RDATA_M0;
    input [1:0] RRESP_M0;
    input RLAST_M0;
    input RVALID_M0;
    output logic RREADY_M0;

    logic [31:0] pc_out;
    logic [31:0] instr;
    logic chip;
    logic MEM_Memread,MEM_Memwrite;
    logic [3:0] mmwrite;
    logic [31:0] MEM_alu_out;
    logic [31:0] MEM_data_in;
    logic [31:0] MEM_data_out;
    logic IM_stall,DM_stall;

    logic lock_dm;
    logic mem_read,mem_write;
    always_ff @(posedge ACLK or negedge ARESETn) begin
        if(~ARESETn) lock_dm<=1'b0;
        else lock_dm<=(~IM_stall)?1'b0:((IM_stall & ~DM_stall)? 1'b1: lock_dm); 
    end
    assign mem_read=MEM_Memread&~lock_dm;
    assign mem_write=MEM_Memwrite&~lock_dm;

    CPU cpu(ACLK,~ARESETn,pc_out,instr,chip,MEM_Memread,MEM_Memwrite,mmwrite,MEM_alu_out,MEM_data_in,MEM_data_out,IM_stall,DM_stall);
    
    Master i(
        ACLK,ARESETn,
        AWID_M0,AWADDR_M0,AWLEN_M0,AWSIZE_M0,AWBURST_M0,AWVALID_M0,AWREADY_M0,
        WDATA_M0,WSTRB_M0,WLAST_M0,WVALID_M0,WREADY_M0,
        BID_M0,BRESP_M0,BVALID_M0,BREADY_M0,
        ARID_M0,ARADDR_M0,ARLEN_M0,ARSIZE_M0,ARBURST_M0,ARVALID_M0,ARREADY_M0,
        RID_M0,RDATA_M0,RRESP_M0,RLAST_M0,RVALID_M0,RREADY_M0,
        1'b1,1'b0,4'hf,32'd0,pc_out,instr,IM_stall
    );

    Master d(
        ACLK,ARESETn,
        AWID_M1,AWADDR_M1,AWLEN_M1,AWSIZE_M1,AWBURST_M1,AWVALID_M1,AWREADY_M1,
        WDATA_M1,WSTRB_M1,WLAST_M1,WVALID_M1,WREADY_M1,
        BID_M1,BRESP_M1,BVALID_M1,BREADY_M1,
        ARID_M1,ARADDR_M1,ARLEN_M1,ARSIZE_M1,ARBURST_M1,ARVALID_M1,ARREADY_M1,
        RID_M1,RDATA_M1,RRESP_M1,RLAST_M1,RVALID_M1,RREADY_M1,
        mem_read,mem_write,mmwrite,MEM_data_in,MEM_alu_out,MEM_data_out,DM_stall
    );
    
    
endmodule