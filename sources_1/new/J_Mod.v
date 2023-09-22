module J_Mod(
    input [25:0] instr_index,
    input [31:0] NPC,
    output [31:0] J_PC
    );
    assign J_PC = {NPC[31:28], instr_index, 2'b00};
endmodule
