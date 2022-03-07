module IDEX(
    clk,rst,flush,
    Aluop,Alusrc,Memread,Memwrite,Memtoreg,Regwrite,PCtoregsrc,RDsrc,
    RS1data,RS2data,
    ID_pc,
    imm,
    funct3,funct7,
    rs1,rs2,rd,
    EX_Aluop,EX_Alusrc,EX_Memread,EX_Memwrite,EX_Memtoreg,EX_Regwrite,EX_PCtoregsrc,EX_RDsrc,
    EX_rs1_data,EX_rs2_data,
    EX_pc,
    EX_imm,
    EX_funct3,EX_funct7,
    EX_rs1_addr,EX_rs2_addr,EX_rd_addr,
    jump,EX_jump,
    op,EX_op,
    IDEX_stall
    );
    input clk,rst,flush;
    input [2:0] Aluop;
    input Alusrc,Memread,Memwrite,Memtoreg,Regwrite,PCtoregsrc,RDsrc;
    input [31:0] RS1data,RS2data;
    input [31:0] ID_pc;
    input [31:0] imm;
    input [2:0] funct3;
    input [6:0] funct7;
    input [4:0] rs1,rs2,rd;
    input [1:0] jump;
    input [6:0] op;
    output logic [2:0] EX_Aluop;
    output logic EX_Alusrc,EX_Memread,EX_Memwrite,EX_Memtoreg,EX_Regwrite,EX_PCtoregsrc,EX_RDsrc;
    output logic [31:0] EX_rs1_data,EX_rs2_data;
    output logic [31:0] EX_pc;
    output logic [31:0] EX_imm;
    output logic [2:0] EX_funct3;
    output logic [6:0] EX_funct7;
    output logic [4:0] EX_rs1_addr,EX_rs2_addr,EX_rd_addr;
    output logic [1:0] EX_jump;
    output logic [6:0] EX_op;
    input IDEX_stall;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            EX_Aluop<=3'd0;
            EX_Alusrc<=1'b0;
            EX_Memread<=1'b0;
            EX_Memwrite<=1'b0;
            EX_Memtoreg<=1'b0;
            EX_Regwrite<=1'b0;
            EX_PCtoregsrc<=1'b0;
            EX_RDsrc<=1'b0;
            EX_rs1_data<=32'd0;
            EX_rs2_data<=32'd0;
            EX_pc<=32'd0;
            EX_imm<=32'd0;
            EX_funct3<=3'd0;
            EX_funct7<=7'd0;
            EX_rs1_addr<=5'd0;
            EX_rs2_addr<=5'd0;
            EX_rd_addr<=5'd0;
            EX_jump<=2'd0;
            EX_op<=7'd0;
     
        end
        else begin
            if(IDEX_stall) begin
                EX_Aluop<=Aluop;
                EX_Alusrc<=Alusrc;
                EX_Memread<=(flush)?1'b0:Memread;
                EX_Memwrite<=(flush)?1'b0:Memwrite;
                EX_Memtoreg<=Memtoreg;
                EX_Regwrite<=(flush)?1'b0:Regwrite;
                EX_PCtoregsrc<=PCtoregsrc;
                EX_RDsrc<=RDsrc;
                EX_rs1_data<=RS1data;
                EX_rs2_data<=RS2data;
                EX_pc<=ID_pc;
                EX_imm<=imm;
                EX_funct3<=funct3;
                EX_funct7<=funct7;
                EX_rs1_addr<=rs1;
                EX_rs2_addr<=rs2;
                EX_rd_addr<=rd;
                EX_jump<=(flush)?2'b0:jump;
                EX_op<=op;
                end
            else if ((~IDEX_stall)&&flush) begin
                EX_Memread<=1'b0;
                EX_Memwrite<=1'b0;
                EX_Regwrite<=1'b0;
            end
        end
    end
endmodule