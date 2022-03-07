`include "AXI_define.svh"
`define STATE_BITS 3


module SRAM_wrapper(
    input ACLK,
    input ARESETn,
	input [`AXI_IDS_BITS-1:0] AWID,
	input [`AXI_ADDR_BITS-1:0] AWADDR,
	input [`AXI_LEN_BITS-1:0] AWLEN,
	input [`AXI_SIZE_BITS-1:0] AWSIZE,
	input [1:0] AWBURST,
	input AWVALID,
	output logic AWREADY,
	//WRITE DATA0
	input [`AXI_DATA_BITS-1:0] WDATA,
	input [`AXI_STRB_BITS-1:0] WSTRB,
	input WLAST,
	input WVALID,
	output logic WREADY,
	//WRITE RESPONSE0
	output logic [`AXI_IDS_BITS-1:0] BID,
	output logic [1:0] BRESP,
	output logic BVALID,
	input BREADY,
	
	//READ ADDRESS0
	input [`AXI_IDS_BITS-1:0] ARID,
	input [`AXI_ADDR_BITS-1:0] ARADDR,
	input [`AXI_LEN_BITS-1:0] ARLEN,
	input [`AXI_SIZE_BITS-1:0] ARSIZE,
	input [1:0] ARBURST,
	input ARVALID,
	output logic ARREADY,
	//READ DATA0
	output logic [`AXI_IDS_BITS-1:0] RID,
	output logic [`AXI_DATA_BITS-1:0] RDATA,
	output logic [1:0] RRESP,
	output logic RLAST,
	output logic RVALID,
	input RREADY
);

logic [13:0] A;
logic [`AXI_DATA_BITS-1:0] DI;
logic [`AXI_DATA_BITS-1:0] DO;
logic [`AXI_STRB_BITS-1:0] WEB;
logic CS;
logic OE;

logic [1:0] state,next_state;
always_ff @(posedge ACLK or negedge ARESETn ) begin
    if(~ARESETn) state<=2'b00;
    else state<=next_state;
end

logic R;
assign R=(RVALID&RREADY)&RLAST;
logic W;
assign W=(WVALID&WREADY)&WLAST;
always_comb begin
    case(state)
        2'b00:begin
            if((AWVALID&&AWREADY)&&(WVALID&&WREADY)) next_state=2'b11;
            else if (ARVALID&&ARREADY) next_state=2'b01;
            else if (AWVALID&&AWREADY) next_state=2'b10;
            else next_state=2'b00;
        end
        2'b01:begin
            if(R) next_state=2'b00;
            else if(R&&(ARVALID&&ARREADY)) next_state=2'b01;
            else if((AWVALID&&AWREADY)&&R) next_state=2'b10;
            else next_state=2'b01;
        end
        2'b10:begin
            if(W) next_state=2'b11;
            else next_state=2'b10;
        end
        2'b11:begin
            if((BVALID&&BREADY)&&(AWVALID&&AWREADY)) next_state=2'b10;
            else if((BVALID&&BREADY)&&(ARVALID&&ARREADY)) next_state=2'b01;
            else if(BVALID&&BREADY) next_state=2'b00;
            else next_state=2'b11;
        end
    endcase
end

always_comb begin
    case (state)
        2'b00:begin
            AWREADY=1'b1;
            ARREADY=~AWVALID;
        end
        2'b01:begin
            AWREADY=(RVALID&RREADY);
            ARREADY=(RVALID&RREADY)&~AWVALID;
        end
        2'b10:begin
            AWREADY=1'b0;
            ARREADY=1'b0;
        end
        2'b11:begin
            AWREADY=(BVALID&BREADY);
            ARREADY=(BVALID&BREADY)&~AWVALID;
        end
    endcase
end

assign WREADY=(state==2'b10)?1'b1:1'b0;

logic [`AXI_IDS_BITS-1:0] b_id,r_id;
always_ff @(posedge ACLK or negedge ARESETn) begin
    if(~ARESETn) begin
        b_id<=`AXI_IDS_BITS'b0;
        r_id<=`AXI_IDS_BITS'b0;
    end
    else begin
        b_id<=(AWVALID&AWREADY)?AWID:b_id;
        r_id<=(ARVALID&&ARREADY)?ARID:r_id;
    end
end
assign BID=b_id;
assign RID=r_id;

logic [`AXI_LEN_BITS-1:0] c,arlen;
always @(posedge ACLK or negedge ARESETn) begin
    if(~ARESETn) begin
        c<=`AXI_LEN_BITS'b0;
        arlen<=`AXI_LEN_BITS'b0;
    end
    else begin
        if(state==2'b01) c<=(R)?`AXI_LEN_BITS'b0:((RVALID&RREADY)?c+`AXI_LEN_BITS'b1:c);
        else if(state==2'b10) c<=(W)?`AXI_LEN_BITS'b0:((WVALID&WREADY)?c+`AXI_LEN_BITS'b1:c);
        arlen<=(ARVALID&ARREADY)?ARLEN:arlen;
    end
end
assign RLAST=(arlen == c);

assign RVALID=(state==2'b01)?1'b1:1'b0;
assign BVALID=(state==2'b11)?1'b1:1'b0;

assign RRESP=`AXI_RESP_OKAY;
assign BRESP=`AXI_RESP_OKAY;

logic rvalid;
logic [`AXI_DATA_BITS-1:0] data;
always_ff @(posedge ACLK or negedge ARESETn) begin
  if(~ARESETn) begin
    rvalid<=1'b0;
    data<=`AXI_DATA_BITS'b0;
  end
  else begin
    rvalid<=RVALID;
    data<=(RVALID&~rvalid)?DO:data;
  end
end
assign RDATA=(RVALID&rvalid)?data:DO;

assign WEB=WSTRB;
assign DI=WDATA;

logic [13:0] w_addr,r_addr;
always_comb begin
  case (state)
    2'b00:begin
      CS=AWVALID|ARVALID;
      OE=~AWVALID&(ARVALID&ARREADY);
      A=(AWVALID&AWREADY)?AWADDR[15:2]:ARADDR[15:2];
    end
    2'b01:begin
      CS=1'b1;
      OE=1'b1;
      A=r_addr;
    end
    2'b10:begin
      CS=1'b1;
      OE=1'b0;
      A=w_addr;
    end
    2'b11:begin
      CS=1'b1;
      OE=1'b0;
      A=~(BVALID&BREADY)?w_addr:((AWVALID&AWREADY)?AWADDR[15:2]:ARADDR[15:2]);
    end
  endcase
end

always_ff @(posedge ACLK or negedge ARESETn) begin
  if(~ARESETn) begin
    w_addr<=14'b0;
    r_addr<=14'b0;
  end
  else begin
    w_addr<=(AWVALID&AWREADY)?AWADDR[15:2]:w_addr;
    r_addr<=(ARVALID&ARREADY)?ARADDR[15:2]:r_addr;
  end
end



  SRAM i_SRAM (
    .A0   (A[0]  ),
    .A1   (A[1]  ),
    .A2   (A[2]  ),
    .A3   (A[3]  ),
    .A4   (A[4]  ),
    .A5   (A[5]  ),
    .A6   (A[6]  ),
    .A7   (A[7]  ),
    .A8   (A[8]  ),
    .A9   (A[9]  ),
    .A10  (A[10] ),
    .A11  (A[11] ),
    .A12  (A[12] ),
    .A13  (A[13] ),
    .DO0  (DO[0] ),
    .DO1  (DO[1] ),
    .DO2  (DO[2] ),
    .DO3  (DO[3] ),
    .DO4  (DO[4] ),
    .DO5  (DO[5] ),
    .DO6  (DO[6] ),
    .DO7  (DO[7] ),
    .DO8  (DO[8] ),
    .DO9  (DO[9] ),
    .DO10 (DO[10]),
    .DO11 (DO[11]),
    .DO12 (DO[12]),
    .DO13 (DO[13]),
    .DO14 (DO[14]),
    .DO15 (DO[15]),
    .DO16 (DO[16]),
    .DO17 (DO[17]),
    .DO18 (DO[18]),
    .DO19 (DO[19]),
    .DO20 (DO[20]),
    .DO21 (DO[21]),
    .DO22 (DO[22]),
    .DO23 (DO[23]),
    .DO24 (DO[24]),
    .DO25 (DO[25]),
    .DO26 (DO[26]),
    .DO27 (DO[27]),
    .DO28 (DO[28]),
    .DO29 (DO[29]),
    .DO30 (DO[30]),
    .DO31 (DO[31]),
    .DI0  (DI[0] ),
    .DI1  (DI[1] ),
    .DI2  (DI[2] ),
    .DI3  (DI[3] ),
    .DI4  (DI[4] ),
    .DI5  (DI[5] ),
    .DI6  (DI[6] ),
    .DI7  (DI[7] ),
    .DI8  (DI[8] ),
    .DI9  (DI[9] ),
    .DI10 (DI[10]),
    .DI11 (DI[11]),
    .DI12 (DI[12]),
    .DI13 (DI[13]),
    .DI14 (DI[14]),
    .DI15 (DI[15]),
    .DI16 (DI[16]),
    .DI17 (DI[17]),
    .DI18 (DI[18]),
    .DI19 (DI[19]),
    .DI20 (DI[20]),
    .DI21 (DI[21]),
    .DI22 (DI[22]),
    .DI23 (DI[23]),
    .DI24 (DI[24]),
    .DI25 (DI[25]),
    .DI26 (DI[26]),
    .DI27 (DI[27]),
    .DI28 (DI[28]),
    .DI29 (DI[29]),
    .DI30 (DI[30]),
    .DI31 (DI[31]),
    .CK   (ACLK  ),
    .WEB0 (WEB[0]),
    .WEB1 (WEB[1]),
    .WEB2 (WEB[2]),
    .WEB3 (WEB[3]),
    .OE   (OE    ),
    .CS   (CS    )
  );

endmodule
