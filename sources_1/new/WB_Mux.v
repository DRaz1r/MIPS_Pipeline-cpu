`timescale 1ns / 1ps

module WB_Mux(
    input [31:0] WB_AluResult,
    input [31:0] WB_ReadData,
    input WB_MemToReg,
    output [31:0] WriteBackData
    );
    assign WriteBackData = WB_MemToReg ?  WB_ReadData : WB_AluResult;
endmodule
