`timescale 1ns / 1ps

module MEM_WB_Reg(
    input clk,
    input reset_n,

    input [31:0]MEM_Instr, // signal for debug
    output reg [31:0] WB_Instr,

    input MEM_RegWrite,
    input MEM_MemToReg,
    input MEM_MemWrite,
    input [4:0] MEM_WriteReg,
    input [31:0] MEM_AluResult,
    input [31:0] MEM_ReadData,

    //rd rt
    input [4:0] MEM_rd,
    input [4:0] MEM_rt,
    output reg [4:0] WB_rd,
    output reg [4:0] WB_rt,
    // 

    input [31:0] MEM_PC,
    output reg [31:0] WB_PC,

    output reg WB_RegWrite,
    output reg WB_MemToReg,
    output reg WB_MemWrite,
    output reg [4:0] WB_WriteReg,
    output reg [31:0] WB_AluResult,
    output reg [31:0] WB_ReadData
    );

    always @(posedge clk) begin
        if (!reset_n) begin
            WB_RegWrite <= 0;
            WB_MemToReg <= 0;
            WB_MemWrite <= 0;

            WB_rd <= 0;
            WB_rt <= 0;

            WB_Instr <= 0;
        end
        else begin
            WB_RegWrite <= MEM_RegWrite;
            WB_MemToReg <= MEM_MemToReg;
            WB_MemWrite <= MEM_MemWrite;
            WB_WriteReg <= MEM_WriteReg;
            WB_AluResult <= MEM_AluResult;
            WB_ReadData <= MEM_ReadData;

            //rd rt
            WB_rd <= MEM_rd;
            WB_rt <= MEM_rt;

            WB_Instr <= MEM_Instr;

            WB_PC <= MEM_PC;
        end
    end
endmodule
