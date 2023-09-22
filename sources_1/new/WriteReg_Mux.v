module WriteReg_Mux(
    input [4:0] rt,
    input [4:0] rd,
    input RegDst,
    output [4:0] ID_WriteReg
    );
    assign ID_WriteReg = RegDst ? rd : rt;
endmodule
