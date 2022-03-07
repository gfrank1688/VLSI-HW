module EXMEM(
    clk,rst,
    EX_Memread,EX_Memwrite,EX_Memtoreg,EX_Regwrite,EX_PCtoregsrc,EX_RDsrc,
    pc_to_reg,
    EX_alu_out,
    EX_forward_rs2_data,
    EX_rd_addr,
    EX_op,
    EX_funct3,
    MEM_Memread,MEM_Memwrite,MEM_Memtoreg,MEM_Regwrite,MEM_PCtoregsrc,MEM_RDsrc,
    MEM_pc_to_reg,
    MEM_alu_out,
    MEM_forward_rs2_data,
    MEM_rd_addr,
    MEM_op,
    MEM_funct3,
    EXMEM_stall,EXMEM_flush
);
    input clk,rst;
    input EX_Memread,EX_Memwrite,EX_Memtoreg,EX_Regwrite,EX_PCtoregsrc,EX_RDsrc;
    input [31:0] pc_to_reg;
    input [31:0] EX_alu_out;
    input [31:0] EX_forward_rs2_data;
    input [4:0] EX_rd_addr;
    input [6:0] EX_op;
    input [2:0] EX_funct3;
    output logic MEM_Memread,MEM_Memwrite,MEM_Memtoreg,MEM_Regwrite,MEM_PCtoregsrc,MEM_RDsrc;
    output logic [31:0] MEM_pc_to_reg;
    output logic [31:0] MEM_alu_out;
    output logic [31:0] MEM_forward_rs2_data;
    output logic [4:0] MEM_rd_addr;
    output logic [6:0] MEM_op;
    output logic [2:0] MEM_funct3;
    input EXMEM_stall,EXMEM_flush;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            MEM_Memread<=1'b0;
            MEM_Memwrite<=1'b0;
            MEM_Memtoreg<=1'b0;
            MEM_Regwrite<=1'b0;
            MEM_PCtoregsrc<=1'b0;
            MEM_RDsrc<=1'b0;
            MEM_pc_to_reg<=32'b0;
            MEM_alu_out<=32'b0;
            MEM_forward_rs2_data<=32'b0;
            MEM_rd_addr<=5'b0;
            MEM_op<=7'b0;
            MEM_funct3<=3'b0;
        end
        else if(EXMEM_stall)begin
            MEM_Memread<=EX_Memread;
            MEM_Memwrite<=EX_Memwrite;
            MEM_Memtoreg<=EX_Memtoreg;
            MEM_Regwrite<=EX_Regwrite;
            MEM_PCtoregsrc<=EX_PCtoregsrc;
            MEM_RDsrc<=EX_RDsrc;
            MEM_pc_to_reg<=pc_to_reg;
            MEM_alu_out<=EX_alu_out;
            MEM_forward_rs2_data<=EX_forward_rs2_data;
            MEM_rd_addr<=EX_rd_addr;
            MEM_op<=EX_op;
            MEM_funct3<=EX_funct3;
            MEM_Memread<=EX_Memread;
            MEM_Memwrite<=EX_Memwrite;
        end
        /*else if(EXMEM_flush) begin
            MEM_Memread<=1'b0;
            MEM_Memwrite<=1'b0;
        end*/
    end
endmodule