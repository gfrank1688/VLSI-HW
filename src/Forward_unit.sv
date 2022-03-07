module Forward_unit(EX_rs1_addr,EX_rs2_addr,MEM_rd_addr,WB_rd_addr,MEM_Regwrite,WB_Regwrite,WB_Memtoreg,WB_Memwrite,forwardrs1src,forwardrs2src,forwardRDsrc);
    input [4:0] EX_rs1_addr,EX_rs2_addr,MEM_rd_addr,WB_rd_addr;
    input MEM_Regwrite,WB_Regwrite,WB_Memtoreg,WB_Memwrite;
    output logic [1:0] forwardrs1src,forwardrs2src;
    output logic forwardRDsrc;

    //forward1
    always @(*) begin
        if((MEM_rd_addr==EX_rs1_addr)&&MEM_rd_addr!=5'b0&&MEM_Regwrite) forwardrs1src=2'b01;
        else if((WB_rd_addr==EX_rs1_addr)&&WB_rd_addr!=5'b0&&WB_Regwrite) forwardrs1src=2'b10;
        else forwardrs1src=2'b00;
    end

    //forward2
    always @(*) begin
        if((MEM_rd_addr==EX_rs2_addr)&&MEM_rd_addr!=5'b0&&MEM_Regwrite) forwardrs2src=2'b01;
        else if((WB_rd_addr==EX_rs2_addr)&&WB_rd_addr!=5'b0&&WB_Regwrite) forwardrs2src=2'b10;
        else forwardrs2src=2'b00;
    end

endmodule