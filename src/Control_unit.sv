module Control_unit(op,funct3,imm,jump,ImmType,Aluop,Alusrc,Memread,Memwrite,Memtoreg,Regwrite,PCtoregsrc,RDsrc);
    input [6:0] op;
    input [2:0] funct3;
    input [31:0] imm;
    output logic [1:0] jump;
    output logic [2:0] ImmType;
    output logic [2:0] Aluop;
    output logic Alusrc,Memread,Memwrite,Memtoreg,Regwrite,PCtoregsrc,RDsrc; 

    always @(*) begin
        case(op) 
            7'b0110011:begin //R-type
                jump=2'b00;
                ImmType=3'b000;
                Aluop=3'b000;
                Alusrc=1'b0;
                Memread=1'b0;
                Memwrite=1'b0;
                Memtoreg=1'b0;
                Regwrite=1'b1;
                PCtoregsrc=1'b0;
                RDsrc=1'b1;
            end
            7'b0000011:begin //I-type lw
                jump=2'b00;
                ImmType=3'b000;
                Aluop=3'b001;
                Alusrc=1'b1;
                Memread=1'b1;
                Memwrite=1'b0;
                Memtoreg=1'b1;
                Regwrite=1'b1;
                PCtoregsrc=1'b0;
                RDsrc=1'b1;
            end
            7'b0010011:begin //I-type
                jump=2'b00;
                ImmType=3'b000;
                Aluop=3'b010;
                Alusrc=1'b1;
                Memread=1'b0;
                Memwrite=1'b0;
                Memtoreg=1'b0;
                Regwrite=1'b1;
                PCtoregsrc=1'b0;
                RDsrc=1'b1;
            end
            7'b1100111:begin //I-type jalr
                jump=2'b10;
                ImmType=3'b000;
                Aluop=3'b011;
                Alusrc=1'b1;
                Memread=1'b0;
                Memwrite=1'b0;
                Memtoreg=1'b0;
                Regwrite=1'b1;
                PCtoregsrc=1'b1;
                RDsrc=1'b0;
            end
            7'b0100011:begin //S-type
                jump=2'b00;
                ImmType=3'b001;
                Aluop=3'b001;
                Alusrc=1'b1;
                Memread=1'b0;
                Memwrite=1'b1;
                Memtoreg=1'b0;
                Regwrite=1'b0;
                PCtoregsrc=1'b0;
                RDsrc=1'b1;
            end
            7'b1100011:begin //B-type
                jump=2'b01;
                ImmType=3'b010;
                Aluop=3'b100;
                Alusrc=1'b0;
                Memread=1'b0;
                Memwrite=1'b0;
                Memtoreg=1'b0;
                Regwrite=1'b0;
                PCtoregsrc=1'b0;
                RDsrc=1'b1;
            end
            7'b0010111:begin //u-type auipc
                jump=2'b00;
                ImmType=3'b011;
                Aluop=3'b001;
                Alusrc=1'b1;
                Memread=1'b0;
                Memwrite=1'b0;
                Memtoreg=1'b0;
                Regwrite=1'b1;
                PCtoregsrc=1'b0;
                RDsrc=1'b0;
            end
            7'b0110111:begin //u-type lui
                jump=2'b00;
                ImmType=3'b011;
                Aluop=3'b101;
                Alusrc=1'b1;
                Memread=1'b0;
                Memwrite=1'b0;
                Memtoreg=1'b0;
                Regwrite=1'b1;
                PCtoregsrc=1'b0;
                RDsrc=1'b1;
            end
            7'b1101111:begin //j-type
                jump=2'b11;
                ImmType=3'b100;
                Aluop=3'b110;
                Alusrc=1'b1;
                Memread=1'b0;
                Memwrite=1'b0;
                Memtoreg=1'b0;
                Regwrite=1'b1;
                PCtoregsrc=1'b1;
                RDsrc=1'b0;
            end
            default:begin
                jump=2'b00;
                ImmType=3'b000;
                Aluop=3'b000;
                Alusrc=1'b0;
                Memread=1'b0;
                Memwrite=1'b0;
                Memtoreg=1'b0;
                Regwrite=1'b0;
                PCtoregsrc=1'b0;
                RDsrc=1'b0;
            end
        endcase
    end


endmodule