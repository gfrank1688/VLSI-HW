module Regfile(clk,rst,WB_Regwrite,rs1,rs2,WB_rd_addr,WB_rd_data,WB_op,WB_funct3,RS1data,RS2data);
     input clk;
     input rst;
     input WB_Regwrite;
     input [4:0] WB_rd_addr;
     input [31:0] WB_rd_data;
     input [4:0] rs1,rs2;
     input [6:0] WB_op;
     input [2:0] WB_funct3;
     output logic [31:0] RS1data,RS2data;

     logic[31:0] reg_file[31:0];
     integer i;

     always@(posedge clk or posedge rst) begin
        if(rst) begin
            for(int i=0;i<32;i++) begin
                reg_file[i]<=0;
            end
        end
        else begin
            if(WB_Regwrite&&WB_rd_addr!=5'b0) begin
                if(WB_op==7'b0000011) begin
                    if(WB_funct3==3'b010) begin
                        reg_file[WB_rd_addr]<=WB_rd_data;
                    end
                    else if(WB_funct3==3'b000) begin
                        reg_file[WB_rd_addr]<={{24{WB_rd_data[7]}},WB_rd_data[7:0]};
                    end
                    else if(WB_funct3==3'b001) begin
                        reg_file[WB_rd_addr]<={{16{WB_rd_data[7]}},WB_rd_data[15:0]};
                    end
                    else if(WB_funct3==3'b101) begin
                        reg_file[WB_rd_addr]<={16'd0,WB_rd_data[15:0]};
                    end
                    else if(WB_funct3==3'b100) begin
                        reg_file[WB_rd_addr]<={24'd0,WB_rd_data[7:0]};
                    end
                    else begin
                        reg_file[WB_rd_addr]<=WB_rd_data;
                    end
                end
                else begin
                    reg_file[WB_rd_addr]<=WB_rd_data;
                end
            end
        end
    end

    assign RS1data=reg_file[rs1];
    assign RS2data=reg_file[rs2];

endmodule