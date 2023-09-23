`timescale 1ns / 1ps

module ForwardUnit(
    input [4:0] EX_rs,
    input [4:0] EX_rt,
    input [4:0] EX_rd,
    input EX_MemWrite,

    input [4:0] MEM_rd,
    input [4:0] MEM_rt,
    input MEM_RegWrite,
    input MEM_MemToReg,
    input MEM_MemWrite,


    input [4:0] WB_rd,
    input [4:0] WB_rt,
    input WB_RegWrite,
    input WB_MemToReg,

    output [1:0] AluSrcA_Sel,
    output [1:0] AluSrcB_Sel,
    output [1:0] WriteData_Sel
    );
    
    // 2023/9/20 后续这里判断直接用指令可能更清晰
    // assign MemRead = RegWrite & MemToReg; LW
    assign AluSrcB_Sel = ( MEM_RegWrite & (~MEM_MemToReg) & (MEM_rd != 0) & (MEM_rd == EX_rt) ) ? 2'b10 : // Read after Write
                         ( WB_RegWrite  & (~WB_MemToReg)  & (WB_rd != 0)  & (WB_rd == EX_rt)  ) ? 2'b01 : // Read after Write
                         ( WB_RegWrite  &  WB_MemToReg    & (~EX_MemWrite)& (WB_rt != 0)  & (WB_rt == EX_rt)  ) ? 2'b01 : // load-use
                        2'b00;   
    assign AluSrcA_Sel = ( MEM_RegWrite & (~MEM_MemToReg) & (MEM_rd != 0) & (MEM_rd == EX_rs)) ? 2'b01 : // Read after Write
                         ( WB_RegWrite  & (~WB_MemToReg)  & (WB_rd != 0)  & (WB_rd == EX_rs) ) ? 2'b10 : // Read after Write
                         ( WB_RegWrite  &  WB_MemToReg    & (~EX_MemWrite)& (WB_rt != 0)  & (WB_rt == EX_rs) ) ? 2'b10 : // load-use
                        2'b00;

    // Save after load 
    assign WriteData_Sel[0] = ( WB_RegWrite  &  WB_MemToReg & EX_MemWrite & (WB_rt != 0)  & (WB_rt == EX_rt)  ) ? 1'b1 :
                           1'b0;
    assign WriteData_Sel[1] = ( WB_RegWrite  &  WB_MemToReg & MEM_MemWrite & (WB_rt != 0)  & (WB_rt == MEM_rt)  ) ? 1'b1 :
                           1'b0;                    
endmodule
