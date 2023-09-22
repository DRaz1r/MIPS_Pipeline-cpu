`timescale 1ns / 1ps

`include "Header.vh"

module EX_MEM_Reg(
    input clk,
    input reset_n,

    input [31:0]EX_Instr, // signal for debug
    output reg [31:0] MEM_Instr,

    input EX_RegWrite,
    input EX_MemToReg,
    input EX_MemWrite,
    input [4:0] EX_WriteReg,
    input [31:0] EX_WriteData,
    input [31:0] EX_AluResult,

    input [1:0] Movz_Flag,

    //rd
    input [4:0] EX_rd,
    input [4:0] EX_rt,
    output reg [4:0] MEM_rt,
    output reg [4:0] MEM_rd,
    // 

    input [31:0] EX_PC,
    output reg [31:0] MEM_PC,

    output reg MEM_RegWrite,
    output reg MEM_MemToReg,
    output reg MEM_MemWrite,
    output reg [4:0] MEM_WriteReg,
    output reg [31:0] MEM_WriteData,
    output reg [31:0] MEM_AluResult
    );

    always @(posedge clk) begin
        if (!reset_n) begin
            MEM_RegWrite <= 0;
            MEM_MemToReg <= 0;
            MEM_MemWrite <= 0;

            //rs rt rd
            MEM_rt <= 0;
            MEM_rd <= 0;

            MEM_Instr <= 0;
        end
        else begin
            MEM_RegWrite <=  Movz_Flag == 2'b01 ? 0 : EX_RegWrite; // 注意：MOVZ指令当[rt] != 0时，不对寄存器rd进行任何写回操作。

            MEM_MemToReg <= EX_MemToReg;
            MEM_MemWrite <= EX_MemWrite;
            MEM_WriteReg <= EX_WriteReg;
            MEM_WriteData <= EX_WriteData;
            MEM_AluResult <= EX_AluResult;

            // rd rt
            MEM_rd <= EX_rd;
            MEM_rt <= EX_rt;

            MEM_Instr <= EX_Instr;

            MEM_PC <= EX_PC;
        end
    end
endmodule
