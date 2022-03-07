module BranchCtrl(jump,zeroflag,Branch_Ctrl);
    input [1:0] jump;
    input zeroflag;
    output logic[1:0] Branch_Ctrl;

    always @(*) begin
        case(jump)
            2'b00:begin //pc+4
                Branch_Ctrl=2'b10;
            end
            2'b01:begin //branch
                if(zeroflag) Branch_Ctrl=2'b01;
                else Branch_Ctrl=2'b10;
            end
            2'b10:begin //jalr
                Branch_Ctrl=2'b00;
            end
            2'b11:begin //jal
                Branch_Ctrl=2'b01;
            end
        endcase
    end
endmodule