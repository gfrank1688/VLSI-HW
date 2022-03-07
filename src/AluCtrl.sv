module AluCtrl(EX_Aluop,EX_funct3,EX_funct7,ALUCtrl);
    input [2:0] EX_Aluop;
    input [2:0] EX_funct3;
    input [6:0] EX_funct7;
    output logic[4:0] ALUCtrl;

    always @(*) begin
        case(EX_Aluop)
            3'b000:begin
                case (EX_funct3)
                    3'b000:begin
                        if(EX_funct7==7'b0000000) ALUCtrl=5'b00000; //add
                        else ALUCtrl=5'b00001; //sub
                    end
                    3'b001:begin
                        ALUCtrl=5'b00010; //sll
                    end
                    3'b010:begin
                        ALUCtrl=5'b00011; //slt
                    end
                    3'b011:begin
                        ALUCtrl=5'b00100; //sltu
                    end
                    3'b100:begin
                        ALUCtrl=5'b00101; //xor
                    end
                    3'b101:begin
                        if(EX_funct7==7'b0000000) ALUCtrl=5'b00110; //srl
                        else ALUCtrl=5'b00111; //sra;
                    end
                    3'b110:begin
                        ALUCtrl=5'b01000; //or
                    end
                    3'b111:begin
                        ALUCtrl=5'b01001; //and
                    end
                endcase
            end
            3'b001:begin
                ALUCtrl=5'b00000; //lw&sw
            end
            3'b010:begin
                case (EX_funct3)
                    3'b000:begin
                        ALUCtrl=5'b00000; //addi
                    end
                    3'b010:begin
                        ALUCtrl=5'b00011; //slti
                    end
                    3'b011:begin
                        ALUCtrl=5'b00100; //sltiu
                    end
                    3'b100:begin
                        ALUCtrl=5'b00101; //xori
                    end
                    3'b110:begin
                        ALUCtrl=5'b01000; //ori
                    end
                    3'b111:begin
                        ALUCtrl=5'b01001; //andi
                    end
                    3'b001:begin
                        ALUCtrl=5'b00010; //slli
                    end
                    3'b101:begin
                        if(EX_funct7==7'b0000000) ALUCtrl=5'b00110; //srli
                        else ALUCtrl=5'b00111; //srai
                    end
                endcase
            end
            3'b100:begin
                case(EX_funct3)
                    3'b000:begin 
                        ALUCtrl=5'b01010; //beq
                    end
                    3'b001:begin
                        ALUCtrl=5'b01011; //bne
                    end
                    3'b100:begin
                        ALUCtrl=5'b01100; //blt
                    end
                    3'b101:begin
                        ALUCtrl=5'b01101; //bge
                    end
                    3'b110:begin
                        ALUCtrl=5'b01110; //bltu
                    end
                    3'b111:begin
                        ALUCtrl=5'b01111; //bgeu
                    end
                    default:begin
                        ALUCtrl=5'd0;
                    end
                endcase
            end
            3'b101:begin
                ALUCtrl=5'b10000; //lui
            end
            3'b011:begin
                ALUCtrl=5'b10001; //jalr
            end
            default:begin
                        ALUCtrl=5'd0;
            end
        endcase
    end
endmodule