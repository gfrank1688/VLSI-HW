`include "AXI_define.svh"
module Master (
    ACLK,ARESETn,
    AWID,AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID,AWREADY,
    WDATA,WSTRB,WLAST,WVALID,WREADY,
    BID,BRESP,BVALID,BREADY,
    ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID,ARREADY,
    RID,RDATA,RRESP,RLAST,RVALID,RREADY,
    read,write,strb,data_in,addr,data_out,stall
);
    input ACLK,ARESETn;
    output logic [`AXI_ID_BITS-1:0] AWID;
    output logic [`AXI_ADDR_BITS-1:0] AWADDR;
    output logic [`AXI_LEN_BITS-1:0] AWLEN;
    output logic [`AXI_SIZE_BITS-1:0] AWSIZE;
    output logic [1:0] AWBURST;
    output logic AWVALID;
    input AWREADY;

    output logic [`AXI_DATA_BITS-1:0] WDATA;
    output logic [`AXI_STRB_BITS-1:0] WSTRB;
    output logic WLAST;
    output logic WVALID;
    input WREADY;

    input [`AXI_ID_BITS-1:0] BID;
    input [1:0] BRESP;
    input BVALID;
    output logic BREADY;

    output logic [`AXI_ID_BITS-1:0] ARID;
    output logic [`AXI_ADDR_BITS-1:0] ARADDR;
    output logic [`AXI_LEN_BITS-1:0] ARLEN;
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE;
    output logic [1:0] ARBURST;
    output logic ARVALID;
    input ARREADY;

    input [`AXI_ID_BITS-1:0] RID;
    input [`AXI_DATA_BITS-1:0] RDATA;
    input [1:0] RRESP;
    input RLAST;
    input RVALID;
    output logic RREADY;

    input read,write;
    input [`AXI_STRB_BITS-1:0] strb;
    input [31:0] data_in,addr;
    output logic [31:0] data_out;
    output logic stall;

    logic [2:0] state,next_state;

    always_ff @(posedge ACLK or negedge ARESETn) begin
        if(~ARESETn) state<=3'b0;
        else state<=next_state;
    end

    always_comb begin
        case (state)
            3'b000:begin
                if(ARVALID) next_state=3'b001;
                else if(AWVALID) next_state=3'b011;
                else if(ARVALID&&(ARVALID&&ARREADY)) next_state=3'b010;
                else if(AWVALID&&(AWVALID&&AWREADY)) next_state=3'b100;
                else next_state=3'b000;
            end
            3'b001:begin
                if(ARVALID&&ARREADY) next_state=3'b010;
                else next_state=3'b001;
            end
            3'b010:begin
                if(RVALID&&RREADY) next_state=3'b000;
                else next_state=3'b010;
            end
            3'b011:begin
                if(AWVALID&&AWREADY) next_state=3'b100;
                else next_state=3'b011;
            end
            3'b100:begin
                if(WVALID&&WREADY) next_state=3'b101;
                else next_state=3'b100;
            end
            3'b101:begin
                if(BVALID&&BREADY&&ARVALID) next_state=3'b001;
                else if(BVALID&&BREADY&&AWVALID) next_state=3'b011;
                else if(~(BVALID&&BREADY))next_state=3'b101;
                else next_state=3'b000;
            end
            default:begin
                next_state=3'b0;
            end
        endcase
    end

    assign AWID=`AXI_ID_BITS'b0;
    assign AWADDR=addr;
    assign AWLEN=`AXI_LEN_BITS'b0;
    assign AWSIZE=`AXI_SIZE_BITS'b10;
    assign AWBURST=`AXI_BURST_INC;

    assign WDATA=data_in;
    assign WSTRB=strb;
    assign WLAST=1'b1;
    assign WVALID=(state==3'b100)?1'b1:1'b0;

    assign BREADY=(state==3'b101|(WVALID&WREADY))?1'b1:1'b0;

    assign ARID=`AXI_ID_BITS'b0;
    assign ARADDR=addr;
    assign ARLEN=`AXI_LEN_BITS'b0;
    assign ARSIZE=`AXI_SIZE_BITS'b10;
    assign ARBURST=`AXI_BURST_INC;

    assign RREADY=(state==3'b010)?1'b1:1'b0;

    logic [31:0] data;
    assign data_out=(RVALID&RREADY)?RDATA:data;
    always_ff @(posedge ACLK or negedge ARESETn) begin
        if(~ARESETn) data<=32'd0;
        else data<=(RVALID&RREADY)?RDATA:data;
    end

    assign stall=(read&~(RVALID&RREADY))|(write&~(WVALID&WREADY));

    logic r,w;
    always_ff @(posedge ACLK or negedge ARESETn) begin
        if(~ARESETn) begin
            r<=1'b0;
            w<=1'b0;
        end
        else begin
            r<=1'b1;
            w<=1'b1;
        end
    end

    always_comb begin
        case (state)
            3'b000:begin
                ARVALID=read&r;
                AWVALID=write&w;
            end
            3'b001:begin
                ARVALID=1'b1;
                AWVALID=1'b0;
            end
            3'b011:begin
                ARVALID=1'b0;
                AWVALID=1'b1;
            end
            default:begin
                ARVALID=1'b0;
                AWVALID=1'b0;
            end
        endcase
    end





    
endmodule