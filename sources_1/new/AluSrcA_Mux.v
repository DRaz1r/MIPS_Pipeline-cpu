`timescale 1ns / 1ps
module AluSrcA_Mux(
    input [31:0] EX_Reg1,
    input [31:0] MEM_AluResult,
    input [31:0] WriteBackData,
    input [4:0] EX_shamt,
    input [1:0] AluSrcA_Sel,
    input EX_AluSrcA,

    output reg [31:0] SrcA
    );

    always @(*) begin
        case ({AluSrcA_Sel, EX_AluSrcA})
            3'b011: SrcA = MEM_AluResult;
            3'b010: SrcA = MEM_AluResult;
            3'b101: SrcA = WriteBackData;
            3'b100: SrcA = WriteBackData;

            3'b000: SrcA = EX_Reg1;
            3'b001: SrcA = {{27{1'b0}}, EX_shamt};
            default: SrcA = EX_Reg1;
        endcase
    end
endmodule
