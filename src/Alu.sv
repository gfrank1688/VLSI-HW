module Alu(ALUCtrl,ALUSrcA,ALUSrc2,zeroflag,EX_alu_out);
    input [4:0] ALUCtrl;
    input [31:0] ALUSrcA,ALUSrc2;
    output logic zeroflag;
    output logic [31:0] EX_alu_out;

    always @(ALUSrcA or ALUSrc2 or ALUCtrl) begin
        case (ALUCtrl)
            5'b00000:begin
                EX_alu_out=ALUSrcA+ALUSrc2;
                zeroflag=1'b0;
            end
            5'b00001:begin
                EX_alu_out=ALUSrcA-ALUSrc2;
                zeroflag=1'b0;
            end
            5'b00010:begin
                EX_alu_out=ALUSrcA<<ALUSrc2[4:0];
                zeroflag=1'b0;
            end
            5'b00011:begin
                EX_alu_out=($signed(ALUSrcA)<$signed(ALUSrc2))?1:0;
                zeroflag=1'b0;
            end
            5'b00100:begin
                EX_alu_out=(ALUSrcA<ALUSrc2)?1:0;
                zeroflag=1'b0;
            end
            5'b00101:begin
                EX_alu_out=ALUSrcA^ALUSrc2;
                zeroflag=1'b0;
            end
            5'b00110:begin
                EX_alu_out=ALUSrcA>>ALUSrc2[4:0];
                zeroflag=1'b0;
            end
            5'b00111:begin
                EX_alu_out=$signed(ALUSrcA)>>>ALUSrc2[4:0];
                zeroflag=1'b0;
            end
            5'b01000:begin
                EX_alu_out=ALUSrcA|ALUSrc2;
                zeroflag=1'b0;
            end
            5'b01001:begin
                EX_alu_out=ALUSrcA&ALUSrc2;
                zeroflag=1'b0;
            end
            5'b01010:begin
                if(ALUSrcA==ALUSrc2) zeroflag=1'b1;
                else zeroflag=1'b0;
                EX_alu_out=32'b0;
            end
            5'b01011:begin
                if(ALUSrcA!=ALUSrc2) zeroflag=1'b1;
                else zeroflag=1'b0;
                EX_alu_out=32'b0;
            end
            5'b01100:begin
                if($signed(ALUSrcA)<$signed(ALUSrc2)) zeroflag=1'b1;
                else zeroflag=1'b0;
                EX_alu_out=32'b0;
            end
            5'b01101:begin
                if($signed(ALUSrcA)>=$signed(ALUSrc2)) zeroflag=1'b1;
                else zeroflag=1'b0;
                EX_alu_out=32'b0;
            end
            5'b01110:begin
                if(ALUSrcA<ALUSrc2) zeroflag=1'b1;
                else zeroflag=1'b0;
                EX_alu_out=32'b0;
            end
            5'b01111:begin
                if(ALUSrcA>=ALUSrc2) zeroflag=1'b1;
                else zeroflag=1'b0;
                EX_alu_out=32'b0;
            end
            5'b10000:begin
                EX_alu_out=ALUSrc2;
                zeroflag=1'b0;
            end
            5'b10001:begin
                EX_alu_out=(ALUSrcA+ALUSrc2)&{28'hfffffff,4'b1110};
                zeroflag=1'b0;
            end
            default:begin
                zeroflag=1'b0;
                EX_alu_out=32'b0;
            end
        endcase    
    end
endmodule