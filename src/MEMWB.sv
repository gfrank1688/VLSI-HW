module MEMWB(
    clk,rst,
    MEM_Memread,MEM_Memwrite,MEM_Memtoreg,MEM_Regwrite,MEM_PCtoregsrc,MEM_RDsrc,
    MEM_rd_data,
    MEM_data_out,
    MEM_rd_addr,
    MEM_op,
    MEM_funct3,
    WB_Memread,WB_Memwrite,WB_Memtoreg,WB_Regwrite,WB_PCtoregsrc,WB_RDsrc,
    WB_rrd_data,
    WB_data_out,
    WB_rd_addr,
    WB_op,
    WB_funct3,
    MEMWB_stall
);
    input clk,rst;
    input MEM_Memread,MEM_Memwrite,MEM_Memtoreg,MEM_Regwrite,MEM_PCtoregsrc,MEM_RDsrc;
    input [31:0] MEM_rd_data;
    input [31:0] MEM_data_out;
    input [4:0] MEM_rd_addr;
    input [6:0] MEM_op;
    input [2:0] MEM_funct3;
    output logic WB_Memread,WB_Memwrite,WB_Memtoreg,WB_Regwrite,WB_PCtoregsrc,WB_RDsrc;
    output logic [31:0] WB_rrd_data;
    output logic [31:0] WB_data_out;
    output logic [4:0] WB_rd_addr;
    output logic [6:0] WB_op;
    output logic [2:0] WB_funct3;
    input MEMWB_stall;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            WB_Memread<=1'b0;
            WB_Memwrite<=1'b0;
            WB_Memtoreg<=1'b0;
            WB_Regwrite<=1'b0;
            WB_PCtoregsrc<=1'b0;
            WB_RDsrc<=1'b0;
            WB_rrd_data<=32'd0;
            WB_data_out<=32'd0;
            WB_rd_addr<=5'd0;
            WB_op<=7'd0;
            WB_funct3<=3'd0;
        end
        else if(MEMWB_stall)begin
            WB_Memread<=MEM_Memread;
            WB_Memwrite<=MEM_Memwrite;
            WB_Memtoreg<=MEM_Memtoreg;
            WB_Regwrite<=MEM_Regwrite;
            WB_PCtoregsrc<=MEM_PCtoregsrc;
            WB_RDsrc<=MEM_RDsrc;
            WB_rrd_data<=MEM_rd_data;
            WB_data_out<=MEM_data_out;
            WB_rd_addr<=MEM_rd_addr;
            WB_op<=MEM_op;
            WB_funct3<=MEM_funct3;
        end
    end
endmodule