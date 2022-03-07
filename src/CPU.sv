`include "Regfile.sv"
`include "Mux.sv"
`include "MEMWB.sv"
`include "IFID.sv"
`include "IDEX.sv"
`include "Hazard_unit.sv"
`include "Forward_unit.sv"
`include "EXMEM.sv"
`include "Control_unit.sv"
`include "Alu.sv"
`include "PC.sv"
`include "Imm_gen.sv"
`include "BranchCtrl.sv"
`include "AluCtrl.sv"
module CPU(clk,rst,pc_out,instr,chip,MEM_Memread,MEM_Memwrite,mmwrite,MEM_alu_out,MEM_data_in,MEM_data_out,IM_stall,DM_stall);
    input clk,rst;
    output logic [31:0] pc_out;
    input [31:0] instr;
    output logic chip;
    output logic MEM_Memread,MEM_Memwrite;
    output logic [3:0] mmwrite;
    output logic [31:0] MEM_alu_out;
    output logic [31:0] MEM_data_in;
    input [31:0] MEM_data_out;
    input IM_stall,DM_stall;

    //IF
    logic [31:0] pc_in,pc_add4;
    logic [31:0] inst;
    logic flush,IFIDwrite,PCwrite;
    assign pc_add4=pc_out+4;
    PC pc(clk,rst,pc_in,PCwrite,pc_out);
    logic [1:0] Branch_Ctrl;

    always @(*) begin
        if(flush) begin
            inst=0;
        end
        else begin
            inst=instr;
        end
    end
    
    logic [1:0] jump;
    logic zeroflag;

    //ID
    logic [31:0] ID_inst;
    logic [31:0] ID_pc;
    logic[4:0] rd,rs1,rs2;
    logic[2:0] funct3;
    logic[6:0] funct7;
    logic[31:0] imm;
    logic[2:0] ImmType;
    logic[31:0] RS1data,RS2data;
    IFID ifid(clk,rst,pc_out,inst,IFIDwrite,ID_pc,ID_inst);
    assign rd=ID_inst[11:7];
    assign rs1=ID_inst[19:15];
    assign rs2=ID_inst[24:20];
    assign funct3=ID_inst[14:12];
    assign funct7=ID_inst[31:25];

    Imm_gen imm_gen(ImmType,ID_inst,imm);

    logic [2:0] Aluop;
    logic Alusrc,Memread,Memwrite,Memtoreg,Regwrite,PCtoregsrc,RDsrc;
    Control_unit control(ID_inst[6:0],funct3,imm,jump,ImmType,Aluop,Alusrc,Memread,Memwrite,Memtoreg,Regwrite,PCtoregsrc,RDsrc);

    //EX
    logic [31:0] EX_alu_out;
    logic [31:0] EX_pc;
    logic [31:0] EX_imm;
    logic [31:0] EX_rs1_data,EX_rs2_data;
    logic [2:0] EX_funct3;
    logic [6:0] EX_funct7;
    logic [1:0] EX_jump;
    logic EX_flush;
    logic [4:0] EX_rs1_addr,EX_rs2_addr,EX_rd_addr;
    logic [2:0] EX_Aluop;
    logic EX_Alusrc,EX_Memread,EX_Memwrite,EX_Memtoreg,EX_Regwrite,EX_PCtoregsrc,EX_RDsrc;
    logic [31:0] EX_forward_rs2_data;
    logic [6:0] EX_op;
    logic [3:0] EX_mmwrite;
    logic IDEX_stall;
    IDEX idex(
        clk,rst,EX_flush,
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
        ID_inst[6:0],EX_op,
        IDEX_stall
        );

    BranchCtrl branchctrl(EX_jump,zeroflag,Branch_Ctrl);

    logic [4:0] ALU_Ctrl;
    AluCtrl aluctrl(EX_Aluop,EX_funct3,EX_funct7,ALU_Ctrl);

    logic [1:0] forwardrs1src,forwardrs2src;
    logic forwardRDsrc;
    logic [31:0] ALUSrcA,ALUSrcB;
    logic [31:0] pc_to_reg;
    assign pc_to_reg=EX_PCtoregsrc?(EX_pc+4):(EX_pc+EX_imm);

    //MEM
    logic MEM_Memtoreg,MEM_Regwrite,MEM_PCtoregsrc,MEM_RDsrc;
    logic [31:0] MEM_rd_data;
    logic [4:0] MEM_rd_addr;
    logic [31:0] MEM_pc_to_reg;
    logic [31:0] MEM_forward_rs2_data;
    logic [6:0] MEM_op;
    logic [2:0] MEM_funct3;
    logic [3:0] MEM_mmwrite;
    
    assign EX_forward_rs2_data=ALUSrcB;

    logic EXMEM_stall,EXMEM_flush;
    EXMEM exmem(
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

    //WB
    logic WB_Memread,WB_Memwrite,WB_Memtoreg,WB_Regwrite,WB_PCtoregsrc,WB_RDsrc;
    logic [4:0] WB_rd_addr;
    logic [31:0] WB_rrd_data;
    logic [31:0] WB_rd_data;
    logic [31:0] WB_data_out;
    logic [6:0] WB_op;
    logic [2:0] WB_funct3;

    assign MEM_rd_data=MEM_RDsrc?MEM_alu_out:MEM_pc_to_reg;

    logic MEMWB_stall;
    MEMWB memwb(
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

    assign WB_rd_data=WB_Memtoreg?WB_data_out:WB_rrd_data;

    logic [1:0] c_b;
    logic c_h;
    assign c_b=MEM_alu_out%4;
    assign c_h=MEM_alu_out[31:1]%2;
    always @(*) begin
        if(MEM_Memwrite) begin
        MEM_data_in=0;
        case(MEM_funct3) 
            3'b000:begin
                case (c_b)
                    2'b00:begin
                        MEM_data_in[7:0]=MEM_forward_rs2_data[7:0];
                        mmwrite=4'b1110;
                    end 
                    2'b01:begin
                        MEM_data_in[15:8]=MEM_forward_rs2_data[7:0];
                        mmwrite=4'b1101;
                    end 
                    2'b10:begin
                        MEM_data_in[23:16]=MEM_forward_rs2_data[7:0];
                        mmwrite=4'b1011;
                    end 
                    2'b11:begin
                        MEM_data_in[31:24]=MEM_forward_rs2_data[7:0];
                        mmwrite=4'b0111;
                    end 
                endcase
            end
            3'b001:begin
                if(c_h) begin
                    MEM_data_in[31:16]=MEM_forward_rs2_data[15:0]; 
                    mmwrite=4'b0011;  
                end
                else begin
                    MEM_data_in[15:0]=MEM_forward_rs2_data[15:0]; 
                    mmwrite=4'b1100;
                end
            end
            default:begin
                MEM_data_in=MEM_forward_rs2_data;
                mmwrite=4'b0000;
            end
        endcase
        end
        else begin
            MEM_data_in=0;
            mmwrite=4'b1111;
        end
    end

    assign chip=MEM_Memread|MEM_Memwrite;

    Hazard_unit hu(Branch_Ctrl,EX_Memread,EX_rd_addr,rs1,rs2,ImmType,flush,EX_flush,IFIDwrite,PCwrite,IM_stall,DM_stall,IDEX_stall,EXMEM_stall,MEMWB_stall,EXMEM_flush);

    Regfile regfile(~clk,rst,WB_Regwrite,rs1,rs2,WB_rd_addr,WB_rd_data,WB_op,WB_funct3,RS1data,RS2data);

    Forward_unit fu(EX_rs1_addr,EX_rs2_addr,MEM_rd_addr,WB_rd_addr,MEM_Regwrite,WB_Regwrite,WB_Memtoreg,MEM_Memwrite,forwardrs1src,forwardrs2src,forwardRDsrc);
    Mux mux1(forwardrs1src,EX_rs1_data,MEM_rd_data,WB_rd_data,ALUSrcA);
    Mux mux2(forwardrs2src,EX_rs2_data,MEM_rd_data,WB_rd_data,ALUSrcB);

    

    logic [31:0] ALUSrc2;
    assign ALUSrc2 = EX_Alusrc?EX_imm:ALUSrcB;
    Alu alu(ALU_Ctrl,ALUSrcA,ALUSrc2,zeroflag,EX_alu_out);

    always @(*) begin
        case(Branch_Ctrl)
            2'b00:begin
                pc_in=EX_alu_out;
            end
            2'b01:begin
                pc_in=EX_pc+EX_imm;
            end
            2'b10:begin
                pc_in=pc_add4;
            end
            default:begin
                pc_in=0;
            end
        endcase
    end
endmodule