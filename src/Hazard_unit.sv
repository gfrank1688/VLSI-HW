module Hazard_unit(Branch_Ctrl,EX_Memread,EX_rd_addr,rs1,rs2,ImmType,flush,EX_flush,IFIDwrite,PCwrite,IM_stall,DM_stall,IDEX_stall,EXMEM_stall,MEMWB_stall,EXMEM_flush);
    input [1:0] Branch_Ctrl;
    input EX_Memread;
    input [4:0] EX_rd_addr;
    input [4:0] rs1,rs2;
    input [2:0] ImmType;
    output logic flush,EX_flush,IFIDwrite,PCwrite;
    input IM_stall,DM_stall;
    output logic IDEX_stall;
    output logic EXMEM_stall;
    output logic MEMWB_stall;
    output logic EXMEM_flush;

    logic hazard;

    always @(*) begin
        if(IM_stall||DM_stall) begin
            flush=1'b0;
            EX_flush=1'b0;
            IFIDwrite=1'b0;
            PCwrite=1'b0;
            IDEX_stall=1'b0;
            EXMEM_stall=1'b0;
            MEMWB_stall=1'b0;
        end
        else if(Branch_Ctrl!=2'b10) begin
            flush=1'b1;
            EX_flush=1'b1;
            IFIDwrite=1'b1;
            PCwrite=1'b1;
            IDEX_stall=1'b1;
            EXMEM_stall=1'b1;
            MEMWB_stall=1'b1;
        end
        else if((EX_rd_addr==rs1||EX_rd_addr==rs2)&&EX_Memread) begin
            flush=1'b0;
            EX_flush=1'b1;
            IFIDwrite=1'b0;
            PCwrite=1'b0;
            IDEX_stall=1'b1;
            EXMEM_stall=1'b1;
            MEMWB_stall=1'b1;
        end
        else begin
            flush=1'b0;
            EX_flush=1'b0;
            IFIDwrite=1'b1;
            PCwrite=1'b1;
            IDEX_stall=1'b1;
            EXMEM_stall=1'b1;
            MEMWB_stall=1'b1;
        end
    end

    /*assign flush=(Branch_Ctrl!=2'b10)?1'b1:1'b0;
    assign hazard=((EX_rd_addr==rs1)|(EX_rd_addr==rs2))&EX_Memread;
    assign EX_flush=flush|hazard;
    assign IFIDwrite=~(hazard|IM_stall|DM_stall);
    assign IDEX_stall=~(IM_stall|DM_stall);
    assign EXMEM_stall=~(IM_stall|DM_stall);
    assign MEMWB_stall=~(IM_stall|DM_stall);
    assign PCwrite=~(hazard|IM_stall|DM_stall);*/
endmodule