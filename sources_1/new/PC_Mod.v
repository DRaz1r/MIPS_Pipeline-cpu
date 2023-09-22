`timescale 1ns / 1ps

module PC_Mod(
    input clk,     // 时钟
    input reset_n, // 是否重置地址。0-初始化PC，否则接受新地址     
    input stall,  
    input [31:0] PC_Result,
    output reg [31:0] PC
);  
    
    initial begin
        PC <= 0;
    end
    always @(posedge clk or negedge reset_n)  
    begin  
        if (! reset_n) // 如果为0则初始化PC，否则接受新地址
            begin  
                PC <= 0;
            end  
        else begin
            if (stall) begin
                PC <= PC;
            end
            else begin
                PC <= PC_Result;
            end
        end  
    end  
endmodule
