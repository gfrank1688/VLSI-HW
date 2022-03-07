module Imm_gen(ImmType,ID_inst,imm);
    input [2:0] ImmType;
    input [31:0] ID_inst;
    output logic[31:0] imm;

    always @(*) begin
        case(ImmType)
            3'b000:begin //I-type
                imm={{20{ID_inst[31]}},ID_inst[31:20]};
            end
            3'b001:begin //S-type
                imm={{20{ID_inst[31]}},ID_inst[31:25],ID_inst[11:7]};
            end
            3'b010:begin //B-type
                imm={{19{ID_inst[31]}},ID_inst[31],ID_inst[7],ID_inst[30:25],ID_inst[11:8],1'b0};
            end
            3'b011:begin //U-type
                imm={ID_inst[31:12],12'b0};
            end
            3'b100:begin //J-type
                imm={{12{ID_inst[31]}},ID_inst[19:12],ID_inst[20],ID_inst[30:21],1'b0};
            end
            default:begin
                imm=0;
            end
        endcase
    end
endmodule