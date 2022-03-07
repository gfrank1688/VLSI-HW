module Mux(forward,rs_data,MEM_rd_data,WB_rd_data,ALUSrc);
    input [1:0] forward;
    input [31:0] rs_data,MEM_rd_data,WB_rd_data;
    output logic [31:0] ALUSrc;

    always @(*) begin
        case(forward)
            2'b00:begin
                ALUSrc=rs_data;
            end
            2'b01:begin
                ALUSrc=MEM_rd_data;
            end
            2'b10:begin
                ALUSrc=WB_rd_data;
            end
            default:begin
                ALUSrc=0;
            end
        endcase
    end
endmodule