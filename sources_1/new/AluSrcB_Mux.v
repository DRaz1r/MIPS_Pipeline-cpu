module AluSrcB_Mux(
    input [1:0] AluSrcB_Sel,
    input EX_AluSrcB,
    input [31:0] EX_Reg2,
    input [31:0] EX_Imm,
    input [31:0] WriteBackData,
    input [31:0] MEM_AluResult,
    output reg [31:0] SrcB
    );

    always @(*) begin
        case({AluSrcB_Sel, EX_AluSrcB})
            3'b100: SrcB = MEM_AluResult;
            3'b101: SrcB = MEM_AluResult;
            3'b011: SrcB = WriteBackData;
            3'b010: SrcB = WriteBackData;
            
            3'b000: SrcB = EX_Reg2;
            3'b001: SrcB = EX_Imm;
            default: SrcB = EX_Reg2;
        endcase
    end
endmodule
