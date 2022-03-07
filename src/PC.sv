module PC(clk,rst,pc_in,PCwrite,pc_out);
    input clk,rst,PCwrite;
    input [31:0] pc_in;
    output logic[31:0] pc_out;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            pc_out<=0;
        end
        else begin
            if(PCwrite) pc_out<=pc_in;
        end
    end
endmodule