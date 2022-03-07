module IFID(clk,rst,pc_out,inst,IFIDwrite,ID_pc,ID_inst);
    input clk,rst;
    input [31:0] pc_out,inst;
    input IFIDwrite;
    output logic [31:0] ID_pc,ID_inst;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            ID_pc<=0;
            ID_inst<=0;
        end
        else begin
            if(IFIDwrite) begin
                ID_pc<=pc_out;
                ID_inst<=inst;
            end
        end
    end
endmodule