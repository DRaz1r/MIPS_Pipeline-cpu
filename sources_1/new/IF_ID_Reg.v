`timescale 1ns / 1ps

module IF_ID_Reg(
    input [31:0] IF_Instr,
    input clk,
    input reset_n,
    input stall,
    input [31:0] IF_PC,
    output reg [31:0] ID_PC,

    input [31:0] IF_NPC,
    output [31:0] ID_NPC,

    output reg [31:0] ID_Instr
    );
    assign ID_NPC = IF_NPC; // 待定
    always @(posedge clk) begin
        if (!reset_n) begin
            ID_Instr <= 0;
        end
        else begin
            if (stall) begin
                ID_Instr <= ID_Instr;
                ID_PC <= ID_PC;
            end
            else begin
                ID_Instr <= IF_Instr;
                ID_PC <= IF_PC;
            end
        end
    end
endmodule