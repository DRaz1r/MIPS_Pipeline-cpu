`include "Header.vh"

module CU(
    input [5:0] OP,
    input [5:0] func,
    output RegWrite,
    output MemToReg,
    output MemWrite,
    output [5:0] AluOP,
    output Branch,
    output AluSrcB,
    output AluSrcA,
    output Jump,
    output RegDst
    );
    assign Jump = (OP == `J) | 0;
    assign Branch = (OP == `BNE) | 0;
    assign AluSrcB = (OP == `SW) | (OP == `LW) | | 0;
    assign AluSrcA = (OP == `OPE && func == `SLL) | 0;
    assign RegWrite = (OP == `OPE) | (OP == `LW) | 0;
    assign MemToReg = (OP == `LW) | 0;
    assign MemWrite = (OP == `SW) | 0;
    assign AluOP = ( {6{(OP == `LW || OP == `SW)}} & `ADD ) |
                    ( {6{OP == `BNE}}              & `SUB)  |
                    ( {6{OP == `OPE}}              & func)  | 
                    0;
    
    assign RegDst = ( (OP == `OPE) & 1) |
                    ( (OP == `LW)  & 0) |
                    0;
    
endmodule
