module Branch_Mod(
    input [31:0] Imm,
    input [31:0] NPC,
    output [31:0] Branch_PC
    );
    assign Branch_PC = (Imm << 2) + NPC;
endmodule
