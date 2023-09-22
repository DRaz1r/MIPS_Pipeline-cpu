module SigExt(
    input [15:0] offset,
    output [31:0] Imm
    );
    assign Imm = offset[15] ? {16'hffff, offset} : {16'h0000, offset};
endmodule
